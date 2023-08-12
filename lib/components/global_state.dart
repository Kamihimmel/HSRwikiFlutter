import 'package:flutter/material.dart';

import '../characters/character_manager.dart';
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
    'stats': _stats._cStats.toJson(),
  };

  /// character
  CharacterStatsNotify _stats = CharacterStatsNotify();

  /// config
  AppConfig _appConfig = AppConfig();

  CharacterStats get stats => _stats._cStats;
  set stats(CharacterStats stats) {
    _stats.cStats = stats;
  }

  CharacterStatsNotify getCharacterStats() {
    return _stats;
  }

  CharacterStatsNotify newCharacterStats() {
    _stats = CharacterStatsNotify();
    return _stats;
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

class CharacterStatsNotify extends ChangeNotifier {
  CharacterStats _cStats = CharacterStats.empty();

  CharacterStats get cStats => _cStats;
  set cStats(CharacterStats cStats) {
    _cStats = cStats;
    notifyListeners();
  }
}