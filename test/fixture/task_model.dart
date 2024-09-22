// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Task {
  final String id;
  final String task;

  Task({
    required this.id,
    required this.task,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'task': task,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      task: map['task'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) =>
      Task.fromMap(json.decode(source) as Map<String, dynamic>);
}
