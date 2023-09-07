import 'package:hsrwikiproject/generated/json/base/json_field.dart';
import 'package:hsrwikiproject/generated/json/enemy_entity.g.dart';
import 'dart:convert';

import '../utils/base_entity.dart';
export 'package:hsrwikiproject/generated/json/enemy_entity.g.dart';

@JsonSerializable()
class EnemyEntity extends BaseEntity {
	late String category = '';
	late String imageurl = '';
	late String imagelargeurl = '';
	late String etype = '';
	late List<String> weakness = [];
	late Map<String, dynamic> resistence = {};
	late int effectdef = 0;
	late Map<String, dynamic> effectres = {};

	EnemyEntity();

	factory EnemyEntity.fromJson(Map<String, dynamic> json) => $EnemyEntityFromJson(json);

	Map<String, dynamic> toJson() => $EnemyEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
