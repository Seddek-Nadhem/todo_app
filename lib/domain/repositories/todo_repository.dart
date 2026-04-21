import 'package:todo_app/domain/entities/todo_entity.dart';

abstract class TodoRepository {
  Future<List<TodoEntity>> getTodos();
  Future<void> addTodo(TodoEntity todo);
  Future<void> updateTodo(TodoEntity todo);
  Future<void> deleteTodo(int id);
}
