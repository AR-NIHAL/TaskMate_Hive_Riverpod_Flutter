import 'package:hive/hive.dart';
import '../model/task.dart';

class TaskRepository {
  final Box<Task> _box;

  TaskRepository(this._box);

  int count() => _box.length;

  List<Task> getAll() {
    final tasks = _box.values.toList();
    tasks.sort(
      (a, b) => b.createdAt.compareTo(a.createdAt), // newest first
    );
    return tasks;
  }

  Future<void> upsert(Task task) async {
    await _box.put(task.id, task);
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  Future<void> clear() async {
    await _box.clear();
  }
}
