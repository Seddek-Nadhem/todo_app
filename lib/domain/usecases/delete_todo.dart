import 'package:todo_app/domain/repositories/todo_repository.dart';

class DeleteTodo {
  final TodoRepository repository;

  DeleteTodo(this.repository);

  Future<void> call(int id) async {
    return await repository.deleteTodo(id);
  }
}