import 'package:math_expressions/math_expressions.dart';

import '../relics/relic_manager.dart';
import 'basic.dart';
import 'effect_entity.dart';
import 'skill_data.dart';

class Effect {
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

  bool hasBuffConfig(String currentCid) {
    return hasChoiceConfig() || hasStackConfig() || hasValueFieldConfig(currentCid);
  }

  bool hasChoiceConfig() {
    return this.entity.maxStack > 1 && this.entity.maxStack < 5;
  }

  bool hasStackConfig() {
    return this.entity.maxStack >= 5;
  }

  bool hasValueFieldConfig(String currentCid) {
    return this.type == manualType || showDependPropValueConfig(currentCid);
  }

  bool hasDependProp() {
    return this.isCharacterType() && isBuffOrDebuff() && this.entity.multipliertarget != '';
  }

  bool showDependPropValueConfig(String currentCid) {
    FightProp multiplierProp = FightProp.fromEffectKey(this.entity.multipliertarget);
    return hasDependProp() && (currentCid != majorId || multiplierProp.fake);
  }

  bool validSelfBuffEffect(FightProp? prop, {FightProp? dependProp, String currentCid = ''}) {
    if (this.entity.iid == '') {
      return false;
    }
    FightProp fp = FightProp.fromEffectKey(this.entity.addtarget);
    if (fp == FightProp.unknown || prop != null && fp != prop) {
      return false;
    }
    if (dependProp != null) {
      FightProp dp = FightProp.fromEffectKey(this.entity.multipliertarget);
      if (dp != dependProp || showDependPropValueConfig(currentCid)) {
        return false;
      }
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
    if (this.entity.iid == '') {
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
    return this.entity.type == type && this.entity.iid != '';
  }

  bool isBuffOrDebuff() {
    return this.entity.type == 'buff' || this.entity.type == 'debuff';
  }

  bool isDamageHealShield() {
    return this.entity.type == 'dmg' || this.entity.type == 'break' || this.entity.type == 'heal' || this.entity.type == 'revive' || this.entity.type == 'shield';
  }

  bool isCharacterType() {
    return this.type == characterType;
  }

  bool isLightconeType() {
    return this.type == lightconeType;
  }

  bool isRelicType() {
    return this.type == relicType;
  }

  bool isManualType() {
    return this.type == manualType;
  }

  bool isBreakDamageType() {
    return this.type == breakDamageType;
  }

  bool isCharacterSelf() {
    return this.type == characterType && this.entity.tag.contains('self');
  }

  bool isCharacterAlly() {
    return this.type == characterType && (this.entity.tag.contains('allally') || this.entity.tag.contains('singleally'));
  }

  double getEffectMultiplierValue(SkillData? skillData, int? skillLevel, EffectConfig? effectConfig) {
    double multiplier = this.entity.multiplier;
    String multiplierValue = this.entity.multipliervalue;
    if (multiplierValue != '') {
      Expression expr = formulaParser.parse(multiplierValue);
      multiplier = expr.evaluate(EvaluationType.REAL, cm);
    } else {
      if (skillData != null && skillLevel != null && multiplier == multiplier.roundToDouble() && multiplier <= skillData.levelmultiplier.length && skillData.levelmultiplier.length > 0 && skillData.maxlevel >= 0) {
        Map<String, dynamic> levelMultiplier = skillData.levelmultiplier[multiplier.toInt() - 1];
        if (levelMultiplier.containsKey('default')) {
          multiplier = double.tryParse(levelMultiplier['default'].toString()) ?? 0;
        } else {
          multiplier = double.tryParse(levelMultiplier[skillLevel.toString()].toString()) ?? 0;
        }
      }
    }

    FightProp multiProp = FightProp.fromEffectMultiplier(this.entity.multipliertarget);
    FightProp addProp = FightProp.fromEffectKey(this.entity.addtarget);
    if (isBuffOrDebuff()) {
      if (this.entity.multipliertarget != '') {
        // 概率类的不使用config
        if (!multiProp.isProbability() && multiProp != FightProp.unknown) {
          multiplier *= effectConfig?.value ?? 0;
        }
        // 如果是基于某属性加成，认为一定是按百分比加成
        // TODO 发版后修正符玄战技、卡芙卡战技和终结技数据
        if (multiProp != FightProp.unknown) {
          multiplier /= 100;
        }
      } else {
        if ((effectConfig?.value ?? 0) > 0) {
          multiplier = effectConfig!.value;
        }
      }
      // 如果加成的目标属性为百分比
      if (addProp.isPercent()) {
        multiplier /= 100;
      }
    } else if (isDamageHealShield()) {
      // 如果是伤害治疗类的，通过是否存在multipliertarget(倍率属性)判断
      if (multiProp != FightProp.none) {
        multiplier /= 100;
      }
    }

    int stack = this.entity.maxStack;
    if ((effectConfig?.stack ?? 0) > 0) {
      stack = effectConfig!.stack;
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
