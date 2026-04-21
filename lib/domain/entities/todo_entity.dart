import 'package:equatable/equatable.dart';

class TodoEntity extends Equatable {
  final int? id;
  final String title;
  final String description;
  final bool isCompleted;

  const TodoEntity({
    this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  @override
  List<Object?> get props => [id, title, description, isCompleted];
}
