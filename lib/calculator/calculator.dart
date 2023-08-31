
import 'dart:math';

import '../characters/character.dart';
import '../characters/character_manager.dart';
import '../characters/character_stats.dart';
import '../enemies/enemy.dart';
import '../enemies/enemy_manager.dart';
import '../utils/helper.dart';
import '../utils/logging.dart';
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

  DamageResult.zero();

  DamageResult(double nonCrit, double expectation, double crit) {
    this.nonCrit = nonCrit;
    this.expectation = expectation;
    this.crit = crit;
  }
}

enum DamageType {
  normal,
  dot,
  followup,
  breakWeakness;

  static DamageType fromEffectTags(List<String> tags) {
    if (tags.isEmpty) {
      return DamageType.normal;
    }
    if (tags.contains("dotatk")) {
      return DamageType.normal;
    } else if (tags.contains("followupatk")) {
      return DamageType.followup;
    }
    return DamageType.normal;
  }
}

DamageResult calculateDamage(CharacterStats stats, EnemyStats enemyStats, double multiplier, FightProp baseProp, String attackType, DamageType damageType, ElementType elementType, {debug = false}) {
  if (multiplier == 0) {
    return DamageResult.zero();
  }
  Map<FightProp, double> attrValues = stats.calculateSumStats();
  double base = attrValues[baseProp] ?? 0;
  if (base == 0) {
    return DamageResult.zero();
  }

  Character character = CharacterManager.getCharacter(stats.id);
  Enemy enemy = EnemyManager.getEnemy(enemyStats.id);

  // 暴击爆伤
  double critChance = attrValues[FightProp.criticalChance] ?? 0;
  double critDamage = attrValues[FightProp.criticalDamage] ?? 0;
  if (damageType == DamageType.normal) {
    critChance += attrValues[attackTypeCritMapping[attackType] ?? FightProp.none] ?? 0;
    critDamage += attrValues[attackTypeCritDamageMapping[attackType] ?? FightProp.none] ?? 0;
  }

  // 增伤
  double elementBonus = attrValues[elementDamage[elementType]] ?? 0;
  double allBonus = attrValues[FightProp.allDamageAddRatio] ?? 0;
  double damageBonus = elementBonus + allBonus;
  if (damageType == DamageType.normal) {
    damageBonus += attrValues[attackTypeBonusMapping[attackType] ?? FightProp.none] ?? 0;
  }
  damageBonus += 1;

  // 易伤
  double allDamageReceive = attrValues[FightProp.allDamageReceiveRatio] ?? 0;
  double vulnerable = 1 + min(allDamageReceive, 3.5);

  // 减伤
  double weaknessReduce = enemyStats.weaknessBreak ? 0 : 0.1;
  double otherReduce = 0;
  double damageReduce = (1 - weaknessReduce) * (1 - otherReduce);

  // 抗性
  int res = enemy.resistence[elementType] ?? 0;
  double resIgnore = attrValues[elementResIgnore[elementType]] ?? 0;
  double resFinal =  1 - (res / 100 - resIgnore);

  // 防御力
  int characterLevel = int.tryParse(stats.level.replaceAll('+', '')) ?? 1;
  double defenceIgnore = attrValues[FightProp.defenceIgnoreRatio] ?? 0;
  double defenceReduce = attrValues[FightProp.defenceReduceRatio] ?? 0;
  defenceReduce += enemyStats.defenceReduce / 100;
  double enemyDefence = (enemyStats.level + 20) * max(1 - defenceIgnore - defenceReduce, 0);
  double defenceFactor = (characterLevel + 20) / (characterLevel + 20 + enemyDefence);

  double nonCrit = base * multiplier / 100 * damageBonus * vulnerable * damageReduce * resFinal * defenceFactor;
  double crit = nonCrit * (1 + critDamage);
  double exp = nonCrit * (1 + critChance * critDamage);
  if (debug) {
    logger.d("$attackType: ${base.toStringAsFixed(3)} * ${(multiplier / 100).toStringAsFixed(3)} "
        "* (1 + ${critChance.toStringAsFixed(3)} * ${critDamage.toStringAsFixed(3)}) * ${damageBonus.toStringAsFixed(3)} "
        "* ${vulnerable.toStringAsFixed(3)} * ${damageReduce.toStringAsFixed(3)} * ${resFinal.toStringAsFixed(3)} * ${defenceFactor.toStringAsFixed(3)} "
        "= ${exp.toStringAsFixed(3)}");
  }
  return DamageResult(nonCrit, exp, crit);
}