import 'package:hsrwikiproject/generated/json/base/json_field.dart';
import 'package:hsrwikiproject/generated/json/relic_entity.g.dart';
import 'dart:convert';

import '../calculator/skill_data.dart';

@JsonSerializable()
class RelicEntity {
	late String id = '';
	@JSONField(name: "ENname")
	late String eNname = '';
	@JSONField(name: "CNname")
	late String cNname = '';
	@JSONField(name: "JAname")
	late String jAname = '';
	late String imageurl = '';
	@JSONField(name: "set")
	late String xSet = '';
	late String head = '';
	late String hands = '';
	late String body = '';
	late String feet = '';
	late String sphere = '';
	late String rope = '';
	late List<RelicSkilldata> skilldata = [];
	late String infourl = '';

	RelicEntity();

	factory RelicEntity.fromJson(Map<String, dynamic> json) => $RelicEntityFromJson(json);

	Map<String, dynamic> toJson() => $RelicEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class RelicSkilldata extends SkillData {

	RelicSkilldata();

	factory RelicSkilldata.fromJson(Map<String, dynamic> json) => $RelicSkilldataFromJson(json);

	Map<String, dynamic> toJson() => $RelicSkilldataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}