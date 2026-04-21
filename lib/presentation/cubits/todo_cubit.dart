import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/entities/todo.dart';
import 'package:todo_app/domain/usecases/add_todo.dart';
import 'package:todo_app/domain/usecases/delete_todo.dart';
import 'package:todo_app/domain/usecases/get_todos.dart';
import 'package:todo_app/domain/usecases/update_todo.dart';
import 'package:todo_app/presentation/cubits/todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final GetTodos getTodosUseCase;
  final AddTodo addTodoUseCase;
  final UpdateTodo updateTodoUseCase;
  final DeleteTodo deleteTodoUseCase;

  TodoCubit({
    required this.getTodosUseCase,
    required this.addTodoUseCase,
    required this.updateTodoUseCase,
    required this.deleteTodoUseCase,
  }) : super(TodoInitial());

  // --- Functions ---

  // 1. Fetch all todos
  Future<void> loadTodos() async {
    emit(TodoLoading());
    try {
      final todos = await getTodosUseCase();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError("Failed to fetch tasks: ${e.toString()}"));
    }
  }

  // 2. Add a new todo
  Future<void> addTodo(String title, String description) async {
    try {
      final newTodo = Todo(
        title: title,
        description: description,
      );
      await addTodoUseCase(newTodo);
      // Refresh the list after adding
      await loadTodos();
    } catch (e) {
      emit(TodoError("Could not add task."));
    }
  }

  // 3. Toggle completion status
  Future<void> toggleTodoStatus(Todo todo) async {
    try {
      // Use copyWith to create a new version of the Todo with flipped status
      final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
      await updateTodoUseCase(updatedTodo);
      // Refresh the list to reflect changes
      await loadTodos();
    } catch (e) {
      emit(TodoError("Could not update task."));
    }
  }

  // 4. Delete a todo
  Future<void> deleteTodo(int id) async {
    try {
      await deleteTodoUseCase(id);
      await loadTodos();
    } catch (e) {
      emit(TodoError("Could not delete task."));
    }
  }
}