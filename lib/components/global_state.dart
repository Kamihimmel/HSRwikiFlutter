import 'package:flutter/material.dart';

import '../characters/character_manager.dart';
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
    'currentCharacter': _currentCharacter,
    'level': _level,
    'natkLv': _natkLv,
    'eskillLv': _eskillLv,
    'eburstLv': _eburstLv,
    'cons': _cons,
    'weaponSelect': _weaponSelect,
    'weaponLv': _weaponLv,
    'weaponRef': _weaponRef,
  };

  /// character
  String _currentCharacter = CharacterManager.defaultCharacter;
  int _level = 80; // character level
  int _natkLv = 8; // normal attack level
  int _eskillLv = 8; // element skill level
  int _eburstLv = 8; // element burst level
  int _cons = 0; // constellation

  /// weapon
  String _weaponSelect = '15502'; // selected weapon
  int _weaponLv = 80; // weapon level
  int _weaponRef = 1; // weapon refinement

  /// artifact
  String _artifactSetA = 'blizzard';
  String _artifactSetB = 'blizzard';

  /// enemy
  int _enemyLevel = 80;
  int _enemyType = 1;
  int _enemyDefence = 0;
  Map<ElementType, int> _enemyResistance = {
  };

  /// buff
  int _buffUpdated = 0;

  /// config
  AppConfig _appConfig = AppConfig();

  List<ElementType> getEnemyResistanceTypes() {
    return _enemyResistance.keys.toList();
  }
  int getEnemyResistance(ElementType type) {
    return _enemyResistance[type] ?? 0;
  }
  void setEnemyResistance(ElementType type, int value) {
    _enemyResistance[type] = value;
    // updated by other notifier variable, no need to notify listeners
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

  int get enemyDefence => _enemyDefence;
  set enemyDefence(int enemyDefence) {
    _enemyDefence = enemyDefence;
    notifyListeners();
  }

  int getCharacterBaseHp() {
    return CharacterManager.getCharacter(_currentCharacter).getBaseHp(_level);
  }

  int getCharacterBaseAtk() {
    return CharacterManager.getCharacter(_currentCharacter).getBaseAtk(_level);
  }

  int getCharacterBaseDef() {
    return CharacterManager.getCharacter(_currentCharacter).getBaseDef(_level);
  }

  String get artifactSetA => _artifactSetA;
  set artifactSetA(String artifactSetA) {
    _artifactSetA = artifactSetA;
    notifyListeners();
  }
  String get artifactSetB => _artifactSetB;
  set artifactSetB(String artifactSetB) {
    _artifactSetB = artifactSetB;
    notifyListeners();
  }

  String get weaponSelect => _weaponSelect;
  set weaponSelect(String weaponSelect) {
    _weaponSelect = weaponSelect;
    notifyListeners();
  }
  int get weaponLv => _weaponLv;
  set weaponLv(int weaponLv) {
    _weaponLv = weaponLv;
    notifyListeners();
  }
  int get weaponRef => _weaponRef;
  set weaponRef(int weaponRef) {
    _weaponRef = weaponRef;
    notifyListeners();
  }

  String get currentCharacter => _currentCharacter;
  set currentCharacter(currentCharacter) {
    _currentCharacter = currentCharacter;
    notifyListeners();
  }
  int get level => _level;
  set level(int level) {
    _level = level;
    notifyListeners();
  }
  int get natkLv => _natkLv;
  set natkLv(int natkLv) {
    _natkLv = natkLv;
    notifyListeners();
  }
  int get eskillLv => _eskillLv;
  set eskillLv(int eskillLv) {
    _eskillLv = eskillLv;
    notifyListeners();
  }
  int get eburstLv => _eburstLv;
  set eburstLv(int eburstLv) {
    _eburstLv = eburstLv;
    notifyListeners();
  }
  int get cons => _cons;
  set cons(int cons) {
    _cons = cons;
    notifyListeners();
  }

  AppConfig getAppConfig() {
    return _appConfig;
  }

  AppConfig newAppConfig() {
    _appConfig = AppConfig.copy(_appConfig);
    return _appConfig;
  }
  void setAppConfig({bool? male, bool? spoiler, bool? cn, bool? test}) {
    if (male != null) {
      _appConfig.male = male;
    }
    if (spoiler != null) {
      _appConfig.spoilerMode = spoiler;
    }
    if (cn != null) {
      _appConfig.cnMode = cn;
    }
    logger.d("change config, male: $male, spoiler: $spoiler, cn: $cn, test: $test");
  }
}

class AppConfig extends ChangeNotifier {
  bool _male = false;
  bool _spoilerMode = false;
  bool _cnMode = false;
  bool _test = false;

  AppConfig();

  static AppConfig copy(AppConfig appConfig) {
    AppConfig config = AppConfig();
    config._male = appConfig._male;
    config._spoilerMode = appConfig._spoilerMode;
    config._cnMode = appConfig._cnMode;
    config._test = appConfig._test;
    return config;
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
}