import '../generated/json/base/json_convert_content.dart';
import '../generated/json/base/json_field.dart';
import 'effect_entity.dart';

@JsonSerializable()
class SkillData {
  late String id = '';
  @JSONField(name: "ENname")
  late String eNname = '';
  @JSONField(name: "CNname")
  late String cNname = '';
  @JSONField(name: "JAname")
  late String jAname = '';
  late String imageurl = '';
  @JSONField(name: "DescriptionEN")
  late String descriptionEN = '';
  @JSONField(name: "DescriptionCN")
  late String descriptionCN = '';
  @JSONField(name: "DescriptionJP")
  late String descriptionJP = '';
  late String stype = '';
  late int maxlevel = 0;
  late bool buffskill = false;
  late bool teamskill = false;
  late List<Map<String, dynamic>> levelmultiplier = [];
  late String referencelevel = '';
  late List<String> tags = [];
  late List<EffectEntity> effect = [];

  String getName(String lang) {
    switch(lang) {
      case 'en':
        return eNname;
      case 'zh':
        return cNname;
      case 'cn':
        return cNname;
      case 'ja':
        return jAname;
    }
    return '';
  }

  String getDescription(String lang) {
    switch(lang) {
      case 'en':
        return descriptionEN;
      case 'zh':
        return descriptionCN;
      case 'cn':
        return descriptionCN;
      case 'ja':
        return descriptionJP;
    }
    return '';
  }
}

void $SkilldataFromJson(Map<String, dynamic> json, SkillData skillData) {
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    skillData.id = id;
  }
  final String? eNname = jsonConvert.convert<String>(json['ENname']);
  if (eNname != null) {
    skillData.eNname = eNname;
  }
  final String? cNname = jsonConvert.convert<String>(json['CNname']);
  if (cNname != null) {
    skillData.cNname = cNname;
  }
  final String? jAname = jsonConvert.convert<String>(json['JAname']);
  if (jAname != null) {
    skillData.jAname = jAname;
  }
  final String? imageurl = jsonConvert.convert<String>(json['imageurl']);
  if (imageurl != null) {
    skillData.imageurl = imageurl;
  }
  final String? descriptionEN = jsonConvert.convert<String>(json['DescriptionEN']);
  if (descriptionEN != null) {
    skillData.descriptionEN = descriptionEN;
  }
  final String? descriptionCN = jsonConvert.convert<String>(json['DescriptionCN']);
  if (descriptionCN != null) {
    skillData.descriptionCN = descriptionCN;
  }
  final String? descriptionJP = jsonConvert.convert<String>(json['DescriptionJP']);
  if (descriptionJP != null) {
    skillData.descriptionJP = descriptionJP;
  }
  final String? stype = jsonConvert.convert<String>(json['stype']);
  if (stype != null) {
    skillData.stype = stype;
  }
  final int? maxlevel = jsonConvert.convert<int>(json['maxlevel']);
  if (maxlevel != null) {
    skillData.maxlevel = maxlevel;
  }
  final bool? buffskill = jsonConvert.convert<bool>(json['buffskill']);
  if (buffskill != null) {
    skillData.buffskill = buffskill;
  }
  final bool? teamskill = jsonConvert.convert<bool>(json['teamskill']);
  if (teamskill != null) {
    skillData.teamskill = teamskill;
  }
  final List<Map<String, dynamic>>? levelmultiplier = jsonConvert.convertListNotNull<Map<String, dynamic>>(json['levelmultiplier']);
  if (levelmultiplier != null) {
    skillData.levelmultiplier = levelmultiplier;
  }
  final String? referencelevel = jsonConvert.convert<String>(json['referencelevel']);
  if (referencelevel != null) {
    skillData.referencelevel = referencelevel;
  }
  final List<String>? tags = jsonConvert.convertListNotNull<String>(json['tags']);
  if (tags != null) {
    skillData.tags = tags;
  }
  final List<EffectEntity>? effect = jsonConvert.convertListNotNull<EffectEntity>(json['effect']);
  if (effect != null) {
    skillData.effect = effect;
  }
}

void $SkillDataToJson(SkillData skillData, Map<String, dynamic> data) {
  data['id'] = skillData.id;
  data['ENname'] = skillData.eNname;
  data['CNname'] = skillData.cNname;
  data['JAname'] = skillData.jAname;
  data['imageurl'] = skillData.imageurl;
  data['DescriptionEN'] = skillData.descriptionEN;
  data['DescriptionCN'] = skillData.descriptionCN;
  data['DescriptionJP'] = skillData.descriptionJP;
  data['stype'] = skillData.stype;
  data['maxlevel'] = skillData.maxlevel;
  data['buffskill'] = skillData.buffskill;
  data['teamskill'] = skillData.teamskill;
  data['levelmultiplier'] =  skillData.levelmultiplier;
  data['referencelevel'] =  skillData.referencelevel;
  data['tags'] =  skillData.tags;
  data['effect'] =  skillData.effect.map((v) => v.toJson()).toList();
}