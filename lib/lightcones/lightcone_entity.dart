import 'package:hsrwikiproject/generated/json/base/json_field.dart';
import 'package:hsrwikiproject/generated/json/lightcone_entity.g.dart';
import 'dart:convert';

import '../calculator/skill_data.dart';
import '../utils/base_entity.dart';

@JsonSerializable()
class LightconeEntity extends BaseEntity {
	late String imageurl = '';
	late String wtype = '';
	late String rarity = '';
	late String imagelargeurl = '';
	late List<LightconeLeveldata> leveldata = [];
	late List<LightconeSkilldata> skilldata = [];
	late String infourl = '';

	LightconeEntity();

	factory LightconeEntity.fromJson(Map<String, dynamic> json) => $LightconeEntityFromJson(json);

	Map<String, dynamic> toJson() => $LightconeEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class LightconeLeveldata {
	late String level = '';
	late double hp = 0;
	late double atk = 0;
	late double def = 0;

	LightconeLeveldata();

	factory LightconeLeveldata.fromJson(Map<String, dynamic> json) => $LightconeLeveldataFromJson(json);

	Map<String, dynamic> toJson() => $LightconeLeveldataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class LightconeSkilldata extends SkillData {

	LightconeSkilldata();

	factory LightconeSkilldata.fromJson(Map<String, dynamic> json) => $LightconeSkilldataFromJson(json);

	Map<String, dynamic> toJson() => $LightconeSkilldataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}