import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable(nullable: true)
class Todo {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'status')
  final String status;

  @JsonKey(name: 'preview')
  final String preview;

  @JsonKey(name: 'notify')
  final int notify;

  @JsonKey(name: 'created_on')
  final DateTime createdOn;

  Todo({
    this.id,
    this.description,
    this.status,
    this.preview,
    this.notify,
    this.createdOn,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoToJson(this);
}
