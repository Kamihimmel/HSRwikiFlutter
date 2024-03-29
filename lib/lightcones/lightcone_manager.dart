import 'dart:convert';

import '../utils/helper.dart';
import '../utils/logging.dart';
import 'lightcone.dart';

class LightconeManager {
  static final Map<String, Lightcone> _lightcones = {};

  LightconeManager._();

  static Future<Map<String, Lightcone>> initAllLightcones() async {
    await _initFromLib();
    return getLightcones();
  }

  static Future<void> _initFromLib() async {
    try {
      _lightcones.clear();
      String jsonStr = await loadLibJsonString('lib/lightconelist.json');
      final Map<String, dynamic> allLightcones = json.decode(jsonStr);
      // logger.d(json.encode(allLightcones));
      for (var d in allLightcones['data']!) {
        // get brief from list json
        Lightcone lightcone = Lightcone.fromJson(d, spoiler: d['spoiler'], order: d['order'] ?? 999);
        _lightcones[d['id']] = lightcone;
      }
      logger.d("loaded lightcones: ${_lightcones.length}");
    } catch (e) {
      logger.e("load lightcones exception: ${e.toString()}");
    }
  }

  static Map<String, Lightcone> getLightcones({withDiy = false}) {
    Map<String, Lightcone> map = Map.from(_lightcones);
    if (withDiy) {
    }
    return map;
  }

  static Lightcone getLightcone(String id) {
    return _lightcones[id]!;
  }

  static Future<Lightcone> loadFromRemoteById(String id) async {
    if (!_lightcones.containsKey(id)) {
      await initAllLightcones();
    }
    return loadFromRemote(getLightcone(id));
  }

  static Future<Lightcone> loadFromRemote(Lightcone d) async {
    // if (d.loaded) {
    //   return d;
    // }
    // if (_lightcones.containsKey(d.entity.id) && _lightcones[d.entity.id]!.loaded) {
    //   return _lightcones[d.entity.id]!;
    // }
    String jsonStr = await loadLibJsonString(d.entity.infourl);
    final Map<String, dynamic> lightconeMap = json.decode(jsonStr);
    // logger.d(json.encode(lightconeMap));
    Lightcone lightcone = Lightcone.fromJson(lightconeMap, spoiler: d.spoiler, order: d.order);
    lightcone.loaded = true;
    _lightcones[d.entity.id] = lightcone;
    logger.i("loaded lightcone: ${lightcone.entity.id}");
    return lightcone;
  }

  static List<String> getLightconeIds() {
    return _lightcones.keys.toList();
  }
}
