import 'package:easy_localization/easy_localization.dart';
import 'package:hsrwikiproject/calculator/basic.dart';

import '../relics/relic.dart';
import '../relics/relic_manager.dart';

class CharacterStats {
  String id = '';
  String updateTime = '';
  int level = 0;
  int promotion = 0;
  int rank = 0;
  Map<String, int> skillLevels = {};
  Map<String, int> traceLevels = {};
  String lightconeId = '';
  int lightconeLevel = 0;
  Map<RelicPart, RelicStats> relics = {};

  CharacterStats.fromImportJson(Map<String, dynamic> jsonMap) {
    this.id = jsonMap['id'];
    this.updateTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    this.level = jsonMap['level'];
    this.promotion = jsonMap['promotion'];
    this.rank = jsonMap['rank'];
    for (var s in jsonMap['skills']) {
      skillLevels[s['id']] = s['level'];
    }
    for (var t in jsonMap['skill_trees']) {
      traceLevels[t['id']] = t['level'];
    }
    this.lightconeId = jsonMap['light_cone']['id'];
    this.lightconeLevel = jsonMap['light_cone']['level'];
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
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {};
    jsonMap['id'] = this.id;
    jsonMap['update_time'] = this.updateTime;
    jsonMap['level'] = this.level;
    jsonMap['promotion'] = this.promotion;
    jsonMap['rank'] = this.rank;
    jsonMap['skill_levels'] = this.skillLevels;
    jsonMap['lightcone_id'] = this.lightconeId;
    jsonMap['lightcone_level'] = this.lightconeLevel;
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