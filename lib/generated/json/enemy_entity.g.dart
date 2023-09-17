import 'package:hsrwikiproject/generated/json/base/json_convert_content.dart';
import 'package:hsrwikiproject/enemies/enemy_entity.dart';

import '../../utils/base_entity.dart';

EnemyEntity $EnemyEntityFromJson(Map<String, dynamic> json) {
  final EnemyEntity enemyEntity = EnemyEntity();
  $BaseEntityFromJson(json, enemyEntity);
  final String? category = jsonConvert.convert<String>(json['category']);
  if (category != null) {
    enemyEntity.category = category;
  }
  final String? imageurl = jsonConvert.convert<String>(json['imageurl']);
  if (imageurl != null) {
    enemyEntity.imageurl = imageurl;
  }
  final String? imagelargeurl = jsonConvert.convert<String>(json['imagelargeurl']);
  if (imagelargeurl != null) {
    enemyEntity.imagelargeurl = imagelargeurl;
  }
  final String? etype = jsonConvert.convert<String>(json['etype']);
  if (etype != null) {
    enemyEntity.etype = etype;
  }
  final List<String>? weakness = (json['weakness'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (weakness != null) {
    enemyEntity.weakness = weakness;
  }
  final Map<String, dynamic>? resistence = jsonConvert.convert<Map<String, dynamic>>(json['resistence']);
  if (resistence != null) {
    enemyEntity.resistence = resistence;
  }
  final int? effectdef = jsonConvert.convert<int>(json['effectdef']);
  if (effectdef != null) {
    enemyEntity.effectdef = effectdef;
  }
  final Map<String, dynamic>? effectres = jsonConvert.convert<Map<String, dynamic>>(json['effectres']);
  if (effectres != null) {
    enemyEntity.effectres = effectres;
  }
  return enemyEntity;
}

Map<String, dynamic> $EnemyEntityToJson(EnemyEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  $BaseEntityToJson(entity, data);
  data['category'] = entity.category;
  data['imageurl'] = entity.imageurl;
  data['imagelargeurl'] = entity.imagelargeurl;
  data['etype'] = entity.etype;
  data['weakness'] = entity.weakness;
  data['resistence'] = entity.resistence;
  data['effectdef'] = entity.effectdef;
  data['effectres'] = entity.effectres;
  return data;
}

extension EnemyEntityExtension on EnemyEntity {
  EnemyEntity copyWith({
    String? id,
    String? eNname,
    String? cNname,
    String? jAname,
    String? category,
    String? imageurl,
    String? imagelargeurl,
    String? etype,
    List<String>? weakness,
    Map<String, dynamic>? resistence,
    int? effectdef,
    Map<String, dynamic>? effectres,
  }) {
    return EnemyEntity()
      ..id = id ?? this.id
      ..eNname = eNname ?? this.eNname
      ..cNname = cNname ?? this.cNname
      ..jAname = jAname ?? this.jAname
      ..category = category ?? this.category
      ..imageurl = imageurl ?? this.imageurl
      ..imagelargeurl = imagelargeurl ?? this.imagelargeurl
      ..etype = etype ?? this.etype
      ..weakness = weakness ?? this.weakness
      ..resistence = resistence ?? this.resistence
      ..effectdef = effectdef ?? this.effectdef
      ..effectres = effectres ?? this.effectres;
  }
}
