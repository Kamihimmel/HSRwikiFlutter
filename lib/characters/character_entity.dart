import 'package:hsrwikiproject/generated/json/base/json_field.dart';
import 'package:hsrwikiproject/generated/json/character_entity.g.dart';
import 'dart:convert';

import '../calculator/effect_entity.dart';

@JsonSerializable()
class CharacterEntity {
	late String id = '';
	@JSONField(name: "ENname")
	late String eNname = '';
	@JSONField(name: "CNname")
	late String cNname = '';
	@JSONField(name: "JAname")
	late String jAname = '';
	late String imageurl = '';
	late String imageurlalter = '';
	late String imagelargeurl = '';
	late String imagelargeurlalter = '';
	late String etype = '';
	late String wtype = '';
	late String rarity = '';
	late int dtaunt = 0;
	late int dspeed = 0;
	late int maxenergy = 0;
	late List<CharacterLeveldata> leveldata = [];
	late List<CharacterSkilldata> skilldata = [];
	late List<CharacterTracedata> tracedata = [];
	late List<CharacterEidolon> eidolon = [];
	late String infourl = '';

	CharacterEntity();

	factory CharacterEntity.fromJson(Map<String, dynamic> json) => $CharacterEntityFromJson(json);

	Map<String, dynamic> toJson() => $CharacterEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class CharacterLeveldata {
	late String level = '';
	late double hp = 0;
	late double atk = 0;
	late double def = 0;

	CharacterLeveldata();

	factory CharacterLeveldata.fromJson(Map<String, dynamic> json) => $CharacterLeveldataFromJson(json);

	Map<String, dynamic> toJson() => $CharacterLeveldataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class CharacterSkilldata {
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
	late int weaknessbreak = 0;
	late int energyregen = 0;
	late List<Map<String, dynamic>> levelmultiplier = [];
	late List<String> tags = [];
	late List<EffectEntity> effect = [];
	late int energy = 0;

	CharacterSkilldata();

	factory CharacterSkilldata.fromJson(Map<String, dynamic> json) => $CharacterSkilldataFromJson(json);

	Map<String, dynamic> toJson() => $CharacterSkilldataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class CharacterTracedata {
	late String id = '';
	late bool tiny = false;
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
	late String imageurl = '';
	late String stype = '';
	late bool buffskill = false;
	late bool teamskill = false;
	late List<String> tags = [];
	late List<EffectEntity> effect = [];
	late String ttype = '';

	CharacterTracedata();

	factory CharacterTracedata.fromJson(Map<String, dynamic> json) => $CharacterTracedataFromJson(json);

	Map<String, dynamic> toJson() => $CharacterTracedataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class CharacterEidolon {
	late String id = '';
	late int eidolonnum = 0;
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
	late bool buffskill = false;
	late bool teamskill = false;
	late List<String> tags = [];
	late List<EffectEntity> effect = [];

	CharacterEidolon();

	factory CharacterEidolon.fromJson(Map<String, dynamic> json) => $CharacterEidolonFromJson(json);

	Map<String, dynamic> toJson() => $CharacterEidolonToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}