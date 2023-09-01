import 'dart:convert';

import 'package:hsrwikiproject/lightcones/lightcone.dart';

import '../components/global_state.dart';
import '../lightcones/lightcone_manager.dart';
import '../utils/helper.dart';
import '../utils/logging.dart';
import 'character.dart';

class CharacterManager {
  static final GlobalState _gs = GlobalState();
  static final Map<String, Character> _characters = {};
  static final String defaultCharacter = "1005";
  static final Map<String, String> _defaultLightconeMapping = {
    "1005": "23006",
    "1102": "23001",
    "1205": "23009",
    "1203": "23008",
  };
  static final Map<String, List<String>> _defaultRelicSetsMapping = {
    "1005": ["109", "109", "306"],
    "1102": ["108", "108", "306"],
    "1205": ["113", "113", "309"],
    "1203": ["101", "102", "301"],
  };

  CharacterManager._();

  static Future<Map<String, Character>> initAllCharacters() async {
    await _initFromLib();
    return getCharacters();
  }

  static Future<void> _initFromLib() async {
    try {
      _characters.clear();
      String jsonStr = await loadLibJsonString('lib/characterlist.json', cnMode: _gs.cnMode);
      final Map<String, dynamic> allCharacters = json.decode(jsonStr);
      // logger.d(json.encode(allCharacters));
      for (var c in allCharacters['data']!) {
        // get brief from list json
        Character character = Character.fromJson(c, spoiler: c['spoiler'], supported: c['supported'] ?? true, order: c['order'] ?? 999);
        _characters[c['id']] = character;
      }
      logger.d("loaded characters: ${_characters.length}, cnMode: ${_gs.cnMode}");
    } catch (e) {
      logger.e("load characters exception: ${e.toString()}");
    }
  }

  static Map<String, Character> getCharacters({withDiy = false}) {
    Map<String, Character> map = Map.from(_characters);
    if (withDiy) {
    }
    return map;
  }

  static String getDefaultLightcone(String characterId) {
    if (!_defaultLightconeMapping.containsKey(characterId)) {
      Character c = getCharacter(characterId);
      return LightconeManager.getLightcones().values.firstWhere((lc) => lc.pathType == c.pathType && lc.entity.rarity == '5', orElse: () => Lightcone()).entity.id;
    }
    return _defaultLightconeMapping[characterId]!;
  }

  static List<String> getDefaultRelicSets(String characterId) {
    if (!_defaultRelicSetsMapping.containsKey(characterId)) {
      return ["108", "108", "306"];
    }
    return _defaultRelicSetsMapping[characterId]!;
  }

  /// sorted for side panel
  static Map<String, Character> getSortedCharacters({withDiy = false, filterSupported = false}) {
    Map<String, Character> map = getCharacters(withDiy: withDiy);
    List<Character> cList = map.values.toList();
    cList.sort((c1, c2) => c1.order.compareTo(c2.order));
    Map<String, Character> result = {};
    for (Character c in cList) {
      if (filterSupported && !c.supported) {
        continue;
      }
      result[c.entity.id] = map[c.entity.id]!;
    }
    return result;
  }

  static Character getCharacter(String id) {
    return _characters[id]!;
  }

  static Character getDefaultCharacter() {
    return getCharacter(defaultCharacter);
  }

  static Future<Character> loadFromRemoteById(String id) async {
    return loadFromRemote(getCharacter(id));
  }

  static Future<Character> loadFromRemote(Character c) async {
    if (c.loaded) {
      return c;
    }
    if (_characters.containsKey(c.entity.id) && _characters[c.entity.id]!.loaded) {
      return _characters[c.entity.id]!;
    }
    String jsonStr = await loadLibJsonString(c.entity.infourl, cnMode: _gs.cnMode);
    final Map<String, dynamic> characterMap = json.decode(jsonStr);
    // logger.d(json.encode(characterMap));
    Character character = Character.fromJson(characterMap, spoiler: c.spoiler, supported: c.supported, order: c.order);
    character.loaded = true;
    _characters[c.entity.id] = character;
    logger.i("loaded character: ${character.entity.id}");
    return character;
  }

  static List<String> getCharacterIds() {
    return _characters.keys.toList();
  }
}
