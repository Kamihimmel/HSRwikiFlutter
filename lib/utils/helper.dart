import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../calculator/basic.dart';
import '../characters/character_manager.dart';
import '../components/global_state.dart';
import '../info.dart';

final GlobalState _gs = GlobalState();
final String urlEndpoint = "https://hsrwikidata.yunlu18.net/";
final String cnUrlEndpoint = "https://hsrwikidata.kchlu.com/";

getImageComponent(String path,
    {remote = true, imageWrap = false, fit = BoxFit.cover, alignment = Alignment.center, Uint8List? placeholder, double? width, double? height}) {
  ImageProvider _imageProvider;
  if (remote) {
    String url;
    if (path.startsWith('http://') || path.startsWith("https://")) {
      url = path;
    } else {
      String endpoint = _gs.getAppConfig().cnMode ? cnUrlEndpoint : urlEndpoint;
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

String getLanguageCode(BuildContext context) {
  return EasyLocalization.of(context)?.currentLocale?.languageCode ?? '';
}

Future<String> loadLibJsonString(String path, {cnMode = false}) async {
  if (cnMode) {
    final response = await http.get(Uri.parse(urlEndpoint + path));
    return response.body;
  } else {
    final response = await http.get(Uri.parse(cnUrlEndpoint + path));
    return response.body;
  }
}

int getRelicMaxLevel(int rarity) {
  if (rarity >= 2 && rarity <= 5) {
    return rarity * 3;
  }
  return 0;
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

var _elementDamage = [
  FightProp.physicalAddedRatio,
  FightProp.fireAddedRatio,
  FightProp.iceAddedRatio,
  FightProp.thunderAddedRatio,
  FightProp.windAddedRatio,
  FightProp.thunderAddedRatio,
  FightProp.imaginaryAddedRatio,
  FightProp.quantumAddedRatio,
];

double getRelicMainAttrValue(FightProp fightProp, int rarity, int level) {
  if (_elementDamage.contains(fightProp)) {
    fightProp = FightProp.allDamageAddRatio;
  }
  if (!relicMainAttrLevelCurve.containsKey(fightProp)) {
    return 0;
  }
  var startCurve = relicMainAttrLevelCurve[fightProp]!;
  if (!startCurve.containsKey(rarity)) {
    return 0;
  }
  double base = startCurve[rarity]!['base']!.toDouble();
  double add = startCurve[rarity]!['add']!.toDouble();
  return base + level * add;
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

String imagestring(String cid) {
  if (cid == '8001' || cid == '8002') {
    if (gender) {
      return "images/characters/mc.webp";
    } else {
      return "images/characters/mcm.webp";
    }
  } else if (cid == '8003' || cid == '8004') {
    if (gender) {
      return "images/characters/mcf.webp";
    } else {
      return "images/characters/mcmf.webp";
    }
  } else {
    return CharacterManager.getCharacter(cid).entity.imageurl;
  }
}

const relicMainAttrLevelCurve = {
  FightProp.hPDelta: {
    2: {"base": 45.1584, "add": 15.80544},
    3: {"base": 67.7376, "add": 23.70816},
    4: {"base": 90.3168, "add": 31.61088},
    5: {"base": 112.896, "add": 39.5136}
  },
  FightProp.attackDelta: {
    2: {"base": 22.5792, "add": 7.90272},
    3: {"base": 33.8688, "add": 11.85408},
    4: {"base": 45.1584, "add": 15.80544},
    5: {"base": 56.448, "add": 19.7568}
  },
  FightProp.hPAddedRatio: {
    2: {"base": 0.02765, "add": 0.00968},
    3: {"base": 0.04147, "add": 0.01452},
    4: {"base": 0.0553, "add": 0.01935},
    5: {"base": 0.06912, "add": 0.02419}
  },
  FightProp.attackAddedRatio: {
    2: {"base": 0.02765, "add": 0.00968},
    3: {"base": 0.04147, "add": 0.01452},
    4: {"base": 0.0553, "add": 0.01935},
    5: {"base": 0.06912, "add": 0.02419}
  },
  FightProp.defenceAddedRatio: {
    2: {"base": 0.03456, "add": 0.0121},
    3: {"base": 0.05184, "add": 0.01814},
    4: {"base": 0.06912, "add": 0.02419},
    5: {"base": 0.0864, "add": 0.03024}
  },
  FightProp.criticalChance: {
    2: {"base": 0.02074, "add": 0.00726},
    3: {"base": 0.0311, "add": 0.01089},
    4: {"base": 0.04147, "add": 0.01452},
    5: {"base": 0.05184, "add": 0.01814}
  },
  FightProp.criticalDamage: {
    2: {"base": 0.04147, "add": 0.01452},
    3: {"base": 0.06221, "add": 0.02177},
    4: {"base": 0.08294, "add": 0.02903},
    5: {"base": 0.10368, "add": 0.03629}
  },
  FightProp.healRatio: {
    2: {"base": 0.02212, "add": 0.00774},
    3: {"base": 0.03318, "add": 0.01161},
    4: {"base": 0.04424, "add": 0.01548},
    5: {"base": 0.0553, "add": 0.01935}
  },
  FightProp.statusProbability: {
    2: {"base": 0.02765, "add": 0.00968},
    3: {"base": 0.04147, "add": 0.01452},
    4: {"base": 0.0553, "add": 0.01935},
    5: {"base": 0.06912, "add": 0.02419}
  },
  FightProp.speedDelta: {
    2: {"base": 1.6128, "add": 1},
    3: {"base": 2.4192, "add": 1},
    4: {"base": 3.2256, "add": 1.1},
    5: {"base": 4.032, "add": 1.4}
  },
  FightProp.allDamageAddRatio: {
    2: {"base": 0.02488, "add": 0.00871},
    3: {"base": 0.03732, "add": 0.01306},
    4: {"base": 0.04977, "add": 0.01742},
    5: {"base": 0.06221, "add": 0.02177}
  },
  FightProp.sPRatio: {
    2: {"base": 0.01244, "add": 0.00436},
    3: {"base": 0.01866, "add": 0.00653},
    4: {"base": 0.02488, "add": 0.00871},
    5: {"base": 0.0311, "add": 0.01089}
  },
  FightProp.breakDamageAddedRatio: {
    2: {"base": 0.04147, "add": 0.01452},
    3: {"base": 0.06221, "add": 0.02177},
    4: {"base": 0.08294, "add": 0.02903},
    5: {"base": 0.10368, "add": 0.03629}
  },
};

const relicLevelCurve1 = {};
