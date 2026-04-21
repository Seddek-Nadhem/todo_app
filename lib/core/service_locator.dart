import 'package:get_it/get_it.dart';
import 'package:todo_app/data/datasources/todo_local_data_source.dart';
import 'package:todo_app/data/repositories/todo_repository_impl.dart';
import 'package:todo_app/domain/repositories/todo_repository.dart';
import 'package:todo_app/domain/usecases/add_todo.dart';
import 'package:todo_app/domain/usecases/delete_todo.dart';
import 'package:todo_app/domain/usecases/get_todos.dart';
import 'package:todo_app/domain/usecases/update_todo.dart';
import 'package:todo_app/presentation/cubits/todo_cubit.dart';

final sl = GetIt.instance; // sl stands for Service Locator

Future<void> init() async {
  // 1. Cubit (Factory: A new instance is created every time it's called)
  sl.registerFactory(() => TodoCubit(
        getTodosUseCase: sl(),
        addTodoUseCase: sl(),
        updateTodoUseCase: sl(),
        deleteTodoUseCase: sl(),
      ));

  // 2. Use Cases (Lazy Singleton: Created only when first needed)
  sl.registerLazySingleton(() => GetTodos(sl()));
  sl.registerLazySingleton(() => AddTodo(sl()));
  sl.registerLazySingleton(() => UpdateTodo(sl()));
  sl.registerLazySingleton(() => DeleteTodo(sl()));

  // 3. Repository Implementation
  sl.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(sl()),
  );

  // 4. Data Sources
  sl.registerLazySingleton(() => TodoLocalDataSource());
}