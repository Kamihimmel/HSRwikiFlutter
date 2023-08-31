import 'dart:convert';

import '../components/global_state.dart';
import '../utils/helper.dart';
import '../utils/logging.dart';
import 'enemy.dart';

class EnemyManager {
  static final GlobalState _gs = GlobalState();
  static final Map<String, Enemy> _enemies = {};

  EnemyManager._();

  static Future<Map<String, Enemy>> initAllEnemies() async {
    await _initFromLib();
    return getEnemies();
  }

  static Future<void> _initFromLib() async {
    try {
      _enemies.clear();
      String jsonStr = await loadLibJsonString('lib/enemylist.json', cnMode: _gs.cnMode);
      final Map<String, dynamic> allEnemies = json.decode(jsonStr);
      logger.d(json.encode(allEnemies));
      for (var c in allEnemies['data']!) {
        // get brief from list json
        Enemy enemy = Enemy.fromJson(c, spoiler: c['spoiler'] ?? false, order: c['order'] ?? 999);
        _enemies[c['id']] = enemy;
      }
      logger.d("loaded enemies: ${_enemies.length}, cnMode: ${_gs.cnMode}");
    } catch (e) {
      logger.e("load enemies exception: ${e.toString()}");
    }
  }

  static Map<String, Enemy> getEnemies() {
    return Map.from(_enemies);
  }

  static Enemy getEnemy(String enemyId) {
    return _enemies[enemyId]!;
  }
}
