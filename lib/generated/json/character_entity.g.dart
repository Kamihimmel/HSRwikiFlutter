import 'package:hsrwikiproject/generated/json/base/json_convert_content.dart';
import 'package:hsrwikiproject/characters/character_entity.dart';
import '../../calculator/effect_entity.dart';


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
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		characterSkilldata.id = id;
	}
	final String? eNname = jsonConvert.convert<String>(json['ENname']);
	if (eNname != null) {
		characterSkilldata.eNname = eNname;
	}
	final String? cNname = jsonConvert.convert<String>(json['CNname']);
	if (cNname != null) {
		characterSkilldata.cNname = cNname;
	}
	final String? jAname = jsonConvert.convert<String>(json['JAname']);
	if (jAname != null) {
		characterSkilldata.jAname = jAname;
	}
	final String? imageurl = jsonConvert.convert<String>(json['imageurl']);
	if (imageurl != null) {
		characterSkilldata.imageurl = imageurl;
	}
	final String? descriptionEN = jsonConvert.convert<String>(json['DescriptionEN']);
	if (descriptionEN != null) {
		characterSkilldata.descriptionEN = descriptionEN;
	}
	final String? descriptionCN = jsonConvert.convert<String>(json['DescriptionCN']);
	if (descriptionCN != null) {
		characterSkilldata.descriptionCN = descriptionCN;
	}
	final String? descriptionJP = jsonConvert.convert<String>(json['DescriptionJP']);
	if (descriptionJP != null) {
		characterSkilldata.descriptionJP = descriptionJP;
	}
	final String? stype = jsonConvert.convert<String>(json['stype']);
	if (stype != null) {
		characterSkilldata.stype = stype;
	}
	final int? maxlevel = jsonConvert.convert<int>(json['maxlevel']);
	if (maxlevel != null) {
		characterSkilldata.maxlevel = maxlevel;
	}
	final bool? buffskill = jsonConvert.convert<bool>(json['buffskill']);
	if (buffskill != null) {
		characterSkilldata.buffskill = buffskill;
	}
	final bool? teamskill = jsonConvert.convert<bool>(json['teamskill']);
	if (teamskill != null) {
		characterSkilldata.teamskill = teamskill;
	}
	final int? weaknessbreak = jsonConvert.convert<int>(json['weaknessbreak']);
	if (weaknessbreak != null) {
		characterSkilldata.weaknessbreak = weaknessbreak;
	}
	final int? energyregen = jsonConvert.convert<int>(json['energyregen']);
	if (energyregen != null) {
		characterSkilldata.energyregen = energyregen;
	}
	final List<Map<String, dynamic>>? levelmultiplier = jsonConvert.convertListNotNull<Map<String, dynamic>>(json['levelmultiplier']);
	if (levelmultiplier != null) {
		characterSkilldata.levelmultiplier = levelmultiplier;
	}
	final List<String>? tags = jsonConvert.convertListNotNull<String>(json['tags']);
	if (tags != null) {
		characterSkilldata.tags = tags;
	}
	final List<EffectEntity>? effect = jsonConvert.convertListNotNull<EffectEntity>(json['effect']);
	if (effect != null) {
		characterSkilldata.effect = effect;
	}
	final int? energy = jsonConvert.convert<int>(json['energy']);
	if (energy != null) {
		characterSkilldata.energy = energy;
	}
	return characterSkilldata;
}

Map<String, dynamic> $CharacterSkilldataToJson(CharacterSkilldata entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['ENname'] = entity.eNname;
	data['CNname'] = entity.cNname;
	data['JAname'] = entity.jAname;
	data['imageurl'] = entity.imageurl;
	data['DescriptionEN'] = entity.descriptionEN;
	data['DescriptionCN'] = entity.descriptionCN;
	data['DescriptionJP'] = entity.descriptionJP;
	data['stype'] = entity.stype;
	data['maxlevel'] = entity.maxlevel;
	data['buffskill'] = entity.buffskill;
	data['teamskill'] = entity.teamskill;
	data['weaknessbreak'] = entity.weaknessbreak;
	data['energyregen'] = entity.energyregen;
	data['levelmultiplier'] =  entity.levelmultiplier;
	data['tags'] =  entity.tags;
	data['effect'] =  entity.effect.map((v) => v.toJson()).toList();
	data['energy'] = entity.energy;
	return data;
}

CharacterTracedata $CharacterTracedataFromJson(Map<String, dynamic> json) {
	final CharacterTracedata characterTracedata = CharacterTracedata();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		characterTracedata.id = id;
	}
	final bool? tiny = jsonConvert.convert<bool>(json['tiny']);
	if (tiny != null) {
		characterTracedata.tiny = tiny;
	}
	final String? eNname = jsonConvert.convert<String>(json['ENname']);
	if (eNname != null) {
		characterTracedata.eNname = eNname;
	}
	final String? cNname = jsonConvert.convert<String>(json['CNname']);
	if (cNname != null) {
		characterTracedata.cNname = cNname;
	}
	final String? jAname = jsonConvert.convert<String>(json['JAname']);
	if (jAname != null) {
		characterTracedata.jAname = jAname;
	}
	final String? descriptionEN = jsonConvert.convert<String>(json['DescriptionEN']);
	if (descriptionEN != null) {
		characterTracedata.descriptionEN = descriptionEN;
	}
	final String? descriptionCN = jsonConvert.convert<String>(json['DescriptionCN']);
	if (descriptionCN != null) {
		characterTracedata.descriptionCN = descriptionCN;
	}
	final String? descriptionJP = jsonConvert.convert<String>(json['DescriptionJP']);
	if (descriptionJP != null) {
		characterTracedata.descriptionJP = descriptionJP;
	}
	final String? imageurl = jsonConvert.convert<String>(json['imageurl']);
	if (imageurl != null) {
		characterTracedata.imageurl = imageurl;
	}
	final String? stype = jsonConvert.convert<String>(json['stype']);
	if (stype != null) {
		characterTracedata.stype = stype;
	}
	final bool? buffskill = jsonConvert.convert<bool>(json['buffskill']);
	if (buffskill != null) {
		characterTracedata.buffskill = buffskill;
	}
	final bool? teamskill = jsonConvert.convert<bool>(json['teamskill']);
	if (teamskill != null) {
		characterTracedata.teamskill = teamskill;
	}
	final List<String>? tags = jsonConvert.convertListNotNull<String>(json['tags']);
	if (tags != null) {
		characterTracedata.tags = tags;
	}
	final List<EffectEntity>? effect = jsonConvert.convertListNotNull<EffectEntity>(json['effect']);
	if (effect != null) {
		characterTracedata.effect = effect;
	}
	final String? ttype = jsonConvert.convert<String>(json['ttype']);
	if (ttype != null) {
		characterTracedata.ttype = ttype;
	}
	return characterTracedata;
}

Map<String, dynamic> $CharacterTracedataToJson(CharacterTracedata entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['tiny'] = entity.tiny;
	data['ENname'] = entity.eNname;
	data['CNname'] = entity.cNname;
	data['JAname'] = entity.jAname;
	data['DescriptionEN'] = entity.descriptionEN;
	data['DescriptionCN'] = entity.descriptionCN;
	data['DescriptionJP'] = entity.descriptionJP;
	data['imageurl'] = entity.imageurl;
	data['stype'] = entity.stype;
	data['buffskill'] = entity.buffskill;
	data['teamskill'] = entity.teamskill;
	data['tags'] =  entity.tags;
	data['effect'] =  entity.effect.map((v) => v.toJson()).toList();
	data['ttype'] = entity.ttype;
	return data;
}

CharacterEidolon $CharacterEidolonFromJson(Map<String, dynamic> json) {
	final CharacterEidolon characterEidolon = CharacterEidolon();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		characterEidolon.id = id;
	}
	final int? eidolonnum = jsonConvert.convert<int>(json['eidolonnum']);
	if (eidolonnum != null) {
		characterEidolon.eidolonnum = eidolonnum;
	}
	final String? eNname = jsonConvert.convert<String>(json['ENname']);
	if (eNname != null) {
		characterEidolon.eNname = eNname;
	}
	final String? cNname = jsonConvert.convert<String>(json['CNname']);
	if (cNname != null) {
		characterEidolon.cNname = cNname;
	}
	final String? jAname = jsonConvert.convert<String>(json['JAname']);
	if (jAname != null) {
		characterEidolon.jAname = jAname;
	}
	final String? imageurl = jsonConvert.convert<String>(json['imageurl']);
	if (imageurl != null) {
		characterEidolon.imageurl = imageurl;
	}
	final String? descriptionEN = jsonConvert.convert<String>(json['DescriptionEN']);
	if (descriptionEN != null) {
		characterEidolon.descriptionEN = descriptionEN;
	}
	final String? descriptionCN = jsonConvert.convert<String>(json['DescriptionCN']);
	if (descriptionCN != null) {
		characterEidolon.descriptionCN = descriptionCN;
	}
	final String? descriptionJP = jsonConvert.convert<String>(json['DescriptionJP']);
	if (descriptionJP != null) {
		characterEidolon.descriptionJP = descriptionJP;
	}
	final String? stype = jsonConvert.convert<String>(json['stype']);
	if (stype != null) {
		characterEidolon.stype = stype;
	}
	final bool? buffskill = jsonConvert.convert<bool>(json['buffskill']);
	if (buffskill != null) {
		characterEidolon.buffskill = buffskill;
	}
	final bool? teamskill = jsonConvert.convert<bool>(json['teamskill']);
	if (teamskill != null) {
		characterEidolon.teamskill = teamskill;
	}
	final List<String>? tags = jsonConvert.convertListNotNull<String>(json['tags']);
	if (tags != null) {
		characterEidolon.tags = tags;
	}
	final List<EffectEntity>? effect = jsonConvert.convertListNotNull<EffectEntity>(json['effect']);
	if (effect != null) {
		characterEidolon.effect = effect;
	}
	return characterEidolon;
}

Map<String, dynamic> $CharacterEidolonToJson(CharacterEidolon entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['eidolonnum'] = entity.eidolonnum;
	data['ENname'] = entity.eNname;
	data['CNname'] = entity.cNname;
	data['JAname'] = entity.jAname;
	data['imageurl'] = entity.imageurl;
	data['DescriptionEN'] = entity.descriptionEN;
	data['DescriptionCN'] = entity.descriptionCN;
	data['DescriptionJP'] = entity.descriptionJP;
	data['stype'] = entity.stype;
	data['buffskill'] = entity.buffskill;
	data['teamskill'] = entity.teamskill;
	data['tags'] =  entity.tags;
	data['effect'] =  entity.effect.map((v) => v.toJson()).toList();
	return data;
}