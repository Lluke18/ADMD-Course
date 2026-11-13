import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable()
class Todo extends Equatable {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  const Todo({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
  Map<String, dynamic> toJson() => _$TodoToJson(this);

  
  Todo copyWith({String? title, bool? completed}) => Todo(
        userId: userId,
        id: id,
        title: title ?? this.title,
        completed: completed ?? this.completed,
      );

  @override
  List<Object?> get props => [userId, id, title, completed];
}