import 'dart:convert';

import '../utils/helper.dart';
import 'enemy_entity.dart';

class Enemy {
  late EnemyEntity entity;
  late EnemyCategory category;
  late EnemyType type;
  List<ElementType> weakness = [];
  Map<ElementType, int> resistence = {};
  Map<DebuffType, int> effectResistence = {};
  bool spoiler = false;
  late int order;

  static fromJson(Map<String, dynamic> json, {spoiler = false, order = 999}) {
    final entity = EnemyEntity.fromJson(json);
    Enemy enemy = Enemy();
    enemy.entity = entity;
    enemy.category = EnemyCategory.fromDesc(entity.category);
    enemy.type = EnemyType.fromName(entity.etype);
    enemy.weakness = entity.weakness.map((e) => ElementType.fromName(e)).toList();
    entity.resistence.forEach((key, value) {
      enemy.resistence[ElementType.fromName(key)] = value;
    });
    entity.effectres.forEach((key, value) {
      enemy.effectResistence[DebuffType.fromKey(key)] = value;
    });
    enemy.spoiler = spoiler;
    enemy.order = order;
    return enemy;
  }

  String getName(String lang) {
    return entity.getName(lang);
  }
}

enum EnemyCategory {
  antimatterLegion(desc: 'Antimatter Legion', icon: 'images/antimatter-legion-monster_faction_icon.webp'),
  jariloVI(desc: 'Jarilo-VI', icon: 'images/jarilo-vi-monster_faction_icon.webp'),
  theXianzhouLuofu(desc: 'The Xianzhou Luofu', icon: 'images/the-xianzhou-luofu-monster_faction_icon.webp'),
  fragmentumMonsters(desc: 'Fragmentum Monsters', icon: 'images/fragmentum-monsters-monster_faction_icon.webp'),
  simulatedUniverse(desc: 'Simulated Universe', icon: 'images/simulated-universe-monster_faction_icon.webp'),
  stellaronHunters(desc: 'Stellaron Hunters', icon: 'images/stellaron-hunters-monster_faction_icon.webp'),
  cosmos(desc: 'Cosmos', icon: 'images/cosmos-monster_faction_icon.webp'),
  other(desc: 'Other', icon: 'images/other-monster_faction_icon.webp');

  final String desc;
  final String icon;

  const EnemyCategory({
    required this.desc,
    required this.icon,
  });

  static EnemyCategory fromDesc(String desc) {
    return EnemyCategory.values.firstWhere((e) => e.desc == desc, orElse: () => EnemyCategory.other);
  }
}

enum EnemyType {
  minion,
  normal,
  elite,
  boss;

  static EnemyType fromName(String name) {
    return EnemyType.values.firstWhere((e) => e.name == name, orElse: () => EnemyType.normal);
  }
}

class EnemyStats {
  String id = '';
  int level = 72;
  int defenceReduce = 0;
  double damageReceive = 0;
  bool weaknessBreak = false;
  int maxhp = 200000;
  int toughness = 1;

  EnemyStats.empty();

  EnemyStats.fromJson(Map<String, dynamic> jsonMap) {
    this.id = jsonMap['id'] ?? '';
    this.level = jsonMap['level'];
    this.defenceReduce = jsonMap['defence_reduce'];
    this.damageReceive = jsonMap['damage_receive'];
    this.weaknessBreak = jsonMap['weakness_break'];
    this.maxhp = jsonMap['maxhp'];
    this.toughness = jsonMap['toughness'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {};
    jsonMap['id'] = this.id;
    jsonMap['level'] = this.level;
    jsonMap['defence_reduce'] = this.defenceReduce;
    jsonMap['damage_receive'] = this.damageReceive;
    jsonMap['weakness_break'] = this.weaknessBreak;
    jsonMap['maxhp'] = this.maxhp;
    jsonMap['toughness'] = this.toughness;
    return jsonMap;
  }

  @override
  String toString() {
    return jsonEncode(this.toJson());
  }
}
