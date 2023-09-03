import 'dart:convert';

import '../calculator/basic.dart';
import '../utils/helper.dart';
import 'relic_entity.dart';

class Relic {
  late RelicEntity entity;
  bool loaded = false;
  bool spoiler = false;
  late int order;

  Relic() {
    this.entity = RelicEntity();
  }

  static fromJson(Map<String, dynamic> json, {spoiler = false, order = 999}) {
    final entity = RelicEntity.fromJson(json);
    Relic relic = Relic();
    relic.entity = entity;
    relic.spoiler = spoiler;
    relic.order = order;
    return relic;
  }

  String getName(String lang) {
    return entity.getName(lang);
  }

  RelicSkilldata getSkill(int index) {
    return entity.skilldata[index];
  }

  String getSkillName(int index, String lang) {
    return entity.skilldata[index].getName(lang);
  }

  String getSkillDescription(int index, String lang) {
    return entity.skilldata[index].getDescription(lang);
  }

  String getPartImageUrl(RelicPart rp) {
    switch (rp) {
      case RelicPart.head:
        return entity.head;
      case RelicPart.hands:
        return entity.hands;
      case RelicPart.body:
        return entity.body;
      case RelicPart.feet:
        return entity.feet;
      case RelicPart.sphere:
        return entity.sphere;
      case RelicPart.rope:
        return entity.rope;
      case RelicPart.unknown:
        return '';
    }
  }

  String getEffectKey(String xSet, String iid) {
    return "${entity.id}-$xSet-$iid";
  }
}

enum RelicPart {
  head(ord: 0, xSet: "4", icon: 'images/IconRelicHead.png', mainAttrs: [FightProp.hPDelta]),
  hands(ord: 1, xSet: "4", icon: 'images/IconRelicHands.png', mainAttrs: [FightProp.attackDelta]),
  body(ord: 2, xSet: "4", icon: 'images/IconRelicBody.png', mainAttrs: [
    FightProp.hPAddedRatio,
    FightProp.attackAddedRatio,
    FightProp.defenceAddedRatio,
    FightProp.statusProbability,
    FightProp.healRatio,
    FightProp.criticalDamage,
    FightProp.criticalChance
  ]),
  feet(
      ord: 3, xSet: "4", icon: 'images/IconRelicFoot.png',
      mainAttrs: [FightProp.hPAddedRatio, FightProp.attackAddedRatio, FightProp.defenceAddedRatio, FightProp.breakDamageAddedRatio, FightProp.speedDelta]),
  sphere(ord: 0, xSet: "2", icon: 'images/IconRelicNeck.png', mainAttrs: [
    FightProp.hPAddedRatio,
    FightProp.attackAddedRatio,
    FightProp.defenceAddedRatio,
    FightProp.physicalAddedRatio,
    FightProp.quantumAddedRatio,
    FightProp.fireAddedRatio,
    FightProp.iceAddedRatio,
    FightProp.lightningAddedRatio,
    FightProp.windAddedRatio,
    FightProp.imaginaryAddedRatio
  ]),
  rope(
      ord: 1, xSet: "2", icon: 'images/IconRelicGoods.png', mainAttrs: [FightProp.hPAddedRatio, FightProp.attackAddedRatio, FightProp.defenceAddedRatio, FightProp.breakDamageAddedRatio, FightProp.sPRatio]),
  unknown(ord: -1, xSet: "0", icon: '', mainAttrs: []);

  final int ord;
  final String xSet;
  final String icon;
  final List<FightProp> mainAttrs;

  const RelicPart({
    required this.ord,
    required this.xSet,
    required this.icon,
    required this.mainAttrs,
  });

  static RelicPart fromName(String name) {
    return RelicPart.values.firstWhere((r) => r.name == name, orElse: () => RelicPart.unknown);
  }

  static RelicPart fromOrdAndSet(int ord, String xSet) {
    return RelicPart.values.firstWhere((r) => r.ord == ord && r.xSet == xSet, orElse: () => RelicPart.unknown);
  }
}

List<FightProp> relicSubAttrs = [
  FightProp.unknown,
  FightProp.hPDelta,
  FightProp.hPAddedRatio,
  FightProp.attackDelta,
  FightProp.attackAddedRatio,
  FightProp.defenceDelta,
  FightProp.defenceAddedRatio,
  FightProp.criticalChance,
  FightProp.criticalDamage,
  FightProp.statusResistance,
  FightProp.statusProbability,
  FightProp.breakDamageAddedRatio,
  FightProp.speedDelta,
];

class RelicStats {
  String setId = '';
  int rarity = 0;
  int level = 0;
  FightProp mainAttr = FightProp.unknown;
  List<Record<FightProp, double>> subAttrValues = [];

  RelicStats();

  RelicStats.empty(RelicPart part) {
    this.rarity = 5;
    this.level = 15;
    this.mainAttr = part.mainAttrs[0];
  }

  double getMainAttrValue() {
    return getRelicMainAttrValue(mainAttr, rarity, level);
  }

  double getMainAttrValueByProp(FightProp prop) {
    if (mainAttr != prop) {
      return 0;
    }
    return getRelicMainAttrValue(mainAttr, rarity, level);
  }

  double getSubAttrValueByProp(FightProp prop) {
    return subAttrValues.firstWhere((record) => record.key == prop, orElse: () => Record.of(prop, 0)).value;
  }
}

double getRelicMainAttrValue(FightProp fightProp, int rarity, int level) {
  if (ElementType.getElementAddRatioProps().contains(fightProp)) {
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

int getRelicMaxLevel(int rarity) {
  if (rarity >= 2 && rarity <= 5) {
    return rarity * 3;
  }
  return 0;
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
