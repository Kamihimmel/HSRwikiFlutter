
import 'dart:math';

import '../characters/character_stats.dart';
import '../enemies/enemy.dart';
import '../enemies/enemy_manager.dart';
import '../utils/helper.dart';
import 'basic.dart';

const attackTypeBonusMapping = {
  'basicattack': FightProp.basicAttackAddRatio,
  'skill': FightProp.skillAttackAddRatio,
  'ult': FightProp.ultimateAttackAddRatio,
};
const attackTypeCritMapping = {
  'basicattack': FightProp.basicAttackCriticalChange,
  'skill': FightProp.skillAttackCriticalChange,
  'ult': FightProp.ultimateAttackCriticalChange,
};
const attackTypeCritDamageMapping = {
  'basicattack': FightProp.basicAttackCriticalDamage,
  'skill': FightProp.skillAttackCriticalChange,
  'ult': FightProp.ultimateAttackCriticalDamage,
};

class DamageResult {
  double nonCrit = 0;
  double expectation = 0;
  double crit = 0;
  String details = '';

  DamageResult.zero({details = ''}) {
    this.details = details;
  }

  DamageResult(double nonCrit, double expectation, double crit, {details = ''}) {
    this.nonCrit = nonCrit;
    this.expectation = expectation;
    this.crit = crit;
    this.details = details;
  }

  bool isEmpty() {
    return nonCrit == 0 && expectation == 0 && crit == 0;
  }
}

enum DamageType {
  normal(crit: true),
  dot(crit: false),
  followup(crit: true),
  breakWeakness(crit: false);

  final crit;

  const DamageType({
    required this.crit,
  });

  static DamageType fromEffectTags(List<String> tags) {
    if (tags.isEmpty) {
      return DamageType.normal;
    }
    if (tags.contains("dotatk")) {
      return DamageType.dot;
    } else if (tags.contains("followupatk")) {
      return DamageType.followup;
    }
    return DamageType.normal;
  }
}

DamageResult calculateDamage(CharacterStats stats, EnemyStats enemyStats, double multiplier, FightProp? baseProp, String attackType, DamageType damageType, ElementType elementType) {
  String details = '';
  if (multiplier == 0) {
    details = "$attackType: multiplier == 0";
    return DamageResult.zero(details: details);
  }
  Map<FightProp, double> attrValues = stats.calculateSumStats();
  double base = baseProp == FightProp.none ? 100 : (attrValues[baseProp] ?? 0);
  if (base == 0) {
    details = "$attackType: base == 0";
    return DamageResult.zero(details: details);
  }
  Enemy enemy = EnemyManager.getEnemy(enemyStats.id);

  // 暴击爆伤
  double critChance = attrValues[FightProp.criticalChance] ?? 0;
  double critDamage = attrValues[FightProp.criticalDamage] ?? 0;
  if (damageType == DamageType.normal) {
    critChance += attrValues[attackTypeCritMapping[attackType] ?? FightProp.unknown] ?? 0;
    critDamage += attrValues[attackTypeCritDamageMapping[attackType] ?? FightProp.unknown] ?? 0;
  }

  // 增伤
  double elementBonus = attrValues[elementType.getElementAddRatioProp()] ?? 0;
  double allBonus = attrValues[FightProp.allDamageAddRatio] ?? 0;
  double damageBonus = elementBonus + allBonus;
  if (damageType == DamageType.normal) {
    damageBonus += attrValues[attackTypeBonusMapping[attackType] ?? FightProp.unknown] ?? 0;
  } else if (damageType == DamageType.dot) {
    damageBonus += attrValues[FightProp.dotDamageAddRatio] ?? 0;
  } else if (damageType == DamageType.followup) {
    damageBonus += attrValues[FightProp.followupAttackAddRatio] ?? 0;
  } else if (damageType == DamageType.breakWeakness) {
    damageBonus += attrValues[FightProp.breakDamageAddedRatio] ?? 0;
  }
  damageBonus += 1;

  // 易伤
  double elementReceive = attrValues[elementType.getElementDamageReceiveRatioProp()] ?? 0;
  double allDamageReceive = attrValues[FightProp.allDamageReceiveRatio] ?? 0;
  double dotDamageReceive = 0;
  if (damageType == DamageType.dot) {
    dotDamageReceive = attrValues[FightProp.dotDamageReceiveRatio] ?? 0;
  }
  double vulnerable = 1 + min(elementReceive + allDamageReceive + dotDamageReceive, 3.5);

  // 减伤
  double weaknessReduce = enemyStats.weaknessBreak ? 0 : 0.1;
  double otherReduce = 0;
  double damageReduce = (1 - weaknessReduce) * (1 - otherReduce);

  // 抗性
  int res = enemy.resistence[elementType] ?? 0;
  double allResIgnore = attrValues[FightProp.allResistanceIgnore] ?? 0;
  double resIgnore = attrValues[elementType.getElementResistanceIgnoreProp()] ?? 0;
  double resFinal =  1 - (res / 100 - resIgnore - allResIgnore);

  // 防御力
  int characterLevel = int.tryParse(stats.level.replaceAll('+', '')) ?? 1;
  double defenceIgnore = attrValues[FightProp.defenceIgnoreRatio] ?? 0;
  double defenceReduce = attrValues[FightProp.defenceReduceRatio] ?? 0;
  defenceReduce += enemyStats.defenceReduce / 100;
  double enemyDefence = (enemyStats.level + 20) * max(1 - defenceIgnore - defenceReduce, 0);
  double defenceFactor = (characterLevel + 20) / (characterLevel + 20 + enemyDefence);

  double multiplierValue = multiplier / 100;
  double nonCrit = base * multiplierValue * damageBonus * vulnerable * damageReduce * resFinal * defenceFactor;
  double crit = damageType.crit ? nonCrit * (1 + critDamage) : 0;
  double exp = damageType.crit ? nonCrit * (1 + critChance * critDamage) : 0;

  String critStr = "* (1 + ${critChance.toStringAsFixed(3)} * ${critDamage.toStringAsFixed(3)}) ";
  details = "$attackType: ${base.toStringAsFixed(3)} * ${multiplierValue.toStringAsFixed(3)} "
      "${damageType.crit ? critStr : ''}* ${damageBonus.toStringAsFixed(3)} "
      "* ${vulnerable.toStringAsFixed(3)} * ${damageReduce.toStringAsFixed(3)} * ${resFinal.toStringAsFixed(3)} * ${defenceFactor.toStringAsFixed(3)} "
      "= ${(damageType.crit ? exp : nonCrit).toStringAsFixed(3)}";
  return DamageResult(nonCrit, exp, crit, details: details);
}

DamageResult calculateHeal(CharacterStats stats, double multiplier, FightProp? baseProp) {
  String details = '';
  if (multiplier == 0) {
    details = "heal: multiplier == 0";
    return DamageResult.zero(details: details);
  }
  Map<FightProp, double> attrValues = stats.calculateSumStats();
  double base = baseProp == FightProp.none ? 100 : (attrValues[baseProp] ?? 0);
  if (base == 0) {
    details = "heal: base == 0";
    return DamageResult.zero(details: details);
  }

  // 治疗加成
  double healRatio = attrValues[FightProp.healRatio] ?? 0;
  double healBonus = 1 + healRatio;

  double multiplierValue = multiplier / 100;
  double nonCrit = base * multiplierValue * healBonus;

  details = "heal: ${base.toStringAsFixed(3)} * ${multiplierValue.toStringAsFixed(3)} "
      "* ${healBonus.toStringAsFixed(3)} = ${nonCrit.toStringAsFixed(3)}";
  return DamageResult(nonCrit, 0, 0, details: details);
}

DamageResult calculateShield(CharacterStats stats, double multiplier, FightProp? baseProp) {
  String details = '';
  if (multiplier == 0) {
    details = "shield: multiplier == 0";
    return DamageResult.zero(details: details);
  }
  Map<FightProp, double> attrValues = stats.calculateSumStats();
  double base = baseProp == FightProp.none ? 100 : (attrValues[baseProp] ?? 0);
  if (base == 0) {
    details = "shield: base == 0";
    return DamageResult.zero(details: details);
  }

  // 护盾加成
  double shieldRatio = attrValues[FightProp.shieldAddRatio] ?? 0;
  double shieldBonus = 1 + shieldRatio;

  double multiplierValue = multiplier / 100;
  double nonCrit = base * multiplierValue * shieldBonus;

  details = "shield: ${base.toStringAsFixed(3)} * ${multiplierValue.toStringAsFixed(3)} "
      "* ${shieldBonus.toStringAsFixed(3)} = ${nonCrit.toStringAsFixed(3)}";
  return DamageResult(nonCrit, 0, 0, details: details);
}
