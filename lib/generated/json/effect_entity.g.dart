import 'package:hsrwikiproject/generated/json/base/json_convert_content.dart';
import 'package:hsrwikiproject/calculator/effect_entity.dart';

EffectEntity $EffectEntityFromJson(Map<String, dynamic> json) {
	final EffectEntity effectEntity = EffectEntity();
	final String? type = jsonConvert.convert<String>(json['type']);
	if (type != null) {
		effectEntity.type = type;
	}
	final String? addtarget = jsonConvert.convert<String>(json['addtarget']);
	if (addtarget != null) {
		effectEntity.addtarget = addtarget;
	}
	final String? referencetarget = jsonConvert.convert<String>(json['referencetarget']);
	if (referencetarget != null) {
		effectEntity.referencetarget = referencetarget;
	}
	final String? referencetargetEN = jsonConvert.convert<String>(json['referencetargetEN']);
	if (referencetargetEN != null) {
		effectEntity.referencetargetEN = referencetargetEN;
	}
	final String? referencetargetCN = jsonConvert.convert<String>(json['referencetargetCN']);
	if (referencetargetCN != null) {
		effectEntity.referencetargetCN = referencetargetCN;
	}
	final String? referencetargetJP = jsonConvert.convert<String>(json['referencetargetJP']);
	if (referencetargetJP != null) {
		effectEntity.referencetargetJP = referencetargetJP;
	}
	final String? multipliertarget = jsonConvert.convert<String>(json['multipliertarget']);
	if (multipliertarget != null) {
		effectEntity.multipliertarget = multipliertarget;
	}
	final double? multiplier = jsonConvert.convert<double>(json['multiplier']);
	if (multiplier != null) {
		effectEntity.multiplier = multiplier;
	}
	final int? maxStack = jsonConvert.convert<int>(json['maxstack']);
	if (maxStack != null) {
		effectEntity.maxStack = maxStack;
	}
	final String? group = jsonConvert.convert<String>(json['group']);
	if (group != null) {
		effectEntity.group = group;
	}
	final List<String>? tag = jsonConvert.convertListNotNull<String>(json['tag']);
	if (tag != null) {
		effectEntity.tag = tag;
	}
	return effectEntity;
}

Map<String, dynamic> $EffectEntityToJson(EffectEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['type'] = entity.type;
	data['addtarget'] = entity.addtarget;
	data['referencetarget'] = entity.referencetarget;
	data['referencetargetEN'] = entity.referencetargetEN;
	data['referencetargetCN'] = entity.referencetargetCN;
	data['referencetargetJP'] = entity.referencetargetJP;
	data['multipliertarget'] = entity.multipliertarget;
	data['multiplier'] = entity.multiplier;
	data['maxstack'] = entity.maxStack;
	data['group'] = entity.group;
	data['tag'] =  entity.tag;
	return data;
}