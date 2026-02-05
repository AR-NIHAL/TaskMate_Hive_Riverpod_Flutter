import 'package:hive/hive.dart';
import '../model/task.dart';

class TaskRepository {
  final Box<Task> box;
  TaskRepository(this.box);
  List<Task> getAll() {
    final tasks = box.values.toList();
    // newest first
    tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return tasks;
  }

  Future<void> upsert(Task task) async {
    await box.put(task.id, task);
  }

  Future<void> delete(String id) async {
    await box.delete(id);
  }

  Task? getById(String id) => box.get(id);
}
