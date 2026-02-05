import 'package:hive_flutter/hive_flutter.dart';
import '../../features/tasks/model/task.dart';

class HiveBootstrap {
  static const tasksBoxName = 'tasks_box';
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());
    await Hive.openBox<Task>(tasksBoxName);
  }

  static Box<Task> tasksBox() => Hive.box<Task>(tasksBoxName);
}
