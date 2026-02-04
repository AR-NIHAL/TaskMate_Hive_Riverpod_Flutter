import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../data/task_repository.dart';
import '../model/task.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final box = Hive.box<Task>('tasks_box');
  return TaskRepository(box);
});

class TaskListNotifier extends Notifier<List<Task>> {
  @override
  List<Task> build() {
    // app start হেল initial data load
    return ref.read(taskRepositoryProvider).getAll();
  }

  Future<void> addDummy() async {
    final repo = ref.read(taskRepositoryProvider);
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final task = Task(
      id: id,
      title: 'Dummy Task $id',
      createdAt: DateTime.now(),
    );
    await repo.upsert(task);
    // IMPORTANT: state update করেল UI auto rebuild
    state = repo.getAll();
  }

  Future<void> clearAll() async {
    final repo = ref.read(taskRepositoryProvider);
    await repo.clear();
    state = repo.getAll();
  }
}

final taskListProvider = NotifierProvider<TaskListNotifier, List<Task>>(
  TaskListNotifier.new,
);
final taskCountProvider = Provider<int>((ref) {
  final tasks = ref.watch(taskListProvider);
  return tasks.length;
});
