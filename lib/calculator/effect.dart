import 'package:math_expressions/math_expressions.dart';

import '../components/global_state.dart';
import '../relics/relic_manager.dart';
import 'basic.dart';
import 'effect_entity.dart';
import 'skill_data.dart';

class Effect {
  static final GlobalState _gs = GlobalState();
  static final Parser formulaParser = Parser();
  static final ContextModel cm = ContextModel();
  static final characterType = 1;
  static final lightconeType = 2;
  static final relicType = 3;
  static final manualType = 4;
  static final breakDamageType = 5;

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

  Effect.manualBuff(FightProp prop) {
    this.type = manualType;
    this.majorId = 'manual';
    this.effectId = prop.name;
    this.entity = EffectEntity();
    this.entity.iid = this.effectId;
    this.entity.type = 'buff';
    this.entity.addtarget = prop.effectKey.isNotEmpty ? prop.effectKey[0] : '';
    this.entity.multiplier = 0;
    this.entity.tag = ['self', this.entity.addtarget];
    this.skillData = SkillData();
    this.skillData.maxlevel = -1;
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

  String getReferenceTarget(String lang) {
    switch(lang) {
      case 'en':
        return this.entity.referencetargetEN;
      case 'zh':
        return this.entity.referencetargetCN;
      case 'cn':
        return this.entity.referencetargetCN;
      case 'ja':
        return this.entity.referencetargetJP;
    }
    return '';
  }

  bool hasBuffConfig() {
    return hasChoiceConfig() || hasStackConfig() || hasValueFieldConfig();
  }

  bool hasChoiceConfig() {
    return this.entity.maxStack > 1 && this.entity.maxStack < 5;
  }

  bool hasStackConfig() {
    return this.entity.maxStack >= 5;
  }

  bool hasValueFieldConfig() {
    return this.type == manualType || this.type == Effect.characterType && this.majorId != _gs.stats.id && this.entity.multipliertarget != '';
  }

  bool validSelfBuffEffect(FightProp? prop) {
    if (this.type != manualType && this.entity.multiplier <= 0 || this.entity.iid == '') {
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

  bool isBuffOrDebuff() {
    return this.entity.type == 'buff' || this.entity.type == 'debuff';
  }

  bool isDamageHealShield() {
    return this.entity.type == 'dmg' || this.entity.type == 'break' || this.entity.type == 'heal' || this.entity.type == 'shield';
  }

  double getEffectMultiplierValue(SkillData? skillData, int? skillLevel, EffectConfig? effectConfig) {
    double multiplier = this.entity.multiplier;
    String multiplierValue = this.entity.multipliervalue;
    if (multiplierValue != '') {
      Expression expr = formulaParser.parse(multiplierValue);
      multiplier = expr.evaluate(EvaluationType.REAL, cm);
    } else {
      if (skillData != null && skillLevel != null && multiplier <= skillData.levelmultiplier.length && skillData.maxlevel >= 0) {
        Map<String, dynamic> levelMultiplier = skillData.levelmultiplier[multiplier.toInt() - 1];
        if (levelMultiplier.containsKey('default')) {
          multiplier = double.tryParse(levelMultiplier['default'].toString()) ?? 0;
        } else {
          multiplier = double.tryParse(levelMultiplier[skillLevel.toString()].toString()) ?? 0;
        }
      }
    }
    int stack = this.entity.maxStack;
    if ((effectConfig?.stack ?? 0) > 0) {
      stack = effectConfig!.stack;
    }
    FightProp multiplierProp = FightProp.fromEffectKey(this.entity.multipliertarget);
    if (multiplierProp != FightProp.unknown && isBuffOrDebuff()) {
      multiplier *= effectConfig?.value ?? 0;
      if (multiplierProp.isPercent()) {
        multiplier /= 100;
      }
    } else {
      if ((effectConfig?.value ?? 0) > 0) {
        multiplier = effectConfig!.value;
      }
    }
    multiplier *= stack;
    return multiplier;
  }

  String getSkillName(String lang) {
    if (type == relicType && majorId != '') {
      return RelicManager.getRelic(majorId).getName(lang) + minorId;
    }
    return skillData.getName(lang);
  }

  /// 将group相同的effect放到一组，展示为一个伤害/治疗/护盾
  static Map<String, List<Effect>> groupEffect(List<Effect> effects) {
    Map<String, List<Effect>> effectGroup = {};
    effects.forEach((e) {
      if (e.entity.group != '') {
        List<Effect> list = effectGroup[e.entity.group] ?? [];
        list.add(e);
        effectGroup[e.entity.group] = list;
      } else {
        // key不重复就行，随便构造的
        effectGroup["${DateTime.now().millisecondsSinceEpoch}-${e.hashCode}"] = [e];
      }
    });
    return effectGroup;
  }
}

class EffectConfig {
  bool on = false;
  int stack = 0;
  double value = 0;

  EffectConfig.defaultOn() {
    this.on = true;
  }

  EffectConfig.defaultOff() {
    this.on = false;
  }
}
