import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uuid/uuid.dart';
import '../../../core/storage/hive_bootstrap.dart';
import '../data/task_repository.dart';
import '../model/task.dart';

final _uuid = const Uuid();

final taskRepositoryProvider = Provider((ref) {
  return TaskRepository(HiveBootstrap.tasksBox());
});

class TaskListNotifier extends Notifier<List<Task>> {
  @override
  List<Task> build() {
    final repo = ref.watch(taskRepositoryProvider);
    return repo.getAll();
  }

  Future<void> addTask({
    required String title,
    String? note,
    DateTime? dueAt,
  }) async {
    final repo = ref.read(taskRepositoryProvider);
    final task = Task(
      id: _uuid.v4(),
      title: title.trim(),
      note: (note?.trim().isEmpty ?? true) ? null : note?.trim(),
      dueAt: dueAt,
      createdAt: DateTime.now(),
    );
    await repo.upsert(task);
    state = repo.getAll();
  }

  Future<void> toggleComplete(String id) async {
    final repo = ref.read(taskRepositoryProvider);
    final t = repo.getById(id);
    if (t == null) return;
    await repo.upsert(t.copyWith(isCompleted: !t.isCompleted));
    state = repo.getAll();
  }

  Future<void> updateTask(Task updated) async {
    final repo = ref.read(taskRepositoryProvider);
    await repo.upsert(updated);
    state = repo.getAll();
  }

  Future<void> deleteTask(String id) async {
    final repo = ref.read(taskRepositoryProvider);
    await repo.delete(id);
    state = repo.getAll();
  }
}

final taskListProvider = NotifierProvider<TaskListNotifier, List<Task>>(
  TaskListNotifier.new,
);

enum TaskFilter { today, upcoming, completed, all }

final taskFilterProvider = StateProvider<TaskFilter>((ref) => TaskFilter.today);

final filteredTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(taskListProvider);
  final filter = ref.watch(taskFilterProvider);
  final now = DateTime.now();

  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  switch (filter) {
    case TaskFilter.today:
      return tasks
          .where(
            (t) =>
                !t.isCompleted && t.dueAt != null && isSameDay(t.dueAt!, now),
          )
          .toList();
    case TaskFilter.upcoming:
      final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);
      return tasks
          .where(
            (t) =>
                !t.isCompleted &&
                t.dueAt != null &&
                t.dueAt!.isAfter(endOfToday),
          )
          .toList();
    case TaskFilter.completed:
      return tasks.where((t) => t.isCompleted).toList();
    case TaskFilter.all:
      return tasks;
  }
});
