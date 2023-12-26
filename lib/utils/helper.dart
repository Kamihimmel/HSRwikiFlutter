import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../calculator/basic.dart';
import '../calculator/effect_manager.dart';
import '../characters/character_manager.dart';
import '../characters/character_stats.dart';
import '../components/global_state.dart';
import '../enemies/enemy.dart';
import '../enemies/enemy_manager.dart';
import '../lightcones/lightcone_manager.dart';
import '../relics/relic_manager.dart';

final GlobalState _gs = GlobalState();
final String urlEndpoint = "https://hsrwikidata.yunlu18.net/";
final String cnUrlEndpoint = "https://hsrwikidata.kchlu.com/";

String getUrlEndpoint() {
  if (_gs.localEndpoint != '') {
    return _gs.localEndpoint;
  }
  return _gs.appConfig.cnMode ? cnUrlEndpoint : urlEndpoint;
}

Future<void> initData() async {
  _gs.setLoaded(false);
  await CharacterManager.initAllCharacters();
  _gs.characterLoaded = true;
  await LightconeManager.initAllLightcones();
  _gs.lightconeLoaded = true;
  await RelicManager.initAllRelics();
  _gs.relicLoaded = true;
  await EnemyManager.initAllEnemies();
  _gs.enemyLoaded = true;
  await EffectManager.initAllEffects();
  _gs.effectLoaded = true;
}

getImageComponent(String path,
    {remote = true, imageWrap = false, fit = BoxFit.cover, alignment = Alignment.center, Uint8List? placeholder, double? width, double? height}) {
  ImageProvider _imageProvider;
  if (remote) {
    String url;
    if (path.startsWith('http://') || path.startsWith("https://")) {
      url = path;
    } else {
      url = getUrlEndpoint() + path;
    }
    if (placeholder != null) {
      return FadeInImage.memoryNetwork(placeholder: placeholder, image: url, fit: fit, alignment: alignment, width: width, height: height ?? width);
    } else {
      _imageProvider = NetworkImage(url);
    }
  } else {
    _imageProvider = AssetImage(path);
  }
  return imageWrap
      ? Image(image: _imageProvider, fit: fit, width: width, height: height ?? width, filterQuality: FilterQuality.medium, alignment: alignment)
      : _imageProvider;
}

Future<void> mockLoad(int? seconds) async {
  return Future.delayed(Duration(seconds: seconds ?? 1));
}

String getLanguageCode(BuildContext context) {
  return EasyLocalization.of(context)?.currentLocale?.languageCode ?? 'en';
}

Future<String> loadLibJsonString(String path) async {
  final response = await http.get(Uri.parse('http://localhost:8888/' + path));
  print(response.body);
  return utf8.decode(response.bodyBytes);
}

String getDisplayText(double value, bool percent, {round = false}) {
  if (percent) {
    double v;
    if (round) {
      v = (value * 1000).round() / 10;
    } else {
      v = (value * 1000).floor() / 10;
    }
    return v.toStringAsFixed(1) + '%';
  } else {
    return value.toStringAsFixed(1);
  }
}

Map<int, MaterialColor> _rarityColor = {
  5: Colors.amber,
  4: Colors.deepPurple,
  3: Colors.blue,
};

MaterialColor getRarityColor(int rarity) {
  if (_rarityColor.containsKey(rarity)) {
    return _rarityColor[rarity]!;
  }
  return Colors.grey;
}

/// 击破倍率、击破后额外伤害倍率、伤害/效果持续回合数、额外伤害最大层数、击破后伤害类型以及效果
Map<ElementType, List<dynamic>> _breakMultiplier = {
  ElementType.fire: [2, 1, 2, 0, 'dotatk', 'burn'],
  ElementType.ice: [1, 1, 1, 0, 'additionalatk', 'frozen'],
  ElementType.lightning: [1, 2, 2, 0, 'dotatk', 'shocked'],
  ElementType.imaginary: [0.5, 0, 1, 0, '', 'imprison'],
  ElementType.quantum: [0.5, 0.6, 1, 5, 'additionalatk', 'entanglement'],
  ElementType.wind: [1.5, 1, 2, 5, 'dotatk', 'windshear'],
  ElementType.physical: [2, 1, 2, 0, 'dotatk', 'bleed'],
  ElementType.diy: [0, 0, 0, 0, []],
};

Map<int, double> breakBaseMapping = {
  1: 54,
  5: 70.51,
  10: 85.87,
  15: 113.47,
  20: 139.77,
  25: 186.65,
  30: 231.2,
  35: 302.73,
  40: 363.67,
  45: 578.22,
  50: 774.9,
  55: 1233.06,
  60: 1640.31,
  65: 2176.8,
  70: 2659.64,
  75: 3239.98,
  80: 3767.55,
};

enum ElementType {
  fire(key: 'fire', icon: 'images/icons/fire.webp', color: Colors.red),
  ice(key: 'ice', icon: 'images/icons/ice.webp', color: Colors.lightBlue),
  lightning(key: 'lightning', icon: 'images/icons/lightning.webp', color: Colors.purple),
  imaginary(key: 'imaginary', icon: 'images/icons/imaginary.webp', color: Colors.yellow),
  quantum(key: 'quantum', icon: 'images/icons/quantum.webp', color: Colors.indigo),
  wind(key: 'wind', icon: 'images/icons/wind.webp', color: Colors.green),
  physical(key: 'physical', icon: 'images/icons/physical.webp', color: Colors.grey),
  diy(key: 'diy', icon: '', color: Colors.grey);

  final String key;
  final String icon;
  final MaterialColor color;

  const ElementType({
    required this.key,
    required this.icon,
    required this.color,
  });

  static ElementType fromName(String name) {
    return ElementType.values.firstWhere((e) => e.name == name, orElse: () => ElementType.diy);
  }

  static ElementType fromKey(String key) {
    return ElementType.values.firstWhere((e) => e.key == key, orElse: () => ElementType.diy);
  }

  static List<ElementType> validValues() {
    return ElementType.values.where((e) => e != ElementType.diy).toList();
  }

  FightProp getElementAddRatioProp() {
    return FightProp.fromName("${this.name}AddedRatio");
  }

  double getBreakDamageMultiplier() {
    return (double.tryParse(_breakMultiplier[this]![0].toString()) ?? 0) * 100;
  }

  double getBreakExtraMultiplier(CharacterStats cs, EnemyStats es) {
    if (this == ElementType.physical) {
      Enemy enemy = EnemyManager.getEnemy(es.id);
      double ratio;
      if (enemy.type == EnemyType.boss || enemy.type == EnemyType.elite) {
        ratio = 0.07;
      } else {
        ratio = 0.16;
      }
      double base = cs.getBreakDamageBase().values.first;
      return min(base * 2 * (es.toughness + 2) / 4, ratio * es.maxhp) / base * 100;
    } else {
      return (double.tryParse(_breakMultiplier[this]![1].toString()) ?? 0) * 100;
    }
  }

  int getBreakExtraTurns() {
    return int.tryParse(_breakMultiplier[this]![2].toString()) ?? 0;
  }

  int getBreakExtraMaxStack() {
    return int.tryParse(_breakMultiplier[this]![3].toString()) ?? 0;
  }

  String getBreakDamageType() {
    return _breakMultiplier[this]![4].toString();
  }

  String getBreakEffect() {
    return _breakMultiplier[this]![5].toString();
  }

  static List<FightProp> getElementAddRatioProps() {
    return ElementType.values.where((e) => e != ElementType.diy).map((e) => e.getElementAddRatioProp()).toList();
  }

  FightProp getElementResistanceProp() {
    return FightProp.fromName("${this.name}Resistance");
  }

  static List<FightProp> getElementResistanceProps() {
    return ElementType.values.where((e) => e != ElementType.diy).map((e) => e.getElementResistanceProp()).toList();
  }

  FightProp getElementResistanceIgnoreProp() {
    return FightProp.fromName("${this.name}ResistanceIgnore");
  }

  static List<FightProp> getElementResistanceIgnoreProps() {
    return ElementType.values.where((e) => e != ElementType.diy).map((e) => e.getElementResistanceIgnoreProp()).toList();
  }

  FightProp getElementResistanceDeltaProp() {
    return FightProp.fromName("${this.name}ResistanceDelta");
  }

  static List<FightProp> getElementResistanceDeltaProps() {
    return ElementType.values.where((e) => e != ElementType.diy).map((e) => e.getElementResistanceDeltaProp()).toList();
  }

  FightProp getElementDamageReceiveRatioProp() {
    return FightProp.fromName("${this.name}DamageReceiveRatio");
  }

  static List<FightProp> getElementDamageReceiveRatioProps() {
    return ElementType.values.where((e) => e != ElementType.diy).map((e) => e.getElementDamageReceiveRatioProp()).toList();
  }
}

enum PathType {
  destruction(key: 'destruction', icon: 'images/icons/destruction.webp'),
  erudition(key: 'erudition', icon: 'images/icons/erudition.webp'),
  harmony(key: 'harmony', icon: 'images/icons/harmony.webp'),
  thehunt(key: 'thehunt', icon: 'images/icons/thehunt.webp'),
  nihility(key: 'nihility', icon: 'images/icons/nihility.webp'),
  abundance(key: 'abundance', icon: 'images/icons/abundance.webp'),
  preservation(key: 'preservation', icon: 'images/icons/preservation.webp'),
  diy(key: 'diy', icon: '');

  final String key;
  final String icon;

  const PathType({
    required this.key,
    required this.icon,
  });

  static PathType fromName(String name) {
    return PathType.values.firstWhere((p) => p.name == name, orElse: () => PathType.diy);
  }

  static PathType fromKey(String key) {
    return PathType.values.firstWhere((p) => p.key == key, orElse: () => PathType.diy);
  }
}

enum DebuffType {
  speedReduction(key: 'speed-reduction', desc: 'reducespeeddebuff', icon: 'images/stat_speeddown-mstatdef_icon.webp'),
  allTypeResReduction(key: 'all-type-res-reduction', desc: 'allresreduce', icon: 'images/stat_fatigue-mstatdef_icon.webp'),
  defReduction(key: 'def-reduction', desc: 'reducedefdebuff', icon: 'images/stat_defencedown-mstatdef_icon.webp'),
  frozen(key: 'frozen', desc: 'frozen', icon: 'images/stat_ctrl_frozen-mstatdef_icon.webp'),
  imprisonment(key: 'imprisonment', desc: 'imprison', icon: 'images/stat_confine-mstatdef_icon.webp'),
  shock(key: 'shock', desc: 'shocked', icon: 'images/stat_dot_electric-mstatdef_icon.webp'),
  burn(key: 'burn', desc: 'burn', icon: 'images/stat_dot_burn-mstatdef_icon.webp'),
  bleed(key: 'bleed', desc: 'bleed', icon: 'images/stat_dot_bleed-mstatdef_icon.webp'),
  windShear(key: 'wind-shear', desc: 'windshear', icon: 'images/stat_dot_poison-mstatdef_icon.webp'),
  entanglement(key: 'entanglement', desc: 'entanglement', icon: 'images/stat_entangle-mstatdef_icon.webp'),
  unknown(key: 'unknown', desc: '', icon: '');

  final String key;
  final String desc;
  final String icon;

  const DebuffType({
    required this.key,
    required this.desc,
    required this.icon,
  });

  static List<DebuffType> validValues() {
    return DebuffType.values.where((d) => d != DebuffType.unknown).toList();
  }

  static DebuffType fromName(String name) {
    return DebuffType.values.firstWhere((d) => d.name == name, orElse: () => DebuffType.unknown);
  }

  static DebuffType fromKey(String key) {
    return DebuffType.values.firstWhere((d) => d.key == key, orElse: () => DebuffType.unknown);
  }
}

class Record<K, V> {
  late K key;
  late V value;

  Record.of(K key, V value) {
    this.key = key;
    this.value = value;
  }

  @override
  String toString() {
    return "${key.toString()},${value.toString()}";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is Record) {
      return runtimeType == other.runtimeType &&
          key == other.key &&
          value == other.value;
    } else {
      return false;
    }
  }
  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + key.hashCode;
    result = 37 * result + value.hashCode;
    return result;
  }
}
