import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';

import '../characters/character_stats.dart';

class PlayerInfo {
  String uid = '';
  String nickname = '';
  int level = 0;
  int worldLevel = 0;
  int friendCount = 0;
  String avatar = '';
  String signature = '';
  String createTime = '';
  List<CharacterStats> characters = [];

  PlayerInfo.fromImportJson(Map<String, dynamic> jsonMap) {
    this.uid = jsonMap['player']['uid'];
    this.nickname = jsonMap['player']['nickname'];
    this.level = jsonMap['player']['level'];
    this.worldLevel = jsonMap['player']['world_level'];
    this.friendCount = jsonMap['player']['friend_count'];
    this.avatar = 'starrailres/' + jsonMap['player']['avatar']['icon'];
    this.signature = jsonMap['player']['signature'];
    this.createTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    this.characters = (jsonMap['characters'] as List<dynamic>).map((e) => CharacterStats.fromImportJson(e)).toList();
  }

  PlayerInfo.fromJson(Map<String, dynamic> jsonMap) {}

  String toJson() {
    Map<String, dynamic> jsonMap = {};
    jsonMap['uid'] = uid;
    jsonMap['nickname'] = nickname;
    jsonMap['level'] = level;
    jsonMap['world_level'] = worldLevel;
    jsonMap['friend_count'] = friendCount;
    jsonMap['avatar'] = avatar;
    jsonMap['signature'] = signature;
    jsonMap['create_time'] = createTime;
    jsonMap['characters'] = characters.map((c) => c.toJson()).toList();
    return jsonEncode(jsonMap);
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
