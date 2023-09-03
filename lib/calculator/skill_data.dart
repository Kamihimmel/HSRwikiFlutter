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
  @JSONField(name: "DescriptionEN")
  late String descriptionEN = '';
  @JSONField(name: "DescriptionCN")
  late String descriptionCN = '';
  @JSONField(name: "DescriptionJP")
  late String descriptionJP = '';
  late int maxlevel = 0;
  late bool buffskill = false;
  late bool teamskill = false;
  late List<Map<String, dynamic>> levelmultiplier = [];
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