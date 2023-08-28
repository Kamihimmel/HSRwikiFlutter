import 'package:flutter/material.dart';

import '../characters/character_stats.dart';
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

  /// character
  CharacterStats _stats = CharacterStats.empty();

  /// enemy
  int _enemyLevel = 80;
  int _enemyType = 1;
  Set<ElementType> _enemyWeakness = Set();
  int _enemyDefence = 0;

  /// config
  bool _male = false;
  bool _spoilerMode = false;
  bool _cnMode = false;
  bool _test = false;
  bool _debug = true;

  /// footer
  int _dmgScale = 10; // footer option: damage scale
  int _statScale = 10; // footer option: stat scale

  void loaded(bool loaded) {
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

  CharacterStats get stats => _stats;
  set stats(CharacterStats stats) {
    _stats = stats;
    notifyListeners();
  }

  int get enemyLevel => _enemyLevel;
  set enemyLevel(int enemyLevel) {
    _enemyLevel = enemyLevel;
    notifyListeners();
  }
  int get enemyType => _enemyType;
  set enemyType(int enemyType) {
    _enemyType = enemyType;
    notifyListeners();
  }
  Set<ElementType> get enemyWeakness => Set.from(_enemyWeakness);
  void addEnemyWeakness(ElementType type) {
    _enemyWeakness.add(type);
    notifyListeners();
  }
  void removeEnemyWeakness(ElementType type) {
    _enemyWeakness.remove(type);
    notifyListeners();
  }
  int get enemyDefence => _enemyDefence;
  set enemyDefence(int enemyDefence) {
    _enemyDefence = enemyDefence;
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
  bool get debug => _debug;
  set debug(bool debug) {
    _debug = debug;
    logger.d("change debug: $debug");
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