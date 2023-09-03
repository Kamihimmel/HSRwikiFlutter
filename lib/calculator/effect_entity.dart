import 'package:hsrwikiproject/generated/json/base/json_field.dart';
import 'package:hsrwikiproject/generated/json/effect_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class EffectEntity {
	late String iid = '';
	late String type = '';
	late String addtarget = '';
	late String referencetarget = '';
	late String referencetargetEN = '';
	late String referencetargetCN = '';
	late String referencetargetJP = '';
	late String multipliertarget = '';
	late double multiplier = 0;
	late String multipliervalue = '';
	late String multipliermax = '';
	late int maxStack = 1;
	late String group = '';
	late List<String> tag = [];

	EffectEntity();

	factory EffectEntity.fromJson(Map<String, dynamic> json) => $EffectEntityFromJson(json);

	Map<String, dynamic> toJson() => $EffectEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}