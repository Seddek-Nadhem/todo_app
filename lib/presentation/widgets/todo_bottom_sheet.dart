import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/domain/entities/todo.dart';
import 'package:todo_app/presentation/cubits/todo_cubit.dart';

class TodoBottomSheet extends StatefulWidget {
  final Todo? todo; // If null, we are adding. If not null, we are editing.

  const TodoBottomSheet({super.key, this.todo});

  @override
  State<TodoBottomSheet> createState() => _TodoBottomSheetState();
}

class _TodoBottomSheetState extends State<TodoBottomSheet> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title);
    _descriptionController = TextEditingController(
      text: widget.todo?.description,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onSave() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isNotEmpty) {
      if (widget.todo == null) {
        // ADD NEW
        context.read<TodoCubit>().addTodo(title, description);
      } else {
        // UPDATE EXISTING
        final updatedTodo = widget.todo!.copyWith(
          title: title,
          description: description,
        );
        // We will need to call updateTodo in the Cubit (explained below)
        context.read<TodoCubit>().toggleTodoStatus(
          updatedTodo.copyWith(isCompleted: widget.todo!.isCompleted),
        );
      }
      Navigator.pop(context); // Close the sheet
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // This padding ensures the sheet moves up when the keyboard appears
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.todo == null ? 'Add New Task' : 'Edit Task',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Save Task', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
