import 'package:hsrwikiproject/generated/json/base/json_field.dart';
import 'package:hsrwikiproject/generated/json/enemy_entity.g.dart';
import 'dart:convert';
export 'package:hsrwikiproject/generated/json/enemy_entity.g.dart';

@JsonSerializable()
class EnemyEntity {
	late String id = '';
	@JSONField(name: "ENname")
	late String eNname = '';
	@JSONField(name: "CNname")
	late String cNname = '';
	@JSONField(name: "JAname")
	late String jAname = '';
	late String category = '';
	late String imageurl = '';
	late String imagelargeurl = '';
	late String etype = '';
	late List<String> weakness = [];
	late Map<String, dynamic> resistence = {};

	EnemyEntity();

	factory EnemyEntity.fromJson(Map<String, dynamic> json) => $EnemyEntityFromJson(json);

	Map<String, dynamic> toJson() => $EnemyEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}
