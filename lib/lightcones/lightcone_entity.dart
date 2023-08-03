import 'package:hsrwikiproject/generated/json/base/json_field.dart';
import 'package:hsrwikiproject/generated/json/lightcone_entity.g.dart';
import 'dart:convert';

import 'package:hsrwikiproject/calculator/effect_entity.dart';

@JsonSerializable()
class LightconeEntity {
	late String id = '';
	@JSONField(name: "ENname")
	late String eNname = '';
	@JSONField(name: "CNname")
	late String cNname = '';
	@JSONField(name: "JAname")
	late String jAname = '';
	late String imageurl = '';
	late String wtype = '';
	late String rarity = '';
	late String imagelargeurl = '';
	late List<LightconeLeveldata> leveldata;
	late List<LightconeSkilldata> skilldata;
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
	late int hp = 0;
	late int atk = 0;
	late int def = 0;

	LightconeLeveldata();

	factory LightconeLeveldata.fromJson(Map<String, dynamic> json) => $LightconeLeveldataFromJson(json);

	Map<String, dynamic> toJson() => $LightconeLeveldataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class LightconeSkilldata {
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

	LightconeSkilldata();

	factory LightconeSkilldata.fromJson(Map<String, dynamic> json) => $LightconeSkilldataFromJson(json);

	Map<String, dynamic> toJson() => $LightconeSkilldataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}