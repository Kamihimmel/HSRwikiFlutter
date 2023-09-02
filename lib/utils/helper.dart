import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../calculator/basic.dart';
import '../calculator/effect_entity.dart';
import '../calculator/effect_manager.dart';
import '../characters/character_entity.dart';
import '../characters/character_manager.dart';
import '../components/global_state.dart';
import '../enemies/enemy_manager.dart';
import '../lightcones/lightcone_manager.dart';
import '../relics/relic_manager.dart';

final GlobalState _gs = GlobalState();
final String urlEndpoint = "https://hsrwikidata.yunlu18.net/";
final String cnUrlEndpoint = "https://hsrwikidata.kchlu.com/";

String getUrlEndpoint() {
  return _gs.cnMode ? cnUrlEndpoint : urlEndpoint;
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
      String endpoint = _gs.cnMode ? cnUrlEndpoint : urlEndpoint;
      url = endpoint + path;
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

Future<String> loadLibJsonString(String path, {cnMode = false}) async {
  if (cnMode) {
    final response = await http.get(Uri.parse(cnUrlEndpoint + path));
    return response.body;
  } else {
    final response = await http.get(Uri.parse(urlEndpoint + path));
    return response.body;
  }
}

String getDisplayText(double value, bool percent) {
  if (percent) {
    return ((value * 1000).floor() / 10).toStringAsFixed(1) + '%';
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

  FightProp getElementAddRatioProp() {
    return FightProp.fromName("${this.name}AddedRatio");
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
