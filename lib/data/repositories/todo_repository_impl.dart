import 'package:todo_app/data/datasources/todo_local_data_source.dart';
import 'package:todo_app/data/models/todo_model.dart';
import 'package:todo_app/domain/entities/todo.dart';
import 'package:todo_app/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;
  TodoRepositoryImpl(this.localDataSource);

  @override
  Future<List<Todo>> getTodos() async {
    return await localDataSource.getTodos();
  }

  @override
  Future<void> addTodo(Todo todo) async {
    final model = TodoModel(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      isCompleted: todo.isCompleted,
    );
    await localDataSource.insertTodo(model);
  }

  @override
  Future<void> deleteTodo(int id) async {
    await localDataSource.deleteTodo(id);
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    final model = TodoModel(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      isCompleted: todo.isCompleted,
    );
    await localDataSource.updateTodo(model);
  }
}
