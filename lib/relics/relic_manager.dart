import 'dart:convert';

import '../components/global_state.dart';
import '../utils/helper.dart';
import '../utils/logging.dart';
import 'relic.dart';

class RelicManager {
  static final GlobalState _gs = GlobalState();
  static final Map<String, Relic> _relics = {};

  RelicManager._();

  static Future<Map<String, Relic>> initAllRelics() async {
    await _initFromLib();
    return getRelics();
  }

  static Future<void> _initFromLib() async {
    try {
      _relics.clear();
      String jsonStr = await loadLibJsonString('lib/reliclist.json', cnMode: _gs.cnMode);
      final Map<String, dynamic> allRelics = json.decode(jsonStr);
      // logger.d(json.encode(allRelics));
      for (var r in allRelics['data']!) {
        // get brief from list json
        Relic relic = Relic.fromJson(r, spoiler: r['spoiler'], order: r['order'] ?? 999);
        _relics[r['id']] = relic;
      }
      logger.d("loaded relics: ${_relics.length}, cnMode: ${_gs.cnMode}");
    } catch (e) {
      logger.e("load relics exception: ${e.toString()}");
    }
  }

  static Map<String, Relic> getRelics({withDiy = false}) {
    Map<String, Relic> map = Map.from(_relics);
    if (withDiy) {}
    return map;
  }

  static Relic getRelic(String id) {
    return _relics[id]!;
  }

  static Future<Relic> loadFromRemoteById(String id) async {
    if (!_relics.containsKey(id)) {
      await initAllRelics();
    }
    return loadFromRemote(getRelic(id));
  }

  static Future<Relic> loadFromRemote(Relic r) async {
    if (r.loaded) {
      return r;
    }
    if (_relics.containsKey(r.entity.id) && _relics[r.entity.id]!.loaded) {
      return _relics[r.entity.id]!;
    }
    String jsonStr = await loadLibJsonString(r.entity.infourl, cnMode: _gs.cnMode);
    final Map<String, dynamic> lightconeMap = json.decode(jsonStr);
    // logger.d(json.encode(lightconeMap));
    Relic relic = Relic.fromJson(lightconeMap, spoiler: r.spoiler, order: r.order);
    relic.loaded = true;
    _relics[r.entity.id] = relic;
    logger.i("loaded relic: ${relic.entity.id}");
    return relic;
  }

  static List<String> getRelicIds() {
    return _relics.keys.toList();
  }
}
