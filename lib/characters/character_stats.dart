import 'package:easy_localization/easy_localization.dart';

import '../calculator/basic.dart';
import '../calculator/effect_entity.dart';
import '../relics/relic.dart';
import '../relics/relic_manager.dart';
import 'character_manager.dart';

class CharacterStats {
  String id = '';
  String updateTime = '';
  String level = '1';
  int promotion = 0;
  Map<String, int> eidolons = {};
  Map<String, int> skillLevels = {};
  Map<String, int> traceLevels = {};
  String lightconeId = '';
  String lightconeLevel = '1';
  int lightconeRank = 1;
  Map<RelicPart, RelicStats> relics = {};
  List<EffectEntity> effects = [];

  String getLightconeId() {
    if (lightconeId == '') {
      return CharacterManager.getDefaultLightcone(id);
    }
    return lightconeId;
  }

  List<String> getRelicSets({withDefault = true}) {
    if (withDefault && relics.isEmpty) {
      return CharacterManager.getDefaultRelicSets(id);
    }
    List<String> sets = ['', '', ''];
    List<String> setIds4 = relics.entries.where((e) => e.key.xSet == '4').map((e) => e.value.setId).toList();
    Map<String, int> validSet4 = setIds4.fold({}, (value, e) {
      int cnt = value[e] ?? 0;
      value[e] = cnt + 1;
      return value;
    });
    if (validSet4.values.any((v) => v == 4)) {
      String sId = validSet4.entries.firstWhere((e) => e.value == 4).key;
      sets[0] = sId;
      sets[1] = sId;
    } else {
      List<String> validSet2 = validSet4.entries.where((e) => e.value >= 2).map((e) => e.key.toString()).toList();
      for (var i = 0; i < validSet2.length; i++) {
        sets[i] = validSet2[i];
      }
    }
    List<String> setIds2 = relics.entries.where((e) => e.key.xSet == '2').map((e) => e.value.setId).toList();
    if (setIds2.length == 2 && setIds2[0] == setIds2[1]) {
      sets[2] = setIds2[0];
    }
    return sets;
  }

  CharacterStats.empty() {

  }

  CharacterStats.fromImportJson(Map<String, dynamic> jsonMap, {String? updateTime}) {
    this.id = jsonMap['id'];
    if (updateTime == null) {
      this.updateTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    } else {
      this.updateTime = updateTime;
    }
    this.level = jsonMap['level'].toString();
    this.promotion = jsonMap['promotion'];
    int rank = jsonMap['rank'] ?? 0;
    for (int i = 0; i <= rank; i++) {
      eidolons[i.toString()] = 1;
    }
    this.lightconeId = jsonMap['light_cone']['id'];
    this.lightconeLevel = jsonMap['light_cone']['level'].toString();
    this.lightconeRank = jsonMap['light_cone']['rank'];
    for (var s in jsonMap['skills']) {
      skillLevels[s['id']] = s['level'];
    }
    for (var t in jsonMap['skill_trees']) {
      traceLevels[t['id']] = t['level'];
    }
    for (var r in jsonMap['relics']) {
      String setId = r['set_id'];
      Relic relic = RelicManager.getRelic(setId);
      String icon = r['icon'];
      int partOrd = num.tryParse(icon.substring(icon.lastIndexOf('_') + 1, icon.lastIndexOf('.')))?.toInt() ?? -1;
      RelicPart part = RelicPart.fromOrdAndSet(partOrd, relic.entity.xSet);
      if (part == RelicPart.unknown) {
        continue;
      }
      RelicStats stats = RelicStats();
      stats.setId = setId;
      stats.rarity = r['rarity'];
      stats.level = r['level'];
      stats.mainAttr = FightProp.fromImportType(r['main_affix']['type']);
      for (var sub in r['sub_affix']) {
        stats.subAttrValues[FightProp.fromImportType(sub['type'])] = sub['value'];
      }
      this.relics[part] = stats;
    }
  }

  CharacterStats.fromJson(Map<String, dynamic> jsonMap) {
    this.id = jsonMap['id'];
    this.updateTime = jsonMap['update_time'];
    this.level = jsonMap['level'];
    this.promotion = jsonMap['promotion'];
    for (var e in jsonMap['eidolons'].entries) {
      this.eidolons[e.key] = e.value;
    }
    this.lightconeId = jsonMap['lightcone_id'];
    this.lightconeLevel = jsonMap['lightcone_level'];
    this.lightconeRank = jsonMap['lightcone_rank'];
    for (var e in jsonMap['skill_levels'].entries) {
      this.skillLevels[e.key] = e.value;
    }
    for (var e in jsonMap['trace_levels'].entries) {
      this.traceLevels[e.key] = e.value;
    }
    for (var e in jsonMap['relics'].entries) {
      RelicPart rp = RelicPart.fromName(e.key);
      Map<String, dynamic> statsMap = e.value;
      RelicStats rs = RelicStats();
      rs.setId = statsMap['set_id'];
      rs.rarity = statsMap['rarity'];
      rs.level = statsMap['level'];
      rs.mainAttr = FightProp.fromName(statsMap['main_attr']);
      Map<String, dynamic> subValueMap = statsMap['sub_attr_values'];
      for (var sub in subValueMap.entries) {
        rs.subAttrValues[FightProp.fromName(sub.key)] = sub.value;
      }
      this.relics[rp] = rs;
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {};
    jsonMap['id'] = this.id;
    jsonMap['update_time'] = this.updateTime;
    jsonMap['level'] = this.level;
    jsonMap['promotion'] = this.promotion;
    jsonMap['eidolons'] = this.eidolons;
    jsonMap['lightcone_id'] = this.lightconeId;
    jsonMap['lightcone_level'] = this.lightconeLevel;
    jsonMap['lightcone_rank'] = this.lightconeRank;
    jsonMap['skill_levels'] = this.skillLevels;
    jsonMap['trace_levels'] = this.traceLevels;
    Map<String, dynamic> relicMap = {};
    for (var e in this.relics.entries) {
      Map<String, dynamic> partMap = {};
      partMap['set_id'] = e.value.setId;
      partMap['rarity'] = e.value.rarity;
      partMap['level'] = e.value.level;
      partMap['main_attr'] = e.value.mainAttr.name;
      Map<String, double> subMap = {};
      for (var s in e.value.subAttrValues.entries) {
        subMap[s.key.name] = s.value;
      }
      partMap['sub_attr_values'] = subMap;
      relicMap[e.key.name] = partMap;
    }
    jsonMap['relics'] = relicMap;
    return jsonMap;
  }
}