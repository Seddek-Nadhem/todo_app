import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/extensions/build_context_extension.dart';
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

  String? _titleErrorText;

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
    } else {
      setState(() {
        _titleErrorText = context.l10n.titleRequiredError;
      });
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
            widget.todo == null ? context.l10n.addTask : context.l10n.editTask,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: context.l10n.titleLabel,
              border: OutlineInputBorder(),
              errorText: context.l10n.titleRequiredError,
            ),
            autofocus: true,
            onChanged: (value) {
              // Clear the red error as soon as they start typing
              if (_titleErrorText != null) {
                setState(() => _titleErrorText = null);
              }
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: context.l10n.descriptionLabel,
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
              child: Text(context.l10n.save, style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
