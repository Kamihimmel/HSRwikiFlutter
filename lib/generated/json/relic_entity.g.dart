import 'package:hsrwikiproject/generated/json/base/json_convert_content.dart';
import 'package:hsrwikiproject/relics/relic_entity.dart';

import '../../calculator/skill_data.dart';
import '../../utils/base_entity.dart';

RelicEntity $RelicEntityFromJson(Map<String, dynamic> json) {
	final RelicEntity relicEntity = RelicEntity();
	$BaseEntityFromJson(json, relicEntity);
	final String? imageurl = jsonConvert.convert<String>(json['imageurl']);
	if (imageurl != null) {
		relicEntity.imageurl = imageurl;
	}
	final String? xSet = jsonConvert.convert<String>(json['set']);
	if (xSet != null) {
		relicEntity.xSet = xSet;
	}
	final String? head = jsonConvert.convert<String>(json['head']);
	if (head != null) {
		relicEntity.head = head;
	}
	final String? hands = jsonConvert.convert<String>(json['hands']);
	if (hands != null) {
		relicEntity.hands = hands;
	}
	final String? body = jsonConvert.convert<String>(json['body']);
	if (body != null) {
		relicEntity.body = body;
	}
	final String? feet = jsonConvert.convert<String>(json['feet']);
	if (feet != null) {
		relicEntity.feet = feet;
	}
	final String? sphere = jsonConvert.convert<String>(json['sphere']);
	if (sphere != null) {
		relicEntity.sphere = sphere;
	}
	final String? rope = jsonConvert.convert<String>(json['rope']);
	if (rope != null) {
		relicEntity.rope = rope;
	}
	final List<RelicSkilldata>? skilldata = jsonConvert.convertListNotNull<RelicSkilldata>(json['skilldata']);
	if (skilldata != null) {
		relicEntity.skilldata = skilldata;
	}
	final String? infourl = jsonConvert.convert<String>(json['infourl']);
	if (infourl != null) {
		relicEntity.infourl = infourl;
	}
	return relicEntity;
}

Map<String, dynamic> $RelicEntityToJson(RelicEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	$BaseEntityToJson(entity, data);
	data['imageurl'] = entity.imageurl;
	data['set'] = entity.xSet;
	data['head'] = entity.head;
	data['hands'] = entity.hands;
	data['body'] = entity.body;
	data['feet'] = entity.feet;
	data['sphere'] = entity.sphere;
	data['rope'] = entity.rope;
	data['skilldata'] =  entity.skilldata.map((v) => v.toJson()).toList();
	data['infourl'] = entity.infourl;
	return data;
}

RelicSkilldata $RelicSkilldataFromJson(Map<String, dynamic> json) {
	final RelicSkilldata relicSkilldata = RelicSkilldata();
	$SkillDataFromJson(json, relicSkilldata);
	return relicSkilldata;
}

Map<String, dynamic> $RelicSkilldataToJson(RelicSkilldata entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	$SkillDataToJson(entity, data);
	return data;
}