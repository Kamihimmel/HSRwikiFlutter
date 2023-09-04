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
    return entity.getName(lang);
  }

  CharacterSkilldata getSkillById(String skillId) {
    return entity.skilldata.firstWhere((skill) => skill.id == skillId, orElse: () => CharacterSkilldata());
  }

  String getSkillName(int index, String lang) {
    return entity.skilldata[index].getName(lang);
  }

  String getSkillNameById(String skillId, String lang) {
    return entity.skilldata.firstWhere((skill) => skill.id == skillId, orElse: () => CharacterSkilldata()).getName(lang);
  }

  String getSkillDescription(int index, String lang) {
    return entity.skilldata[index].getDescription(lang);
  }

  CharacterTracedata getTraceById(String traceId) {
    return entity.tracedata.firstWhere((trace) => trace.id == traceId, orElse: () => CharacterTracedata());
  }

  String getTraceName(int index, String lang) {
    return entity.tracedata[index].getName(lang);
  }

  String getTraceNameById(String traceId, String lang) {
    return entity.tracedata.firstWhere((trace) => trace.id == traceId, orElse: () => CharacterTracedata()).getName(lang);
  }

  String getTraceDescription(int index, String lang) {
    return entity.tracedata[index].getDescription(lang);
  }

  CharacterEidolon getEidolonByNum(int eidolonNum) {
    return entity.eidolon.firstWhere((eidolon) => eidolon.eidolonnum == eidolonNum, orElse: () => CharacterEidolon());
  }

  CharacterEidolon getEidolonById(String eidolonId) {
    return entity.eidolon.firstWhere((eidolon) => eidolon.id == eidolonId, orElse: () => CharacterEidolon());
  }

  String getEidolonName(int index, String lang) {
    return entity.eidolon[index].getName(lang);
  }

  String getEidolonDescription(int index, String lang) {
    return entity.eidolon[index].getDescription(lang);
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
