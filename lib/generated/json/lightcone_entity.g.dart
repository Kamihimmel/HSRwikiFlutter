import 'package:hsrwikiproject/generated/json/base/json_convert_content.dart';
import 'package:hsrwikiproject/lightcones/lightcone_entity.dart';
import 'package:hsrwikiproject/calculator/effect_entity.dart';


LightconeEntity $LightconeEntityFromJson(Map<String, dynamic> json) {
	final LightconeEntity lightconeEntity = LightconeEntity();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		lightconeEntity.id = id;
	}
	final String? eNname = jsonConvert.convert<String>(json['ENname']);
	if (eNname != null) {
		lightconeEntity.eNname = eNname;
	}
	final String? cNname = jsonConvert.convert<String>(json['CNname']);
	if (cNname != null) {
		lightconeEntity.cNname = cNname;
	}
	final String? jAname = jsonConvert.convert<String>(json['JAname']);
	if (jAname != null) {
		lightconeEntity.jAname = jAname;
	}
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
	data['id'] = entity.id;
	data['ENname'] = entity.eNname;
	data['CNname'] = entity.cNname;
	data['JAname'] = entity.jAname;
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
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		lightconeSkilldata.eNname = id;
	}
	final String? eNname = jsonConvert.convert<String>(json['ENname']);
	if (eNname != null) {
		lightconeSkilldata.eNname = eNname;
	}
	final String? cNname = jsonConvert.convert<String>(json['CNname']);
	if (cNname != null) {
		lightconeSkilldata.cNname = cNname;
	}
	final String? jAname = jsonConvert.convert<String>(json['JAname']);
	if (jAname != null) {
		lightconeSkilldata.jAname = jAname;
	}
	final String? descriptionEN = jsonConvert.convert<String>(json['DescriptionEN']);
	if (descriptionEN != null) {
		lightconeSkilldata.descriptionEN = descriptionEN;
	}
	final String? descriptionCN = jsonConvert.convert<String>(json['DescriptionCN']);
	if (descriptionCN != null) {
		lightconeSkilldata.descriptionCN = descriptionCN;
	}
	final String? descriptionJP = jsonConvert.convert<String>(json['DescriptionJP']);
	if (descriptionJP != null) {
		lightconeSkilldata.descriptionJP = descriptionJP;
	}
	final int? maxlevel = jsonConvert.convert<int>(json['maxlevel']);
	if (maxlevel != null) {
		lightconeSkilldata.maxlevel = maxlevel;
	}
	final bool? buffskill = jsonConvert.convert<bool>(json['buffskill']);
	if (buffskill != null) {
		lightconeSkilldata.buffskill = buffskill;
	}
	final bool? teamskill = jsonConvert.convert<bool>(json['teamskill']);
	if (teamskill != null) {
		lightconeSkilldata.teamskill = teamskill;
	}
	final List<Map<String, dynamic>>? levelmultiplier = jsonConvert.convertListNotNull<Map<String, dynamic>>(json['levelmultiplier']);
	if (levelmultiplier != null) {
		lightconeSkilldata.levelmultiplier = levelmultiplier;
	}
	final List<String>? tags = jsonConvert.convertListNotNull<String>(json['tags']);
	if (tags != null) {
		lightconeSkilldata.tags = tags;
	}
	final List<EffectEntity>? effect = jsonConvert.convertListNotNull<EffectEntity>(json['effect']);
	if (effect != null) {
		lightconeSkilldata.effect = effect;
	}
	return lightconeSkilldata;
}

Map<String, dynamic> $LightconeSkilldataToJson(LightconeSkilldata entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['ENname'] = entity.eNname;
	data['CNname'] = entity.cNname;
	data['JAname'] = entity.jAname;
	data['DescriptionEN'] = entity.descriptionEN;
	data['DescriptionCN'] = entity.descriptionCN;
	data['DescriptionJP'] = entity.descriptionJP;
	data['maxlevel'] = entity.maxlevel;
	data['buffskill'] = entity.buffskill;
	data['teamskill'] = entity.teamskill;
	data['levelmultiplier'] =  entity.levelmultiplier;
	data['tags'] =  entity.tags;
	data['effect'] =  entity.effect.map((v) => v.toJson()).toList();
	return data;
}