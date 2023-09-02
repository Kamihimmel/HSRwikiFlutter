import 'dart:convert';

import '../components/global_state.dart';
import '../utils/helper.dart';
import 'character_entity.dart';

class Character {

  static final CharacterLeveldata _emptyLeveldata = CharacterLeveldata();

  late CharacterEntity entity;
  bool loaded = false;
  bool spoiler = false;
  bool supported = false;
  late ElementType elementType;
  late PathType pathType;
  late int order;

  Character();

  static fromJson(Map<String, dynamic> json, {spoiler = false, supported = true, order = 999}) {
    final entity = CharacterEntity.fromJson(json);
    Character character = Character();
    character.entity = entity;
    character.spoiler = spoiler;
    character.supported = supported;
    character.elementType = ElementType.fromName(character.entity.etype);
    character.pathType = PathType.fromName(character.entity.wtype);
    character.order = order;
    return character;
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

  String getSkillNameById(String skillId, String lang) {
    CharacterSkilldata skillData = entity.skilldata.firstWhere((skill) => skill.id == skillId, orElse: () => CharacterSkilldata());
    switch(lang) {
      case 'en':
        return skillData.eNname;
      case 'zh':
        return skillData.cNname;
      case 'cn':
        return skillData.cNname;
      case 'ja':
        return skillData.jAname;
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

  String getTraceName(int index, String lang) {
    switch(lang) {
      case 'en':
        return entity.tracedata[index].eNname;
      case 'zh':
        return entity.tracedata[index].cNname;
      case 'cn':
        return entity.tracedata[index].cNname;
      case 'ja':
        return entity.tracedata[index].jAname;
    }
    return '';
  }

  String getTraceNameById(String traceId, String lang) {
    CharacterTracedata traceData = entity.tracedata.firstWhere((trace) => trace.id == traceId, orElse: () => CharacterTracedata());
    switch(lang) {
      case 'en':
        return traceData.eNname;
      case 'zh':
        return traceData.cNname;
      case 'cn':
        return traceData.cNname;
      case 'ja':
        return traceData.jAname;
    }
    return '';
  }

  String getTraceDescription(int index, String lang) {
    switch(lang) {
      case 'en':
        return entity.tracedata[index].descriptionEN;
      case 'zh':
        return entity.tracedata[index].descriptionCN;
      case 'cn':
        return entity.tracedata[index].descriptionCN;
      case 'ja':
        return entity.tracedata[index].descriptionJP;
    }
    return '';
  }

  String getEidolonName(int index, String lang) {
    switch(lang) {
      case 'en':
        return entity.eidolon[index].eNname;
      case 'zh':
        return entity.eidolon[index].cNname;
      case 'cn':
        return entity.eidolon[index].cNname;
      case 'ja':
        return entity.eidolon[index].jAname;
    }
    return '';
  }

  String getEidolonDescription(int index, String lang) {
    switch(lang) {
      case 'en':
        return entity.eidolon[index].descriptionEN;
      case 'zh':
        return entity.eidolon[index].descriptionCN;
      case 'cn':
        return entity.eidolon[index].descriptionCN;
      case 'ja':
        return entity.eidolon[index].descriptionJP;
    }
    return '';
  }

  String getImageLargeUrl(GlobalState _gs) {
    return _gs.male && this.entity.imagelargeurlalter != '' ? this.entity.imagelargeurlalter : this.entity.imagelargeurl;
  }

  String getImageUrl(GlobalState _gs) {
    return _gs.male && this.entity.imageurlalter != '' ? this.entity.imageurlalter : this.entity.imageurl;
  }

  String getEffectKey(String skillId, String iid) {
    return "${entity.id}-$skillId-$iid";
  }
}
