import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/service_locator.dart' as di;
import 'package:todo_app/presentation/cubits/todo_cubit.dart';

void main() async {
  // Ensure Flutter bindings are initialized before calling native code (SQLite)
  WidgetsFlutterBinding.ensureInitialized();

  // Initilaize the Service Locator
  await di.init();

  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // We ask the Service Locator (sl) to give us the TodoCubit
      // and immediately tell it to load the todos.
      create: (context) => di.sl<TodoCubit>()..loadTodos(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Modern Clean Todo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueAccent,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const Scaffold(
          body: Center(
            child: Text(
              'Logic is Ready!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
