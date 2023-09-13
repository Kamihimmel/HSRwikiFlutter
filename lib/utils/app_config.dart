import 'dart:convert';

class AppConfig {
  bool male = false;
  bool spoilerMode = false;
  bool cnMode = false;
  bool test = false; // 不存储
  int dmgScale = 10; // footer option: damage scale
  int statScale = 10;  // footer option: stat scale

  AppConfig.empty();

  AppConfig.fromJson(Map<String, dynamic> jsonMap) {
    this.male = jsonMap['male'];
    this.spoilerMode = jsonMap['spoiler_mode'];
    this.cnMode = jsonMap['cn_mode'];
    this.test = jsonMap['test'] ?? false;
    this.dmgScale = jsonMap['dmg_scale'];
    this.statScale = jsonMap['stat_scale'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['male'] = this.male;
    data['spoiler_mode'] = this.spoilerMode;
    data['cn_mode'] = this.cnMode;
    data['dmg_scale'] = this.dmgScale;
    data['stat_scale'] = this.statScale;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(this.toJson());
  }
}