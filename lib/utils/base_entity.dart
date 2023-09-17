import '../generated/json/base/json_convert_content.dart';
import '../generated/json/base/json_field.dart';

@JsonSerializable()
class BaseEntity {
  late String id = '';
  @JSONField(name: "ENname")
  late String eNname = '';
  @JSONField(name: "CNname")
  late String cNname = '';
  @JSONField(name: "JAname")
  late String jAname = '';

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
}

void $BaseEntityFromJson(Map<String, dynamic> json, BaseEntity baseEntity) {
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    baseEntity.id = id;
  }
  final String? eNname = jsonConvert.convert<String>(json['ENname']);
  if (eNname != null) {
    baseEntity.eNname = eNname;
  }
  final String? cNname = jsonConvert.convert<String>(json['CNname']);
  if (cNname != null) {
    baseEntity.cNname = cNname;
  }
  final String? jAname = jsonConvert.convert<String>(json['JAname']);
  if (jAname != null) {
    baseEntity.jAname = jAname;
  }
}

void $BaseEntityToJson(BaseEntity baseEntity, Map<String, dynamic> data) {
  data['id'] = baseEntity.id;
  data['ENname'] = baseEntity.eNname;
  data['CNname'] = baseEntity.cNname;
  data['JAname'] = baseEntity.jAname;
}
