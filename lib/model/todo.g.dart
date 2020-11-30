// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) {
  return Todo(
    id: json['id'] as int,
    description: json['description'] as String,
    status: json['status'] as String,
    preview: json['preview'] as String,
    notify: json['notify'] as int,
    createdOn: json['created_on'] == null
        ? null
        : DateTime.parse(json['created_on'] as String),
  );
}

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'status': instance.status,
      'preview': instance.preview,
      'notify': instance.notify,
      'created_on': instance.createdOn?.toIso8601String(),
    };
