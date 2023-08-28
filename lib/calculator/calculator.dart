
import '../characters/character.dart';
import '../characters/character_entity.dart';
import '../characters/character_manager.dart';
import '../characters/character_stats.dart';
import '../utils/helper.dart';
import 'basic.dart';
import 'effect_entity.dart';

class DamageResult {
  double nonCrit = 0;
  double expectation = 0;
  double crit = 0;

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

DamageResult calculateDamage(CharacterStats stats, double multiplier, FightProp baseProp, DamageType damageType, ElementType elementType) {
  if (multiplier == 0) {
    return DamageResult(0, 0, 0);
  }
  Map<FightProp, double> attrValues = stats.calculateSumStats();
  double base = attrValues[baseProp] ?? 0;
  if (base == 0) {
    return DamageResult(0, 0, 0);
  }
  double nonCrit = base * multiplier / 100;
  double crit = nonCrit * (1 + (attrValues[FightProp.criticalDamage] ?? 0));
  double exp = nonCrit * (1 + (attrValues[FightProp.criticalChance] ?? 0) * (attrValues[FightProp.criticalDamage] ?? 0));
  return DamageResult(nonCrit, exp, crit);
}