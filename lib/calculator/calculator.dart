
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
  normal(crit: true, breakDmg: false),
  dot(crit: false, breakDmg: false),
  followup(crit: true, breakDmg: false),
  additional(crit: true, breakDmg: false),
  breakWeakness(crit: false, breakDmg: true),
  breakWeaknessDot(crit: false, breakDmg: true),
  breakWeaknessAdditional(crit: false, breakDmg: true);

  final bool crit;
  final bool breakDmg;

  const DamageType({
    required this.crit,
    required this.breakDmg,
  });

  static DamageType fromName(String name) {
    return DamageType.values.firstWhere((e) => e.name == name, orElse: () => DamageType.normal);
  }

  static DamageType fromEffectTags(List<String> tags) {
    if (tags.isEmpty) {
      return DamageType.normal;
    }
    if (tags.contains("dotatk")) {
      return DamageType.dot;
    } else if (tags.contains("followupatk")) {
      return DamageType.followup;
    } else if (tags.contains("additionalatk")) {
      return DamageType.additional;
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
  double damageBonus;
  if (damageType.breakDmg) {
    damageBonus = attrValues[FightProp.breakDamageAddedRatio] ?? 0;
    if (damageType == DamageType.breakWeaknessDot) {
      damageBonus += attrValues[FightProp.dotDamageAddRatio] ?? 0;
    } else if (damageType == DamageType.breakWeaknessAdditional) {
      damageBonus += attrValues[FightProp.additionalDamageAddRatio] ?? 0;
    }
  } else {
    double elementBonus = attrValues[elementType.getElementAddRatioProp()] ?? 0;
    double allBonus = attrValues[FightProp.allDamageAddRatio] ?? 0;
    damageBonus = elementBonus + allBonus;
    if (damageType == DamageType.normal) {
      damageBonus += attrValues[attackTypeBonusMapping[attackType] ?? FightProp.unknown] ?? 0;
    } else if (damageType == DamageType.dot) {
      damageBonus += attrValues[FightProp.dotDamageAddRatio] ?? 0;
    } else if (damageType == DamageType.followup) {
      damageBonus += attrValues[FightProp.followupAttackAddRatio] ?? 0;
    }
  }
  damageBonus += 1;

  // 易伤
  double elementReceive = attrValues[elementType.getElementDamageReceiveRatioProp()] ?? 0;
  double allDamageReceive = attrValues[FightProp.allDamageReceiveRatio] ?? 0;
  double dotDamageReceive = 0;
  if (damageType == DamageType.dot || damageType == DamageType.breakWeaknessDot) {
    dotDamageReceive = attrValues[FightProp.dotDamageReceiveRatio] ?? 0;
  } else if (damageType == DamageType.additional || damageType == DamageType.breakWeaknessAdditional) {
    dotDamageReceive += attrValues[FightProp.additionalDamageReceiveRatio] ?? 0;
  }
  double vulnerable = 1 + min(elementReceive + allDamageReceive + dotDamageReceive, 3.5);

  // 敌方减伤
  double weaknessReduce;
  if (damageType.breakDmg) {
    if (damageType == DamageType.breakWeakness) {
      weaknessReduce = 0.1;
    } else {
      weaknessReduce = 0;
    }
  } else {
    weaknessReduce = enemyStats.weaknessBreak ? 0 : 0.1;
  }
  double otherReduce = 0;
  double damageReduce = (1 - weaknessReduce) * (1 - otherReduce);

  // 抗性
  int res = enemy.resistence[elementType] ?? 0;
  double allResIgnore = attrValues[FightProp.allResistanceIgnore] ?? 0;
  double resIgnore = attrValues[elementType.getElementResistanceIgnoreProp()] ?? 0;
  double specificResIgnore = attrValues[FightProp.specificResistanceIgnore] ?? 0;
  double resFinal =  1 - (res / 100 - resIgnore - allResIgnore - specificResIgnore);

  // 防御力
  int characterLevel = int.tryParse(stats.level.replaceAll('+', '')) ?? 1;
  double defenceIgnore = 0;
  if (!damageType.breakDmg) {
    defenceIgnore += attrValues[FightProp.defenceIgnoreRatio] ?? 0;
  }
  double defenceReduce = attrValues[FightProp.defenceReduceRatio] ?? 0;
  defenceReduce += enemyStats.defenceReduce / 100;
  double enemyDefence = (enemyStats.level + 20) * max(1 - defenceIgnore - defenceReduce, 0);
  double defenceFactor = (characterLevel + 20) / (characterLevel + 20 + enemyDefence);

  // 韧性
  double toughness = (enemyStats.toughness + 2) / 4;

  double multiplierValue = multiplier / 100;
  double nonCrit = base * multiplierValue * damageBonus * vulnerable * damageReduce * resFinal * defenceFactor;
  if (damageType.breakDmg) {
    nonCrit *= toughness;
  }
  double crit = damageType.crit ? nonCrit * (1 + critDamage) : 0;
  double exp = damageType.crit ? nonCrit * (1 + critChance * critDamage) : 0;

  String critStr = "* (1 + ${critChance.toStringAsFixed(3)} * ${critDamage.toStringAsFixed(3)}) ";
  details = "$attackType: ${base.toStringAsFixed(3)} * ${multiplierValue.toStringAsFixed(3)} "
      "${damageType.crit ? critStr : ''}* ${damageBonus.toStringAsFixed(3)} "
      "* ${vulnerable.toStringAsFixed(3)} * ${damageReduce.toStringAsFixed(3)} * ${resFinal.toStringAsFixed(3)} * ${defenceFactor.toStringAsFixed(3)} "
      "${damageType.breakDmg ? '* $toughness ' : ''}= ${(damageType.crit ? exp : nonCrit).toStringAsFixed(3)}";
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
