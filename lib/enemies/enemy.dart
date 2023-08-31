import '../utils/helper.dart';
import 'enemy_entity.dart';

class Enemy {
  late EnemyEntity entity;
  late EnemyCategory category;
  late EnemyType type;
  List<ElementType> weakness = [];
  Map<ElementType, int> resistence = {};
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
    enemy.spoiler = spoiler;
    enemy.order = order;
    return enemy;
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
}

enum EnemyCategory {
  antimatterLegion(desc: 'Antimatter Legion', icon: ''),
  jariloVI(desc: 'Jarilo-VI', icon: ''),
  theXianzhouLuofu(desc: 'The Xianzhou Luofu', icon: ''),
  fragmentumMonsters(desc: 'Fragmentum Monsters', icon: ''),
  simulatedUniverse(desc: 'Simulated Universe', icon: ''),
  stellaronHunters(desc: 'Stellaron Hunters', icon: ''),
  cosmos(desc: 'Cosmos', icon: ''),
  other(desc: 'Other', icon: '');

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
  bool weaknessBreak = false;

  EnemyStats.empty();

  EnemyStats.fromJson(Map<String, dynamic> jsonMap) {
    this.id = jsonMap['id'] ?? '';
    this.level = jsonMap['level'];
    this.defenceReduce = jsonMap['defence_reduce'];
    this.weaknessBreak = jsonMap['weakness_break'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {};
    jsonMap['id'] = this.id;
    jsonMap['level'] = this.level;
    jsonMap['defence_reduce'] = this.defenceReduce;
    jsonMap['weakness_break'] = this.weaknessBreak;
    return jsonMap;
  }
}
