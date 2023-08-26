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

  String getTraceName(int index, String lang) {
    switch(lang) {
      case 'en':
        return entity.tracedata[index].eNname;
      case 'zh':
        return entity.tracedata[index].cNname;
      case 'ja':
        return entity.tracedata[index].jAname;
    }
    return '';
  }

  String getTraceDescription(int index, String lang) {
    switch(lang) {
      case 'en':
        return entity.tracedata[index].descriptionEN;
      case 'zh':
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
      case 'ja':
        return entity.eidolon[index].descriptionJP;
    }
    return '';
  }

  String getImageLargeUrl(GlobalState _gs) {
    return _gs.getAppConfig().male && this.entity.imagelargeurlalter != '' ? this.entity.imagelargeurlalter : this.entity.imagelargeurl;
  }

  String getImageUrl(GlobalState _gs) {
    return _gs.getAppConfig().male && this.entity.imageurlalter != '' ? this.entity.imageurlalter : this.entity.imageurl;
  }
}