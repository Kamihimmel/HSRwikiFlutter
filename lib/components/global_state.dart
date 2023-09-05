import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../characters/character_stats.dart';
import '../enemies/enemy.dart';
import '../utils/app_config.dart';
import '../utils/logging.dart';

class GlobalState extends ChangeNotifier {

  static final GlobalState _instance = GlobalState._();

  GlobalState._() {
    this.addListener(() {
    });
  }

  factory GlobalState() => _instance;

  Map<String, dynamic> toJson() => {
    'stats': _stats.toJson(),
    'enemy_stats': _enemyStats.toJson(),
    'app_config': _appConfig.toJson(),
  };

  /// loading state
  bool _characterLoaded = false;
  bool _lightconeLoaded = false;
  bool _relicLoaded = false;
  bool _enemyLoaded = false;
  bool _effectLoaded = false;

  /// character
  CharacterStats _stats = CharacterStats.empty();

  /// enemy
  EnemyStats _enemyStats = EnemyStats.empty();

  /// config
  AppConfig _appConfig = AppConfig.empty();

  /// debug
  bool debug = false;
  String localEndpoint = '';
  Set<String> missingLocalizationKeys = Set();

  bool loaded() {
    return _characterLoaded && _lightconeLoaded && _relicLoaded;
  }
  void setLoaded(bool loaded) {
    _characterLoaded = loaded;
    _lightconeLoaded = loaded;
    _relicLoaded = loaded;
    notifyListeners();
  }
  bool get characterLoaded => _characterLoaded;
  set characterLoaded(bool characterLoaded) {
    _characterLoaded = characterLoaded;
    notifyListeners();
  }
  bool get lightconeLoaded => _lightconeLoaded;
  set lightconeLoaded(bool lightconeLoaded) {
    _lightconeLoaded = lightconeLoaded;
    notifyListeners();
  }
  bool get relicLoaded => _relicLoaded;
  set relicLoaded(bool relicLoaded) {
    _relicLoaded = relicLoaded;
    notifyListeners();
  }
  bool get enemyLoaded => _enemyLoaded;
  set enemyLoaded(bool enemyLoaded) {
    _enemyLoaded = enemyLoaded;
    notifyListeners();
  }
  bool get effectLoaded => _effectLoaded;
  set effectLoaded(bool effectLoaded) {
    _effectLoaded = effectLoaded;
    notifyListeners();
  }

  CharacterStats get stats => _stats;
  set stats(CharacterStats stats) {
    _stats = stats;
    notifyListeners();
  }
  EnemyStats get enemyStats => _enemyStats;
  set enemyStats(EnemyStats enemyStats) {
    _enemyStats = enemyStats;
    notifyListeners();
  }
  void changeStats() {
    notifyListeners();
  }

  AppConfig get appConfig => _appConfig;
  set appConfig(AppConfig appConfig) {
    _appConfig = appConfig;
    notifyListeners();
  }
  void changeConfig() {
    SharedPreferences.getInstance().then((prefs) {
      String configJson = _appConfig.toString();
      prefs.setString('appconfig', configJson);
      logger.d("Save config: ${configJson}");
    });
    notifyListeners();
  }
}