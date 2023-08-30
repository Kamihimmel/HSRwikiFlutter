import 'dart:convert';

import '../calculator/basic.dart';
import '../utils/helper.dart';
import 'relic_entity.dart';

class Relic {
  late RelicEntity entity;
  bool loaded = false;
  bool spoiler = false;
  late PathType pathType;
  late int order;

  Relic();

  static fromJson(Map<String, dynamic> json, {spoiler = false, order = 999}) {
    final entity = RelicEntity.fromJson(json);
    Relic relic = Relic();
    relic.entity = entity;
    relic.spoiler = spoiler;
    relic.order = order;
    return relic;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }

  String getName(String lang) {
    switch (lang) {
      case 'en':
        return entity.eNname;
      case 'zh':
        return entity.cNname;
      case 'cn':
        return entity.cNname;
      case 'ja':
        return entity.jAname;
    }
    return '';
  }

  String getSkillName(int index, String lang) {
    switch (lang) {
      case 'en':
        return entity.skilldata[index].eNname;
      case 'zh':
        return entity.skilldata[index].cNname;
      case 'cn':
        return entity.skilldata[index].cNname;
      case 'ja':
        return entity.skilldata[index].jAname;
    }
    return '';
  }

  String getSkillDescription(int index, String lang) {
    switch (lang) {
      case 'en':
        return entity.skilldata[index].descriptionEN;
      case 'zh':
        return entity.skilldata[index].descriptionCN;
      case 'ja':
        return entity.skilldata[index].descriptionJP;
    }
    return '';
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
}

enum RelicPart {
  head(ord: 0, xSet: "4", mainAttrs: [FightProp.hPDelta]),
  hands(ord: 1, xSet: "4", mainAttrs: [FightProp.attackDelta]),
  body(ord: 2, xSet: "4", mainAttrs: [
    FightProp.hPAddedRatio,
    FightProp.attackAddedRatio,
    FightProp.defenceAddedRatio,
    FightProp.statusProbability,
    FightProp.healRatio,
    FightProp.criticalDamage,
    FightProp.criticalChance
  ]),
  feet(
      ord: 3, xSet: "4",
      mainAttrs: [FightProp.hPAddedRatio, FightProp.attackAddedRatio, FightProp.defenceAddedRatio, FightProp.breakDamageAddedRatio, FightProp.speedDelta]),
  sphere(ord: 0, xSet: "2", mainAttrs: [
    FightProp.hPAddedRatio,
    FightProp.attackAddedRatio,
    FightProp.defenceAddedRatio,
    FightProp.physicalAddedRatio,
    FightProp.fireAddedRatio,
    FightProp.iceAddedRatio,
    FightProp.thunderAddedRatio,
    FightProp.windAddedRatio,
    FightProp.thunderAddedRatio,
    FightProp.imaginaryAddedRatio
  ]),
  rope(
      ord: 1, xSet: "2", mainAttrs: [FightProp.hPAddedRatio, FightProp.attackAddedRatio, FightProp.defenceAddedRatio, FightProp.breakDamageAddedRatio, FightProp.sPRatio]),
  unknown(ord: -1, xSet: "0", mainAttrs: []);

  final int ord;
  final String xSet;
  final List<FightProp> mainAttrs;

  const RelicPart({
    required this.ord,
    required this.xSet,
    required this.mainAttrs,
  });

  static RelicPart fromName(String name) {
    return RelicPart.values.firstWhere((r) => r.name == name, orElse: () => RelicPart.unknown);
  }

  static RelicPart fromOrdAndSet(int ord, String xSet) {
    return RelicPart.values.firstWhere((r) => r.ord == ord && r.xSet == xSet, orElse: () => RelicPart.unknown);
  }
}

class RelicStats {
  String setId = '';
  int rarity = 0;
  int level = 0;
  FightProp mainAttr = FightProp.none;
  Map<FightProp, double> subAttrValues = {};

  RelicStats() {

  }

  RelicStats.empty(RelicPart part, String setId) {
    this.setId = setId;
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
    return subAttrValues.containsKey(prop) ? subAttrValues[prop]! : 0;
  }
}
