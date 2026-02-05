import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/task_providers.dart';
import 'task_new_sheet.dart';

class TaskHomePage extends ConsumerWidget {
  const TaskHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(taskFilterProvider);
    final tasks = ref.watch(filteredTasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskMate'),
        actions: [
          PopupMenuButton<TaskFilter>(
            initialValue: filter,
            onSelected: (f) => ref.read(taskFilterProvider.notifier).state = f,
            itemBuilder: (context) => const [
              PopupMenuItem(value: TaskFilter.today, child: Text('Today')),
              PopupMenuItem(
                value: TaskFilter.upcoming,
                child: Text('Upcoming'),
              ),
              PopupMenuItem(
                value: TaskFilter.completed,
                child: Text('Completed'),
              ),
              PopupMenuItem(value: TaskFilter.all, child: Text('All')),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (_) => const TaskNewSheet(),
        ),
        child: const Icon(Icons.add),
      ),
      body: tasks.isEmpty
          ? _EmptyState(filter: filter)
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final t = tasks[i];
                return Dismissible(
                  key: ValueKey(t.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) =>
                      ref.read(taskListProvider.notifier).deleteTask(t.id),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: Theme.of(context).dividerColor.withOpacity(0.1),
                      ),
                    ),
                    child: ListTile(
                      leading: IconButton(
                        icon: Icon(
                          t.isCompleted
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: t.isCompleted ? Colors.green : null,
                        ),
                        onPressed: () => ref
                            .read(taskListProvider.notifier)
                            .toggleComplete(t.id),
                      ),
                      title: Text(
                        t.title,
                        style: TextStyle(
                          decoration: t.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: t.isCompleted ? Colors.grey : null,
                        ),
                      ),
                      subtitle: t.note == null ? null : Text(t.note!),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final TaskFilter filter;
  const _EmptyState({required this.filter});

  String get _title {
    switch (filter) {
      case TaskFilter.today:
        return "No tasks for today";
      case TaskFilter.upcoming:
        return "No upcoming tasks";
      case TaskFilter.completed:
        return "No completed tasks yet";
      case TaskFilter.all:
        return "No tasks yet";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.task_alt,
              size: 56,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            Text(_title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            const Text("Tap + to create one."),
          ],
        ),
      ),
    );
  }
}
