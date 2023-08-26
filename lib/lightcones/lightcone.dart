import 'dart:convert';

import '../utils/helper.dart';
import 'lightcone_entity.dart';

class Lightcone {

  static final LightconeLeveldata _emptyLeveldata = LightconeLeveldata();

  late LightconeEntity entity;
  bool loaded = false;
  bool spoiler = false;
  late PathType pathType;
  late int order;

  Lightcone();

  static fromJson(Map<String, dynamic> json, {spoiler = false, order = 999}) {
    final entity = LightconeEntity.fromJson(json);
    Lightcone lightcone = Lightcone();
    lightcone.entity = entity;
    lightcone.spoiler = spoiler;
    lightcone.pathType = PathType.fromName(lightcone.entity.wtype);
    lightcone.order = order;
    return lightcone;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }

  int getBaseHp(int level) {
    return entity.leveldata.firstWhere((d) => d.level == level.toString(), orElse: () => _emptyLeveldata).hp.toInt();
  }

  int getBaseAtk(int level) {
    return entity.leveldata.firstWhere((d) => d.level == level.toString(), orElse: () => _emptyLeveldata).atk.toInt();
  }

  int getBaseDef(int level) {
    return entity.leveldata.firstWhere((d) => d.level == level.toString(), orElse: () => _emptyLeveldata).def.toInt();
  }

  String getName(String lang) {
    switch(lang) {
      case 'en':
        return entity.eNname;
      case 'zh':
        return entity.cNname;
      case 'ja':
        return entity.jAname;
    }
    return '';
  }

  String getSkillName(int index, String lang) {
    switch(lang) {
      case 'en':
        return entity.skilldata[index].eNname;
      case 'zh':
        return entity.skilldata[index].cNname;
      case 'ja':
        return entity.skilldata[index].jAname;
    }
    return '';
  }

  String getSkillDescription(int index, String lang) {
    switch(lang) {
      case 'en':
        return entity.skilldata[index].descriptionEN;
      case 'zh':
        return entity.skilldata[index].descriptionCN;
      case 'ja':
        return entity.skilldata[index].descriptionJP;
    }
    return '';
  }
}