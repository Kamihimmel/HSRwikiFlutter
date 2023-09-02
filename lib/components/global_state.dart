import 'package:flutter/material.dart';

import '../characters/character_stats.dart';
import '../enemies/enemy.dart';
import '../utils/helper.dart';
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
  bool _male = false;
  bool _spoilerMode = false;
  bool _cnMode = false;
  bool _test = false;

  /// debug
  bool debug = false;
  Set<String> missingLocalizationKeys = Set();

  /// footer
  int _dmgScale = 10; // footer option: damage scale
  int _statScale = 10; // footer option: stat scale

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
  void changeStats() {
    notifyListeners();
  }

  EnemyStats get enemyStats => _enemyStats;
  set enemyStats(EnemyStats enemyStats) {
    _enemyStats = enemyStats;
    notifyListeners();
  }

  bool get male => _male;
  set male(bool male) {
    _male = male;
    logger.d("change male: $male");
    notifyListeners();
  }
  bool get spoilerMode => _spoilerMode;
  set spoilerMode(bool spoilerMode) {
    _spoilerMode = spoilerMode;
    logger.d("change spoiler mode: $spoilerMode");
    notifyListeners();
  }
  bool get cnMode => _cnMode;
  set cnMode(bool cnMode) {
    _cnMode = cnMode;
    logger.d("change cn mode: $cnMode");
    notifyListeners();
  }
  bool get test => _test;
  set test(bool test) {
    _test = test;
    logger.d("change test: $test");
    notifyListeners();
  }

  int get dmgScale => _dmgScale;
  set dmgScale(int dmgScale) {
    _dmgScale = dmgScale;
    notifyListeners();
  }
  int get statScale => _statScale;
  set statScale(int statScale) {
    _statScale = statScale;
    notifyListeners();
  }
}