import '../relics/relic_manager.dart';
import 'basic.dart';
import 'effect_entity.dart';
import 'skill_data.dart';

class Effect {
  static final characterType = 1;
  static final lightconeType = 2;
  static final relicType = 3;

  /// 默认来自角色
  int type = 1;
  /// 角色id、光锥id、遗器id
  String majorId = '';
  /// 角色对应技能id、行迹id、星魂rank，光锥为空，遗器对应2/4件套
  String minorId = '';
  /// effect.iid
  String effectId = '';
  late EffectEntity entity;
  late SkillData skillData;

  Effect.empty() {
    this.entity = EffectEntity();
    this.skillData = SkillData();
  }

  Effect.fromEntity(EffectEntity entity, String majorId, String minorId, {int? type}) {
    if (type != null) {
      this.type = type;
    }
    this.majorId = majorId;
    this.minorId = minorId;
    this.effectId = entity.iid;
    this.entity = entity;
  }

  String getKey() {
    return "$majorId-$minorId-$effectId";
  }

  bool hasBuffConfig() {
    return this.entity.maxStack > 1;
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
      if (fp == FightProp.speedDelta) {
        return false;
      }
      return this.entity.tag.contains('allenemy') || this.entity.tag.contains('singleenemy');
    }
    return false;
  }

  bool validAllyBuffEffect(FightProp? prop) {
    if (this.entity.multiplier <= 0 || this.entity.iid == '') {
      return false;
    }
    FightProp fp = FightProp.fromEffectKey(this.entity.addtarget);
    if (fp == FightProp.unknown || prop != null && fp != prop) {
      return false;
    }
    if (this.entity.type == 'buff') {
      if (fp == FightProp.aggro) {
        return false;
      }
      return this.entity.tag.contains('allally') || this.entity.tag.contains('singleally');
    } else if (this.entity.type == 'debuff') {
      if (fp == FightProp.speedDelta) {
        return false;
      }
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

  double getEffectMultiplierValue(SkillData? skillData, int? skillLevel, EffectConfig? effectConfig) {
    double multiplierValue = this.entity.multiplier;
    if (skillData != null && skillLevel != null && multiplierValue <= skillData.levelmultiplier.length && multiplierValue == multiplierValue.toInt()) {
      Map<String, dynamic> levelMultiplier = skillData.levelmultiplier[multiplierValue.toInt() - 1];
      if (levelMultiplier.containsKey('default')) {
        multiplierValue = double.tryParse(levelMultiplier['default'].toString()) ?? 0;
      } else {
        multiplierValue = double.tryParse(levelMultiplier[skillLevel.toString()].toString()) ?? 0;
      }
    }
    int stack = this.entity.maxStack;
    if (effectConfig != null && effectConfig.stack > 0) {
      stack = effectConfig.stack;
    }
    multiplierValue *= stack;
    return multiplierValue;
  }

  String getSkillName(String lang) {
    if (type == relicType && majorId != '') {
      return RelicManager.getRelic(majorId).getName(lang) + minorId;
    }
    return skillData.getName(lang);
  }
}

class EffectConfig {
  bool on = false;
  int stack = 0;

  EffectConfig.defaultOn() {
    this.on = true;
  }

  EffectConfig.defaultOff() {
    this.on = false;
  }
}
