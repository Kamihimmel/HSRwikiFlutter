import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:hsrwikiproject/calculator/effect_entity.dart';

import '../calculator/basic.dart';
import '../calculator/effect.dart';
import '../calculator/effect_manager.dart';
import '../lightcones/lightcone.dart';
import '../lightcones/lightcone_manager.dart';
import '../relics/relic.dart';
import '../relics/relic_manager.dart';
import '../utils/helper.dart';
import '../utils/logging.dart';
import 'character.dart';
import 'character_manager.dart';

class CharacterStats {
  String id = '';
  String updateTime = '';
  String level = '1';
  int promotion = 0;
  Map<String, int> eidolons = {};
  Map<String, int> skillLevels = {};
  Map<String, int> traceLevels = {};
  String lightconeId = '';
  String lightconeLevel = '1';
  int lightconeRank = 1;
  Map<RelicPart, RelicStats> relics = {};
  Map<String, EffectConfig> damageEffect = {};
  Map<String, EffectConfig> healEffect = {};
  Map<String, EffectConfig> shieldEffect = {};
  Map<String, EffectConfig> selfSkillEffect = {};
  Map<String, EffectConfig> selfTraceEffect = {};
  Map<String, EffectConfig> selfEidolonEffect = {};
  Map<String, EffectConfig> lightconeEffect = {};
  Map<String, EffectConfig> relicEffect = {};
  Map<String, EffectConfig> otherEffect = {};
  Map<String, EffectConfig> manualEffect = {};

  /// import stats
  Map<FightProp, double> importStats = {};

  String getLightconeId() {
    if (lightconeId == '') {
      return CharacterManager.getDefaultLightcone(id);
    }
    return lightconeId;
  }

  List<String> getRelicSets({withDefault = false}) {
    if (withDefault && relics.isEmpty) {
      return CharacterManager.getDefaultRelicSets(id);
    }
    List<String> sets = ['', '', ''];
    List<String> setIds4 = relics.entries.where((e) => e.key.xSet == '4').map((e) => e.value.setId).toList();
    Map<String, int> validSet4 = setIds4.fold({}, (value, e) {
      int cnt = value[e] ?? 0;
      value[e] = cnt + 1;
      return value;
    });
    if (validSet4.values.any((v) => v == 4)) {
      String sId = validSet4.entries.firstWhere((e) => e.value == 4).key;
      sets[0] = sId;
      sets[1] = sId;
    } else {
      List<String> validSet2 = validSet4.entries.where((e) => e.value >= 2).map((e) => e.key.toString()).toList();
      for (var i = 0; i < validSet2.length; i++) {
        sets[i] = validSet2[i];
      }
    }
    List<String> setIds2 = relics.entries.where((e) => e.key.xSet == '2').map((e) => e.value.setId).toList();
    if (setIds2.length == 2 && setIds2[0] == setIds2[1]) {
      sets[2] = setIds2[0];
    }
    return sets;
  }

  static List<FightProp> getCalculatedFightProps() {
    List<FightProp> props = [];

    // 基础
    props.add(FightProp.maxHP);
    props.add(FightProp.attack);
    props.add(FightProp.defence);
    props.add(FightProp.speed);
    props.add(FightProp.sPRatio);
    props.add(FightProp.aggro);

    // 治疗护盾
    props.add(FightProp.healRatio);
    props.add(FightProp.shieldAddRatio);

    // 暴击爆伤
    props.add(FightProp.criticalChance);
    props.add(FightProp.criticalDamage);
    props.add(FightProp.basicAttackCriticalChange);
    props.add(FightProp.skillAttackCriticalChange);
    props.add(FightProp.ultimateAttackCriticalChange);
    props.add(FightProp.followupAttackCriticalChange);
    props.add(FightProp.basicAttackCriticalDamage);
    props.add(FightProp.skillAttackCriticalDamage);
    props.add(FightProp.ultimateAttackCriticalDamage);
    props.add(FightProp.followupAttackCriticalDamage);

    // 击破特攻、效果相关
    props.add(FightProp.breakDamageBase);
    props.add(FightProp.breakDamageAddedRatio);
    props.add(FightProp.effectHitRate);
    props.add(FightProp.effectResistenceRate);

    // 伤害加成
    props.add(FightProp.allDamageAddRatio);
    props.addAll(ElementType.getElementAddRatioProps());
    props.add(FightProp.basicAttackAddRatio);
    props.add(FightProp.skillAttackAddRatio);
    props.add(FightProp.ultimateAttackAddRatio);
    props.add(FightProp.followupAttackAddRatio);
    props.add(FightProp.dotDamageAddRatio);

    // 抗性穿透
    props.addAll(ElementType.getElementResistanceIgnoreProps());

    // 增加受到伤害
    props.add(FightProp.allDamageReceiveRatio);
    props.add(FightProp.dotDamageReceiveRatio);
    props.addAll(ElementType.getElementDamageReceiveRatioProps());

    // 敌人debuff
    props.add(FightProp.defenceIgnoreRatio);
    props.add(FightProp.defenceReduceRatio);
    props.add(FightProp.speedReduceRatio);
    props.add(FightProp.allResistanceIgnore);
    props.add(FightProp.specificResistanceIgnore);
    props.addAll(ElementType.getElementResistanceProps());

    // 其他
    props.add(FightProp.lostHP);
    props.add(FightProp.damageReduceRatio);
    props.add(FightProp.allDotDamage);
    props.add(FightProp.shockedDotDamage);
    props.add(FightProp.burnDotDamage);
    props.add(FightProp.windshearDotDamage);
    props.add(FightProp.bleedDotDamage);

    return props;
  }

  Map<FightProp, Map<PropSource, double>> calculateStats() {
    Map<FightProp, Map<PropSource, double>> map = {};
    for (FightProp prop in getCalculatedFightProps()) {
      map[prop] = getPropValue(prop);
    }
    return map;
  }

  Map<FightProp, double> calculateSumStats() {
    Map<FightProp, Map<PropSource, double>> attrValues = calculateStats();
    Map<FightProp, double> result = {};
    attrValues.forEach((key, value) {
      result[key] = value.values.fold(0, (pre, v) => pre + v);
    });
    return result;
  }

  Map<PropSource, double> getHp() {
    Map<PropSource, double> result = {};

    Character c = CharacterManager.getCharacter(id);
    double characterHp = c.getBaseHp(num.tryParse(level.replaceAll('+', ''))?.toInt() ?? 0, promotion: level.contains('+'));
    result[PropSource.characterBasic(id)] = characterHp;

    Lightcone lc = LightconeManager.getLightcone(lightconeId);
    double lightconeHp = lc.getBaseHp(num.tryParse(lightconeLevel.replaceAll('+', ''))?.toInt() ?? 0, promotion: lightconeLevel.contains('+'));
    result[PropSource.lightconeAttr(lightconeId)] = lightconeHp;

    double baseHp = characterHp + lightconeHp;
    Map<FightProp, double> props = {FightProp.hPAddedRatio: baseHp, FightProp.hPDelta: 1};
    _addAttrValue(result, c, lc, props);
    _addAttrValue(result, c, lc, props, dependProp: FightProp.maxHP, dependValue: result.values.fold(0, (pre, v) => pre! + v));
    return result;
  }

  Map<PropSource, double> getAtk() {
    Map<PropSource, double> result = {};

    Character c = CharacterManager.getCharacter(id);
    double characterAtk = c.getBaseAtk(num.tryParse(level.replaceAll('+', ''))?.toInt() ?? 0, promotion: level.contains('+'));
    result[PropSource.characterBasic(id)] = characterAtk;

    Lightcone lc = LightconeManager.getLightcone(lightconeId);
    double lightconeAtk = lc.getBaseAtk(num.tryParse(lightconeLevel.replaceAll('+', ''))?.toInt() ?? 0, promotion: lightconeLevel.contains('+'));
    result[PropSource.lightconeAttr(lightconeId)] = lightconeAtk;

    double baseAtk = characterAtk + lightconeAtk;
    Map<FightProp, double> props = {FightProp.attackAddedRatio: baseAtk, FightProp.attackDelta: 1};
    _addAttrValue(result, c, lc, props);
    _addAttrValue(result, c, lc, props, dependProp: FightProp.attack, dependValue: result.values.fold(0, (pre, v) => pre! + v));
    return result;
  }

  Map<PropSource, double> getDef() {
    Map<PropSource, double> result = {};

    Character c = CharacterManager.getCharacter(id);
    double characterDef = c.getBaseDef(num.tryParse(level.replaceAll('+', ''))?.toInt() ?? 0, promotion: level.contains('+'));
    result[PropSource.characterBasic(id)] = characterDef;

    Lightcone lc = LightconeManager.getLightcone(lightconeId);
    double lightconeDef = lc.getBaseDef(num.tryParse(lightconeLevel.replaceAll('+', ''))?.toInt() ?? 0, promotion: lightconeLevel.contains('+'));
    result[PropSource.lightconeAttr(lightconeId)] = lightconeDef;

    double baseDef = characterDef + lightconeDef;
    Map<FightProp, double> props = {FightProp.defenceAddedRatio: baseDef, FightProp.defence: 1};
    _addAttrValue(result, c, lc, props);
    _addAttrValue(result, c, lc, props, dependProp: FightProp.defence, dependValue: result.values.fold(0, (pre, v) => pre! + v));
    return result;
  }

  Map<PropSource, double> getBreakDamageBase() {
    Map<PropSource, double> result = {};
    int levelNum = num.tryParse(level.replaceAll('+', ''))?.toInt() ?? 0;
    double breakBase = breakBaseMapping[levelNum] ?? 0;
    result[PropSource.characterBasic(id)] = breakBase;
    return result;
  }

  Map<PropSource, double> getPropValue(FightProp prop) {
    if (prop == FightProp.maxHP) {
      return getHp();
    } else if (prop == FightProp.attack) {
      return getAtk();
    } else if (prop == FightProp.defence) {
      return getDef();
    } else if (prop == FightProp.breakDamageBase) {
      return getBreakDamageBase();
    }

    Map<PropSource, double> result = {};
    Character c = CharacterManager.getCharacter(id);
    Lightcone lc = LightconeManager.getLightcone(lightconeId);
    Map<FightProp, double> props = {prop: 1};
    FightProp dependProp = prop;

    if (prop == FightProp.aggro) {
      result[PropSource.characterBasic(id)] = c.entity.dtaunt.toDouble();
    } else if (prop == FightProp.speed) {
      result[PropSource.characterBasic(id)] = c.entity.dspeed.toDouble();
      props = {FightProp.speedDelta: 1, FightProp.speedAddedRatio: c.entity.dspeed.toDouble()};
    } else if (prop == FightProp.criticalChance) {
      result[PropSource.characterBasic(id)] = 0.05;
    } else if (prop == FightProp.criticalDamage) {
      result[PropSource.characterBasic(id)] = 0.5;
    } else if (prop == FightProp.sPRatio) {
      result[PropSource.characterBasic(id)] = 1;
    } else if (prop == FightProp.lostHP) {
      double base = getPropValue(FightProp.maxHP).values.fold(0, (pre, v) => pre + v);
      props = {FightProp.lostHPRatio: base};
    }

    _addAttrValue(result, c, lc, props);
    _addAttrValue(result, c, lc, props, dependProp: dependProp, dependValue: result.values.fold(0, (pre, v) => pre! + v));
    return result;
  }

  void _addAttrValue(Map<PropSource, double> result, Character character, Lightcone lightcone, Map<FightProp, double> props, {FightProp? dependProp, double? dependValue}) {
    for (var e in props.entries) {
      FightProp prop = e.key;
      double base = e.value;
      Map<PropSource, double> temp = {};
      if (dependProp == null) {
        _addLightconeSkillValue(temp, lightcone, base, prop);
        _addRelicAttrValue(temp, base, prop);
        _addRelicSetEffectValue(temp, base, prop);
        _addCharacterSkillValue(temp, character, base, prop);
        _addCharacterTraceValue(temp, character, base, prop);
        _addCharacterEidolonValue(temp, character, base, prop);
        _addOtherSkillValue(temp, character, base, prop);
        _addManualEffectValue(temp, character, base, prop);
      } else {
        // 只有角色的effect支持根据依赖的属性计算
        _addCharacterSkillValue(temp, character, 1, prop, dependProp: dependProp, dependValue: dependValue);
        _addCharacterTraceValue(temp, character, 1, prop, dependProp: dependProp, dependValue: dependValue);
        _addCharacterEidolonValue(temp, character, 1, prop, dependProp: dependProp, dependValue: dependValue);
      }
      temp.forEach((key, value) {
        result[key] = (result[key] ?? 0) + value;
      });
    }
  }

  void _addLightconeSkillValue(Map<PropSource, double> result, Lightcone lightcone, double base, FightProp prop) {
    lightcone.entity.skilldata.forEach((t) {
      if (t.effect.isEmpty) {
        return;
      }
      t.effect.map((e) => Effect.fromEntity(e, lightconeId, '', type: Effect.lightconeType)).where((e) => e.validSelfBuffEffect(prop)).forEach((effect) {
        String effectKey = effect.getKey();
        EffectConfig effectConfig = lightconeEffect[effectKey] ?? EffectConfig.defaultOn();
        if (!effectConfig.on) {
          return;
        }
        double multiplierValue = effect.getEffectMultiplierValue(t, lightconeRank, effectConfig);
        result[PropSource.lightconeEffect(lightconeId, effect)] = base * multiplierValue;
      });
    });
  }

  void _addRelicAttrValue(Map<PropSource, double> result, double base, FightProp prop) {
    for (var e in relics.entries) {
      double mainValue = 0;
      double mainV = e.value.getMainAttrValueByProp(prop);
      if (prop.isPercent()) {
        mainValue += base * mainV;
      } else {
        mainValue += mainV;
      }
      result[PropSource.relicAttr(e.key, mainAttr: true)] = mainValue;
      double subValue = 0;
      double subV = e.value.getSubAttrValueByProp(prop);
      if (prop.isPercent()) {
        subValue += base * subV;
      } else {
        subValue += subV;
      }
      result[PropSource.relicAttr(e.key, mainAttr: false)] = subValue;
    }
  }

  void _addRelicSetEffectValue(Map<PropSource, double> result, double base, FightProp prop) {
    List<String> relicSets = getRelicSets();
    if (relicSets.length == 3) {
      for (var i = 0; i < relicSets.length; i++) {
        String rs = relicSets[i];
        if (rs == '') {
          continue;
        }
        int skillIndex = 0; // 0: set2; 1: set4
        String setNum = '2';
        if (i == 1 && rs == relicSets[0]) {
          skillIndex = 1;
          setNum = '4';
        }
        Relic relic = RelicManager.getRelic(rs);
        if (relic.entity.skilldata.length > skillIndex) {
          // TODO 非固定基础值问题，如命中2件套攻击力效果
          relic.entity.skilldata[skillIndex].effect.map((e) => Effect.fromEntity(e, rs, setNum, type: Effect.relicType)).where((e) => e.validSelfBuffEffect(prop)).forEach((effect) {
            String effectKey = effect.getKey();
            EffectConfig effectConfig = relicEffect[effectKey] ?? EffectConfig.defaultOn();
            if (!effectConfig.on) {
              return;
            }
            double multiplierValue = effect.getEffectMultiplierValue(null, null, effectConfig);
            result[PropSource.relicSetEffect(rs, effect, name: effect.minorId)] = base * multiplierValue;
          });
        }
      }
    }
  }

  void _addCharacterSkillValue(Map<PropSource, double> result, Character character, double base, FightProp prop, {FightProp? dependProp, double? dependValue}) {
    character.entity.skilldata.forEach((s) {
      if (s.effect.isEmpty || s.maxlevel > 0 && (skillLevels[s.id] ?? 0) == 0) {
        return;
      }
      s.effect.map((e) => Effect.fromEntity(e, character.entity.id, s.id)).where((e) => e.validSelfBuffEffect(prop, dependProp: dependProp, currentCid: id)).forEach((effect) {
        String effectKey = effect.getKey();
        EffectConfig effectConfig = selfSkillEffect[effectKey] ?? EffectConfig.defaultOn();
        if (!effectConfig.on) {
          return;
        }
        if (effect.entity.group != '') {
          for (EffectEntity skillEffectEntity in s.effect) {
            Effect skillEffect = Effect.fromEntity(skillEffectEntity, character.entity.id, s.id);
            if (skillEffectEntity.group == effect.entity.group && !(selfSkillEffect[skillEffect.getKey()] ?? EffectConfig.defaultOn()).on) {
              // 同group的effect如果关闭了，此effect也认为关闭
              return;
            }
          }
        }
        int? skillLevel = skillLevels[s.id];
        if (s.referencelevel != '') {
          // 引用技能等级
          skillLevel = skillLevels[character.getSkillById(s.referencelevel).id];
        }
        if (dependProp != null) {
          effectConfig = EffectConfig.defaultOn();
          double v = dependValue ?? 0;
          if (dependProp.isPercent()) {
            v *= 100;
          }
          effectConfig.value = v;
        }
        double multiplierValue = effect.getEffectMultiplierValue(s, skillLevel, effectConfig);
        result[PropSource.characterSkill(effectKey, effect, self: true)] = base * multiplierValue;
      });
    });
  }

  void _addCharacterTraceValue(Map<PropSource, double> result, Character character, double base, FightProp prop, {FightProp? dependProp, double? dependValue}) {
    character.entity.tracedata.forEach((t) {
      if (t.effect.isEmpty || (traceLevels[t.id] ?? 0) == 0) {
        return;
      }
      t.effect.map((e) => Effect.fromEntity(e, character.entity.id, t.id)).where((e) => e.validSelfBuffEffect(prop, dependProp: dependProp, currentCid: id)).forEach((effect) {
        String effectKey = effect.getKey();
        EffectConfig effectConfig = selfTraceEffect[effectKey] ?? EffectConfig.defaultOn();
        if (!effectConfig.on) {
          return;
        }
        if (effect.entity.group != '') {
          for (EffectEntity skillEffectEntity in t.effect) {
            Effect skillEffect = Effect.fromEntity(skillEffectEntity, character.entity.id, t.id);
            if (skillEffectEntity.group == effect.entity.group && !(selfTraceEffect[skillEffect.getKey()] ?? EffectConfig.defaultOn()).on) {
              // 同group的effect如果关闭了，此effect也认为关闭
              return;
            }
          }
        }
        int? skillLevel = skillLevels[t.id];
        if (t.referencelevel != '') {
          // 引用技能等级
          skillLevel = skillLevels[character.getSkillById(t.referencelevel).id];
        }
        if (dependProp != null) {
          effectConfig = EffectConfig.defaultOn();
          double v = dependValue ?? 0;
          if (dependProp.isPercent()) {
            v *= 100;
          }
          effectConfig.value = v;
        }
        double multiplierValue = effect.getEffectMultiplierValue(t, skillLevel, effectConfig);
        result[PropSource.characterTrace(effectKey, effect, name: t.tiny ? 'tiny' : '', self: true)] = base * multiplierValue;
      });
    });
  }

  void _addCharacterEidolonValue(Map<PropSource, double> result, Character character, double base, FightProp prop, {FightProp? dependProp, double? dependValue}) {
    character.entity.eidolon.forEach((e) {
      if (e.effect.isEmpty || (eidolons[e.eidolonnum.toString()] ?? 0) == 0) {
        return;
      }
      e.effect.map((ef) => Effect.fromEntity(ef, character.entity.id, e.id)).where((ef) => ef.validSelfBuffEffect(prop, dependProp: dependProp, currentCid: id)).forEach((effect) {
        String effectKey = effect.getKey();
        EffectConfig effectConfig = selfEidolonEffect[effectKey] ?? EffectConfig.defaultOn();
        if (!effectConfig.on) {
          return;
        }
        if (effect.entity.group != '') {
          for (EffectEntity skillEffectEntity in e.effect) {
            Effect skillEffect = Effect.fromEntity(skillEffectEntity, character.entity.id, e.id);
            if (skillEffectEntity.group == effect.entity.group && !(selfEidolonEffect[skillEffect.getKey()] ?? EffectConfig.defaultOn()).on) {
              // 同group的effect如果关闭了，此effect也认为关闭
              return;
            }
          }
        }
        int? skillLevel = skillLevels[e.id];
        if (e.referencelevel != '') {
          // 引用技能等级
          skillLevel = skillLevels[character.getSkillById(e.referencelevel).id];
        }
        if (dependProp != null) {
          effectConfig = EffectConfig.defaultOn();
          double v = dependValue ?? 0;
          if (dependProp.isPercent()) {
            v *= 100;
          }
          effectConfig.value = v;
        }
        double multiplierValue = effect.getEffectMultiplierValue(e, skillLevel, effectConfig);
        result[PropSource.characterEidolon(effectKey, effect, self: true)] = base * multiplierValue;
      });
    });
  }

  void _addOtherSkillValue(Map<PropSource, double> result, Character character, double base, FightProp prop) {
    Effect.groupEffect(EffectManager.getEffects().values.where((e) => e.majorId != character.entity.id && e.validAllyBuffEffect(prop)).toList()).values.forEach((effects) {
      Effect effect = effects.first;
      String effectKey = effect.getKey();
      EffectConfig effectConfig = otherEffect[effectKey] ?? EffectConfig.defaultOff();
      if (!effectConfig.on) {
        return;
      }
      int skillLevel = effect.skillData.maxlevel;
      if (effect.skillData.maxlevel > 10) {
        skillLevel = 10;
      } else if (effect.skillData.maxlevel > 1) {
        skillLevel = 6;
      }
      double multiplierValue = 0;
      effects.forEach((element) {
        multiplierValue += element.getEffectMultiplierValue(effect.skillData, skillLevel, otherEffect[element.getKey()]);
      });
      result[PropSource.characterSkill(effectKey, effect, self: false)] = base * multiplierValue;
    });
  }

  void _addManualEffectValue(Map<PropSource, double> result, Character character, double base, FightProp prop) {
    EffectManager.getManualEffects().where((e) => e.validSelfBuffEffect(prop)).forEach((effect) {
      String effectKey = effect.getKey();
      EffectConfig effectConfig = manualEffect[effectKey] ?? EffectConfig.defaultOff();
      if (!effectConfig.on) {
        return;
      }
      double multiplierValue = effect.getEffectMultiplierValue(null, null, effectConfig);
      result[PropSource.manualEffect(effectKey, effect)] = base * multiplierValue;
    });
  }

  CharacterStats.empty();

  /// 接口数据导入
  CharacterStats.fromImportJson(Map<String, dynamic> jsonMap, {String? updateTime}) {
    this.id = jsonMap['id'];
    if (updateTime == null) {
      this.updateTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    } else {
      this.updateTime = updateTime;
    }
    this.level = jsonMap['level'].toString();
    this.promotion = jsonMap['promotion'];
    int rank = jsonMap['rank'] ?? 0;
    for (int i = 0; i <= rank; i++) {
      eidolons[i.toString()] = 1;
    }
    if (jsonMap['light_cone'] != null) {
      this.lightconeId = jsonMap['light_cone']['id'];
      this.lightconeLevel = jsonMap['light_cone']['level'].toString();
      this.lightconeRank = jsonMap['light_cone']['rank'];
    }
    for (var s in jsonMap['skills']) {
      skillLevels[s['id']] = s['level'];
    }
    for (var t in jsonMap['skill_trees']) {
      traceLevels[t['id']] = t['level'];
    }
    for (var r in jsonMap['relics']) {
      String setId = r['set_id'];
      Relic relic = RelicManager.getRelic(setId);
      String icon = r['icon'];
      int partOrd = num.tryParse(icon.substring(icon.lastIndexOf('_') + 1, icon.lastIndexOf('.')))?.toInt() ?? -1;
      RelicPart part = RelicPart.fromOrdAndSet(partOrd, relic.entity.xSet);
      if (part == RelicPart.unknown) {
        continue;
      }
      RelicStats stats = RelicStats();
      stats.setId = setId;
      stats.rarity = r['rarity'];
      stats.level = r['level'];
      stats.mainAttr = FightProp.fromImportType(r['main_affix']['type']);
      for (var sub in r['sub_affix']) {
        stats.subAttrValues.add(Record.of(FightProp.fromImportType(sub['type']), sub['value']));
      }
      this.relics[part] = stats;
    }
    List<dynamic> attributesList = jsonMap['attributes'] ?? [];
    List<dynamic> additionsList = jsonMap['additions'] ?? [];
    for (var e in attributesList) {
      String field = (e['field'] ?? '').replaceAll('_', '');
      FightProp fp = FightProp.fromEffectKey(field);
      this.importStats[fp] = e['value'] ?? 0;
    }
    for (var e in additionsList) {
      String field = (e['field'] ?? '').replaceAll('_', '');
      FightProp fp = FightProp.fromEffectKey(field);
      double v = importStats[fp] ?? 0;
      importStats[fp] = v + (e['value'] ?? 0);
    }
    importStats[FightProp.sPRatio] = 1 + (importStats[FightProp.sPRatio] ?? 0);
    importStats[FightProp.maxHP] = importStats[FightProp.hPAddedRatio] ?? 0;
    importStats.remove(FightProp.hPAddedRatio);
    importStats[FightProp.attack] = importStats[FightProp.attackAddedRatio] ?? 0;
    importStats.remove(FightProp.attackAddedRatio);
    importStats[FightProp.defence] = importStats[FightProp.defenceAddedRatio] ?? 0;
    importStats.remove(FightProp.defenceAddedRatio);
    importStats.remove(FightProp.unknown);
  }

  CharacterStats.fromJson(Map<String, dynamic> jsonMap) {
    this.id = jsonMap['id'];
    this.updateTime = jsonMap['update_time'];
    this.level = jsonMap['level'];
    this.promotion = jsonMap['promotion'];
    for (var e in jsonMap['eidolons'].entries) {
      this.eidolons[e.key] = e.value;
    }
    this.lightconeId = jsonMap['lightcone_id'];
    this.lightconeLevel = jsonMap['lightcone_level'];
    this.lightconeRank = jsonMap['lightcone_rank'];
    for (var e in jsonMap['skill_levels'].entries) {
      this.skillLevels[e.key] = e.value;
    }
    for (var e in jsonMap['trace_levels'].entries) {
      this.traceLevels[e.key] = e.value;
    }
    for (var e in jsonMap['relics'].entries) {
      RelicPart rp = RelicPart.fromName(e.key);
      Map<String, dynamic> statsMap = e.value;
      RelicStats rs = RelicStats();
      rs.setId = statsMap['set_id'];
      rs.rarity = statsMap['rarity'];
      rs.level = statsMap['level'];
      rs.mainAttr = FightProp.fromName(statsMap['main_attr']);
      List<dynamic> subValueMap = statsMap['sub_attr_values'];
      for (var sub in subValueMap) {
        rs.subAttrValues.add(Record.of(FightProp.fromName(sub['key']), sub['value']));
      }
      this.relics[rp] = rs;
    }
    Map<String, dynamic> importStatsMap = jsonMap['import_stats'] ?? {};
    for (var sub in importStatsMap.entries) {
      this.importStats[FightProp.fromName(sub.key)] = sub.value;
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {};
    jsonMap['id'] = this.id;
    jsonMap['update_time'] = this.updateTime;
    jsonMap['level'] = this.level;
    jsonMap['promotion'] = this.promotion;
    jsonMap['eidolons'] = this.eidolons;
    jsonMap['lightcone_id'] = this.lightconeId;
    jsonMap['lightcone_level'] = this.lightconeLevel;
    jsonMap['lightcone_rank'] = this.lightconeRank;
    jsonMap['skill_levels'] = this.skillLevels;
    jsonMap['trace_levels'] = this.traceLevels;
    Map<String, dynamic> relicMap = {};
    for (var e in this.relics.entries) {
      Map<String, dynamic> partMap = {};
      partMap['set_id'] = e.value.setId;
      partMap['rarity'] = e.value.rarity;
      partMap['level'] = e.value.level;
      partMap['main_attr'] = e.value.mainAttr.name;
      List<Map<String, dynamic>> subList = [];
      for (var s in e.value.subAttrValues) {
        Map<String, dynamic> subRecordMap = {};
        subRecordMap['key'] = s.key.name;
        subRecordMap['value'] = s.value;
        subList.add(subRecordMap);
      }
      partMap['sub_attr_values'] = subList;
      relicMap[e.key.name] = partMap;
    }
    jsonMap['relics'] = relicMap;
    Map<String, dynamic> importStatsMap = {};
    for (var s in importStats.entries) {
      importStatsMap[s.key.name] = s.value;
    }
    jsonMap['import_stats'] = importStatsMap;
    return jsonMap;
  }

  @override
  String toString() {
    return jsonEncode(this.toJson());
  }

  Map<String, dynamic> toSimpleJson() {
    Map<String, dynamic> jsonMap = {};
    jsonMap['id'] = this.id;
    jsonMap['level'] = this.level;
    jsonMap['rank'] = this.eidolons.isEmpty ? '0' : this.eidolons.keys.last;
    jsonMap['lightcone_id'] = this.lightconeId;
    jsonMap['lightcone_level'] = this.lightconeLevel;
    jsonMap['lightcone_rank'] = this.lightconeRank;
    return jsonMap;
  }

  String toSimpleString() {
    return jsonEncode(this.toSimpleJson());
  }
}
