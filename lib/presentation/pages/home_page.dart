import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/entities/todo.dart';
import 'package:todo_app/presentation/cubits/todo_cubit.dart';
import 'package:todo_app/presentation/cubits/todo_state.dart';
import 'package:todo_app/presentation/widgets/todo_bottom_sheet.dart';

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

                return Dismissible(
                  // 1. Unique key is required. We use the ID from the database.
                  key: Key(todo.id.toString()),

                  // 2. Swipe direction (Right to Left)
                  direction: DismissDirection.startToEnd,

                  // 3. The red background that appears behind the card
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(
                        16,
                      ), // Match your card's radius
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),

                  // 4. The logic: what happens when swiped
                  onDismissed: (direction) {
                    // Access the Cubit and call delete
                    context.read<TodoCubit>().deleteTodo(todo.id!);

                    // Show a quick feedback message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${todo.title} deleted")),
                    );
                  },

                  child: _TodoCard(todo: todo),
                );
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
          showModalBottomSheet(
            context: context,
            isScrollControlled:
                true, // Allows the sheet to move up with the keyboard
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => const TodoBottomSheet(),
          );
        },
        label: const Text('Add Task'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

// Separate Widget for the individual Todo Card
class _TodoCard extends StatelessWidget {
  final Todo todo;
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
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            // We pass the current todo so the fields are pre-filled!
            builder: (context) => TodoBottomSheet(todo: todo),
          );
        },
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
