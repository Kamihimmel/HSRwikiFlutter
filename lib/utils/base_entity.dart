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