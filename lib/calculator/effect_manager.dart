import 'dart:convert';


import '../characters/character_entity.dart';
import '../components/global_state.dart';
import '../utils/helper.dart';
import '../utils/logging.dart';
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
}
