
import '../characters/character_entity.dart';
import 'basic.dart';
import 'effect_entity.dart';

class Effect {
  /// 角色id、光锥id、遗器id
  String majorId = '';
  /// 技能id、行迹id、星魂rank、遗器套装
  String minorId = '';
  /// effect.iid
  String effectId = '';
  late EffectEntity entity;

  Effect.empty() {
    this.entity = EffectEntity();
  }

  Effect.fromEntity(EffectEntity entity, String majorId, String minorId) {
    this.majorId = majorId;
    this.minorId = minorId;
    this.effectId = entity.iid;
    this.entity = entity;
  }

  String getKey() {
    return "$majorId-$minorId-$effectId";
  }

  bool validSelfBuffEffect(FightProp? prop) {
    if (this.entity.multiplier <= 0 || this.entity.iid == '') {
      return false;
    }
    FightProp fp = FightProp.fromEffectKey(this.entity.addtarget);
    if (fp == FightProp.unknown || prop != null && fp != prop) {
      return false;
    }
    if (this.entity.type == 'buff') {
      return this.entity.tag.contains('allally') || this.entity.tag.contains('self');
    } else if (this.entity.type == 'debuff') {
      return this.entity.tag.contains('allenemy') || this.entity.tag.contains('singleenemy');
    }
    return false;
  }

  bool validDamageHealEffect(String type) {
    if (this.entity.multiplier <= 0 || this.entity.iid == '') {
      return false;
    }
    return this.entity.type == type;
  }

  double getEffectMultiplierValue(CharacterSkilldata? skillData, int? skillLevel) {
    double multiplierValue = this.entity.multiplier;
    if (skillData != null && skillLevel != null && multiplierValue <= skillData.levelmultiplier.length && multiplierValue == multiplierValue.toInt()) {
      Map<String, dynamic> levelMultiplier = skillData.levelmultiplier[multiplierValue.toInt() - 1];
      if (levelMultiplier.containsKey('default')) {
        multiplierValue = double.tryParse(levelMultiplier['default'].toString()) ?? 0;
      } else {
        multiplierValue = double.tryParse(levelMultiplier[skillLevel.toString()].toString()) ?? 0;
      }
    }
    multiplierValue *= this.entity.maxStack;
    return multiplierValue;
  }
}

class EffectConfig {
  bool on = false;
}
