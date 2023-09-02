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

  double getBaseHp(int level, {promotion = false}) {
    return entity.leveldata.firstWhere((d) => d.level == "$level${promotion ? '+' : ''}", orElse: () => _emptyLeveldata).hp;
  }

  double getBaseAtk(int level, {promotion = false}) {
    return entity.leveldata.firstWhere((d) => d.level == "$level${promotion ? '+' : ''}", orElse: () => _emptyLeveldata).atk;
  }

  double getBaseDef(int level, {promotion = false}) {
    return entity.leveldata.firstWhere((d) => d.level == "$level${promotion ? '+' : ''}", orElse: () => _emptyLeveldata).def;
  }

  String getName(String lang) {
    switch(lang) {
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
    switch(lang) {
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
    switch(lang) {
      case 'en':
        return entity.skilldata[index].descriptionEN;
      case 'zh':
        return entity.skilldata[index].descriptionCN;
      case 'cn':
        return entity.skilldata[index].descriptionCN;
      case 'ja':
        return entity.skilldata[index].descriptionJP;
    }
    return '';
  }

  String getEffectKey(String iid) {
    return "${entity.id}-$iid";
  }
}
