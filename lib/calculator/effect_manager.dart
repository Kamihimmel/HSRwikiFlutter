import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';

import '../characters/character.dart';
import '../characters/character_entity.dart';
import '../characters/character_manager.dart';
import '../characters/character_stats.dart';
import '../components/global_state.dart';
import '../enemies/enemy.dart';
import '../utils/helper.dart';
import '../utils/logging.dart';
import 'basic.dart';
import 'effect.dart';
import 'effect_entity.dart';

class EffectManager {
  static final GlobalState _gs = GlobalState();
  static final Map<String, Effect> _effects = {};

  EffectManager._();

  static Future<Map<String, Effect>> initAllEffects() async {
    await _initFromLib();
    return getEffects();
  }

  static Future<void> _initFromLib() async {
    try {
      _effects.clear();
      String jsonStr = await loadLibJsonString('lib/skilllist.json', cnMode: _gs.cnMode);
      final Map<String, dynamic> allSkills = json.decode(jsonStr);
      logger.d(json.encode(allSkills));
      for (var s in allSkills['data']!) {
        CharacterSkilldata skillData = CharacterSkilldata.fromJson(s);
        for (var i = 0; i < skillData.effect.length; i++) {
          EffectEntity effectEntity = skillData.effect[i];
          Effect effect = Effect.fromEntity(effectEntity, s['characterid'], skillData.id);
          effect.skillData = skillData;
          _effects[effect.getKey()] = effect;
        }
      }
      logger.d("loaded effects: ${_effects.length}, cnMode: ${_gs.cnMode}");
    } catch (e) {
      logger.e("load effects exception: ${e.toString()}");
    }
  }

  static Map<String, Effect> getEffects() {
    return Map.from(_effects);
  }

  static Effect getEffect(String key) {
    return _effects[key]!;
  }

  static List<Effect> getManualEffects() {
    return _manualProps.where((attr) => attr.effectKey.isNotEmpty).map((attr) => Effect.manualBuff(attr)).toList();
  }

  static List<Effect> getBreakDamageEffects(CharacterStats cs, EnemyStats es) {
    Character character = CharacterManager.getCharacter(cs.id);
    Effect breakDamageEffect = Effect.empty();
    breakDamageEffect.entity.multiplier = character.elementType.getBreakDamageMultiplier();
    breakDamageEffect.entity.tag = ['WeaknessBreak'];
    breakDamageEffect.skillData.eNname = 'WeaknessBreak';
    breakDamageEffect.skillData.cNname = '弱点击破';
    breakDamageEffect.skillData.jAname = '弱点撃破';

    Effect breakExtraEffect = Effect.empty();
    breakExtraEffect.entity.multiplier = character.elementType.getBreakExtraMultiplier(cs, es);
    breakExtraEffect.entity.tag = ["${character.elementType.getBreakExtraTurns()}${'turn(s)'.tr()}"];
    String damageType = character.elementType.getBreakDamageType();
    if (damageType.isNotEmpty) {
      breakExtraEffect.entity.tag.add(damageType);
    }
    breakExtraEffect.entity.maxStack = character.elementType.getBreakExtraMaxStack();
    String breakEffect = character.elementType.getBreakEffect().tr();
    breakExtraEffect.skillData.eNname = breakEffect;
    breakExtraEffect.skillData.cNname = breakEffect;
    breakExtraEffect.skillData.jAname = breakEffect;

    List<Effect> effects = [breakDamageEffect, breakExtraEffect];
    for (var i = 0; i < effects.length; i++) {
      Effect e = effects[i];
      e.majorId = cs.id;
      e.minorId = 'break';
      e.effectId = "${i + 1}";
      e.type = Effect.breakDamageType;
      e.entity.iid = e.effectId;
      e.entity.type = 'break';
      e.entity.multipliertarget = 'breakdmgbase';
      e.entity.tag.add("${character.elementType.name}dmg");
      e.skillData.maxlevel = -1;
    }
    return effects;
  }
}

List<FightProp> _manualProps = [
  FightProp.hPAddedRatio,
  FightProp.attackAddedRatio,
  FightProp.defenceAddedRatio,
  FightProp.criticalChance,
  FightProp.criticalDamage,
  FightProp.allDamageAddRatio,
  FightProp.allResistanceIgnore,
  FightProp.statusProbability,
  FightProp.statusResistance,
];
