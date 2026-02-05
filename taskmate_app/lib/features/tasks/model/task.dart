import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? note;

  @HiveField(3)
  final DateTime? dueAt;

  @HiveField(4)
  final bool isCompleted;

  @HiveField(5)
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.note,
    this.dueAt,
    this.isCompleted = false,
    required this.createdAt,
  });

  Task copyWith({
    String? title,
    String? note,
    DateTime? dueAt,
    bool? isCompleted,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      note: note ?? this.note,
      dueAt: dueAt ?? this.dueAt,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
    );
  }
}
