import 'package:todo_app/domain/entities/todo.dart';

class TodoModel extends Todo {
  const TodoModel({
    super.id,
    required super.title,
    required super.description,
    super.isCompleted,
  });

  // Convert a Map (from SQLite) into a TodoModel
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      // isCompleted: json['isCompleted'] == 1 ? true : false;
      isCompleted: json['isCompleted'] == 1,
    );
  }

  // Convert a TodoModel into a Map (to save into SQLite)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }
}
