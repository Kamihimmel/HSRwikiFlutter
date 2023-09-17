import 'package:hsrwikiproject/generated/json/base/json_convert_content.dart';
import 'package:hsrwikiproject/lightcones/lightcone_entity.dart';

import '../../calculator/skill_data.dart';
import '../../utils/base_entity.dart';


LightconeEntity $LightconeEntityFromJson(Map<String, dynamic> json) {
	final LightconeEntity lightconeEntity = LightconeEntity();
	$BaseEntityFromJson(json, lightconeEntity);
	final String? imageurl = jsonConvert.convert<String>(json['imageurl']);
	if (imageurl != null) {
		lightconeEntity.imageurl = imageurl;
	}
	final String? wtype = jsonConvert.convert<String>(json['wtype']);
	if (wtype != null) {
		lightconeEntity.wtype = wtype;
	}
	final String? rarity = jsonConvert.convert<String>(json['rarity']);
	if (rarity != null) {
		lightconeEntity.rarity = rarity;
	}
	final String? imagelargeurl = jsonConvert.convert<String>(json['imagelargeurl']);
	if (imagelargeurl != null) {
		lightconeEntity.imagelargeurl = imagelargeurl;
	}
	final List<LightconeLeveldata>? leveldata = jsonConvert.convertListNotNull<LightconeLeveldata>(json['leveldata']);
	if (leveldata != null) {
		lightconeEntity.leveldata = leveldata;
	}
	final List<LightconeSkilldata>? skilldata = jsonConvert.convertListNotNull<LightconeSkilldata>(json['skilldata']);
	if (skilldata != null) {
		lightconeEntity.skilldata = skilldata;
	}
	final String? infourl = jsonConvert.convert<String>(json['infourl']);
	if (infourl != null) {
		lightconeEntity.infourl = infourl;
	}
	return lightconeEntity;
}

Map<String, dynamic> $LightconeEntityToJson(LightconeEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	$BaseEntityToJson(entity, data);
	data['imageurl'] = entity.imageurl;
	data['wtype'] = entity.wtype;
	data['rarity'] = entity.rarity;
	data['imagelargeurl'] = entity.imagelargeurl;
	data['leveldata'] =  entity.leveldata.map((v) => v.toJson()).toList();
	data['skilldata'] =  entity.skilldata.map((v) => v.toJson()).toList();
	data['infourl'] = entity.infourl;
	return data;
}

LightconeLeveldata $LightconeLeveldataFromJson(Map<String, dynamic> json) {
	final LightconeLeveldata lightconeLeveldata = LightconeLeveldata();
	final String? level = jsonConvert.convert<String>(json['level']);
	if (level != null) {
		lightconeLeveldata.level = level;
	}
	final double? hp = jsonConvert.convert<double>(json['hp']);
	if (hp != null) {
		lightconeLeveldata.hp = hp;
	}
	final double? atk = jsonConvert.convert<double>(json['atk']);
	if (atk != null) {
		lightconeLeveldata.atk = atk;
	}
	final double? def = jsonConvert.convert<double>(json['def']);
	if (def != null) {
		lightconeLeveldata.def = def;
	}
	return lightconeLeveldata;
}

Map<String, dynamic> $LightconeLeveldataToJson(LightconeLeveldata entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['level'] = entity.level;
	data['hp'] = entity.hp;
	data['atk'] = entity.atk;
	data['def'] = entity.def;
	return data;
}

LightconeSkilldata $LightconeSkilldataFromJson(Map<String, dynamic> json) {
	final LightconeSkilldata lightconeSkilldata = LightconeSkilldata();
	$SkillDataFromJson(json, lightconeSkilldata);
	return lightconeSkilldata;
}

Map<String, dynamic> $LightconeSkilldataToJson(LightconeSkilldata entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	$SkillDataToJson(entity, data);
	return data;
}