import 'package:hsrwikiproject/generated/json/base/json_convert_content.dart';
import 'package:hsrwikiproject/characters/character_entity.dart';
import '../../calculator/skill_data.dart';


CharacterEntity $CharacterEntityFromJson(Map<String, dynamic> json) {
	final CharacterEntity characterEntity = CharacterEntity();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		characterEntity.id = id;
	}
	final String? eNname = jsonConvert.convert<String>(json['ENname']);
	if (eNname != null) {
		characterEntity.eNname = eNname;
	}
	final String? cNname = jsonConvert.convert<String>(json['CNname']);
	if (cNname != null) {
		characterEntity.cNname = cNname;
	}
	final String? jAname = jsonConvert.convert<String>(json['JAname']);
	if (jAname != null) {
		characterEntity.jAname = jAname;
	}
	final String? imageurl = jsonConvert.convert<String>(json['imageurl']);
	if (imageurl != null) {
		characterEntity.imageurl = imageurl;
	}
	final String? imageurlalter = jsonConvert.convert<String>(json['imageurlalter']);
	if (imageurlalter != null) {
		characterEntity.imageurlalter = imageurlalter;
	}
	final String? imagelargeurl = jsonConvert.convert<String>(json['imagelargeurl']);
	if (imagelargeurl != null) {
		characterEntity.imagelargeurl = imagelargeurl;
	}
	final String? imagelargeurlalter = jsonConvert.convert<String>(json['imagelargeurlalter']);
	if (imagelargeurlalter != null) {
		characterEntity.imagelargeurlalter = imagelargeurlalter;
	}
	final String? etype = jsonConvert.convert<String>(json['etype']);
	if (etype != null) {
		characterEntity.etype = etype;
	}
	final String? wtype = jsonConvert.convert<String>(json['wtype']);
	if (wtype != null) {
		characterEntity.wtype = wtype;
	}
	final String? rarity = jsonConvert.convert<String>(json['rarity']);
	if (rarity != null) {
		characterEntity.rarity = rarity;
	}
	final int? dtaunt = jsonConvert.convert<int>(json['dtaunt']);
	if (dtaunt != null) {
		characterEntity.dtaunt = dtaunt;
	}
	final int? dspeed = jsonConvert.convert<int>(json['dspeed']);
	if (dspeed != null) {
		characterEntity.dspeed = dspeed;
	}
	final int? maxenergy = jsonConvert.convert<int>(json['maxenergy']);
	if (maxenergy != null) {
		characterEntity.maxenergy = maxenergy;
	}
	final List<CharacterLeveldata>? leveldata = jsonConvert.convertListNotNull<CharacterLeveldata>(json['leveldata']);
	if (leveldata != null) {
		characterEntity.leveldata = leveldata;
	}
	final List<CharacterSkilldata>? skilldata = jsonConvert.convertListNotNull<CharacterSkilldata>(json['skilldata']);
	if (skilldata != null) {
		characterEntity.skilldata = skilldata;
	}
	final List<CharacterTracedata>? tracedata = jsonConvert.convertListNotNull<CharacterTracedata>(json['tracedata']);
	if (tracedata != null) {
		characterEntity.tracedata = tracedata;
	}
	final List<CharacterEidolon>? eidolon = jsonConvert.convertListNotNull<CharacterEidolon>(json['eidolon']);
	if (eidolon != null) {
		characterEntity.eidolon = eidolon;
	}
	final String? infourl = jsonConvert.convert<String>(json['infourl']);
	if (infourl != null) {
		characterEntity.infourl = infourl;
	}
	return characterEntity;
}

Map<String, dynamic> $CharacterEntityToJson(CharacterEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['ENname'] = entity.eNname;
	data['CNname'] = entity.cNname;
	data['JAname'] = entity.jAname;
	data['imageurl'] = entity.imageurl;
	data['imageurlalter'] = entity.imageurlalter;
	data['imagelargeurl'] = entity.imagelargeurl;
	data['imagelargeurlalter'] = entity.imagelargeurlalter;
	data['etype'] = entity.etype;
	data['wtype'] = entity.wtype;
	data['rarity'] = entity.rarity;
	data['dtaunt'] = entity.dtaunt;
	data['dspeed'] = entity.dspeed;
	data['maxenergy'] = entity.maxenergy;
	data['leveldata'] =  entity.leveldata.map((v) => v.toJson()).toList();
	data['skilldata'] =  entity.skilldata.map((v) => v.toJson()).toList();
	data['tracedata'] =  entity.tracedata.map((v) => v.toJson()).toList();
	data['eidolon'] =  entity.eidolon.map((v) => v.toJson()).toList();
	data['infourl'] = entity.infourl;
	return data;
}

CharacterLeveldata $CharacterLeveldataFromJson(Map<String, dynamic> json) {
	final CharacterLeveldata characterLeveldata = CharacterLeveldata();
	final String? level = jsonConvert.convert<String>(json['level']);
	if (level != null) {
		characterLeveldata.level = level;
	}
	final double? hp = jsonConvert.convert<double>(json['hp']);
	if (hp != null) {
		characterLeveldata.hp = hp;
	}
	final double? atk = jsonConvert.convert<double>(json['atk']);
	if (atk != null) {
		characterLeveldata.atk = atk;
	}
	final double? def = jsonConvert.convert<double>(json['def']);
	if (def != null) {
		characterLeveldata.def = def;
	}
	return characterLeveldata;
}

Map<String, dynamic> $CharacterLeveldataToJson(CharacterLeveldata entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['level'] = entity.level;
	data['hp'] = entity.hp;
	data['atk'] = entity.atk;
	data['def'] = entity.def;
	return data;
}

CharacterSkilldata $CharacterSkilldataFromJson(Map<String, dynamic> json) {
	final CharacterSkilldata characterSkilldata = CharacterSkilldata();
	$SkilldataFromJson(json, characterSkilldata);
	final int? weaknessbreak = jsonConvert.convert<int>(json['weaknessbreak']);
	if (weaknessbreak != null) {
		characterSkilldata.weaknessbreak = weaknessbreak;
	}
	final int? energyregen = jsonConvert.convert<int>(json['energyregen']);
	if (energyregen != null) {
		characterSkilldata.energyregen = energyregen;
	}
	final int? energy = jsonConvert.convert<int>(json['energy']);
	if (energy != null) {
		characterSkilldata.energy = energy;
	}
	return characterSkilldata;
}

Map<String, dynamic> $CharacterSkilldataToJson(CharacterSkilldata entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	$SkillDataToJson(entity, data);
	data['weaknessbreak'] = entity.weaknessbreak;
	data['energyregen'] = entity.energyregen;
	data['energy'] = entity.energy;
	return data;
}

CharacterTracedata $CharacterTracedataFromJson(Map<String, dynamic> json) {
	final CharacterTracedata characterTracedata = CharacterTracedata();
	$SkilldataFromJson(json, characterTracedata);
	final bool? tiny = jsonConvert.convert<bool>(json['tiny']);
	if (tiny != null) {
		characterTracedata.tiny = tiny;
	}
	final String? ttype = jsonConvert.convert<String>(json['ttype']);
	if (ttype != null) {
		characterTracedata.ttype = ttype;
	}
	return characterTracedata;
}

Map<String, dynamic> $CharacterTracedataToJson(CharacterTracedata entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	$SkillDataToJson(entity, data);
	data['tiny'] = entity.tiny;
	data['ttype'] = entity.ttype;
	return data;
}

CharacterEidolon $CharacterEidolonFromJson(Map<String, dynamic> json) {
	final CharacterEidolon characterEidolon = CharacterEidolon();
	$SkilldataFromJson(json, characterEidolon);
	final int? eidolonnum = jsonConvert.convert<int>(json['eidolonnum']);
	if (eidolonnum != null) {
		characterEidolon.eidolonnum = eidolonnum;
	}
	return characterEidolon;
}

Map<String, dynamic> $CharacterEidolonToJson(CharacterEidolon entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	$SkillDataToJson(entity, data);
	data['eidolonnum'] = entity.eidolonnum;
	return data;
}