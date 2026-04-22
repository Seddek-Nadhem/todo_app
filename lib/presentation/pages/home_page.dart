import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/presentation/cubits/todo_cubit.dart';
import 'package:todo_app/presentation/cubits/todo_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Soft background color
      appBar: AppBar(
        title: const Text(
          'My Tasks',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        // since deleting centerTitle: false gives us the same result as it is now, why not just delete it?
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<TodoCubit, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoLoaded) {
            if (state.todos.isEmpty) {
              return const Center(child: Text("No tasks yet. Add one!"));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.todos.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final todo = state.todos[index];
                return _TodoCard(todo: todo);
              },
            );
          } else if (state is TodoError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // We will implement the Add Todo dialog in the next step
        },
        label: const Text('Add Task'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

// Separate Widget for the individual Todo Card
class _TodoCard extends StatelessWidget {
  final dynamic todo; // Using dynamic for now, will map to Todo entity
  const _TodoCard({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(
          todo.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            color: todo.isCompleted ? Colors.grey : Colors.black87,
          ),
        ),
        subtitle: Text(todo.description),
        trailing: Checkbox(
          value: todo.isCompleted,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          onChanged: (value) {
            context.read<TodoCubit>().toggleTodoStatus(todo);
          },
        ),
      ),
    );
  }
}