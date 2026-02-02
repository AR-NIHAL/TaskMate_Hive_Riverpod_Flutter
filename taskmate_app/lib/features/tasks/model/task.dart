import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final bool isCompleted;

  @HiveField(4)
  final DateTime? dueAt;

  Task({
    required this.id,
    required this.title,
    required this.createdAt,
    this.isCompleted = false,
    this.dueAt,
  });

  Task copyWith({String? title, bool? isCompleted, DateTime? dueAt}) {
    return Task(
      id: id,
      title: title ?? this.title,
      createdAt: createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      dueAt: dueAt ?? this.dueAt,
    );
  }
}
