
import 'dart:math';

import '../characters/character.dart';
import '../characters/character_entity.dart';
import '../characters/character_manager.dart';
import '../characters/character_stats.dart';
import '../enemies/enemy.dart';
import '../utils/helper.dart';
import 'basic.dart';
import 'effect_entity.dart';

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

DamageResult calculateDamage(CharacterStats stats, EnemyStats enemyStats, double multiplier, FightProp baseProp, DamageType damageType, ElementType elementType) {
  if (multiplier == 0) {
    return DamageResult.zero();
  }
  Map<FightProp, double> attrValues = stats.calculateSumStats();
  double base = attrValues[baseProp] ?? 0;
  if (base == 0) {
    return DamageResult.zero();
  }

  // 暴击爆伤
  double critChance = attrValues[FightProp.criticalChance] ?? 0;
  double critDamage = attrValues[FightProp.criticalDamage] ?? 0;

  // 增伤
  double damageBonus = attrValues[elementDamage[elementType]] ?? 0;

  // 减伤
  double damageReduce = enemyStats.weaknessBreak ? 1 : 0.9;

  // 易伤

  // 抗性/穿透

  // 防御力
  int characterLevel = int.tryParse(stats.level.replaceAll('+', '')) ?? 1;
  double defenceIgnore = attrValues[FightProp.defenceIgnore] ?? 0;
  double enemyDefence = (enemyStats.level + 20) * max(1 - defenceIgnore, 0);
  double defenceFactor = (characterLevel + 20) / (characterLevel + 20 + enemyDefence);

  double nonCrit = base * multiplier / 100 * (1 + damageBonus) * damageReduce * defenceFactor;
  double crit = nonCrit * (1 + critDamage);
  double exp = nonCrit * (1 + critChance * critDamage);
  return DamageResult(nonCrit, exp, crit);
}