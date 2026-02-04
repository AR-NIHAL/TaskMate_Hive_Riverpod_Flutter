import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/settings_store.dart';
import '../state/task_providers.dart';

enum TaskFilter { today, upcoming, completed, all }

class TaskHomePage extends ConsumerStatefulWidget {
  const TaskHomePage({super.key});

  @override
  ConsumerState<TaskHomePage> createState() => _TaskHomePageState();
}

class _TaskHomePageState extends ConsumerState<TaskHomePage> {
  TaskFilter _selectedFilter = TaskFilter.today;

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskListProvider);
    final count = ref.watch(taskCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('TaskMate • ${_label(_selectedFilter)}'),
        actions: [
          PopupMenuButton<TaskFilter>(
            initialValue: _selectedFilter,
            onSelected: (value) => setState(() => _selectedFilter = value),
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
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(taskListProvider.notifier).addDummy(),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: ListTile(
                title: const Text('Riverpod + Hive'),
                subtitle: Text('Tasks: $count'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_forever),
                  onPressed: () =>
                      ref.read(taskListProvider.notifier).clearAll(),
                ),
              ),
            ),
          ),
          Expanded(
            child: SettingsStore.isFirstOpen
                ? _FirstOpenState(
                    onContinue: () async {
                      await SettingsStore.setFirstOpenFalse();
                      if (mounted) setState(() {});
                    },
                  )
                : tasks.isEmpty
                ? _EmptyState(filter: _selectedFilter)
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: tasks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final t = tasks[i];
                      return Card(
                        child: ListTile(
                          title: Text(t.title),
                          subtitle: Text(t.createdAt.toString()),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _label(TaskFilter f) {
    switch (f) {
      case TaskFilter.today:
        return 'Today';
      case TaskFilter.upcoming:
        return 'Upcoming';
      case TaskFilter.completed:
        return 'Completed';
      case TaskFilter.all:
        return 'All';
    }
  }
}

/* ---------------- EMPTY STATE ---------------- */

class _EmptyState extends StatelessWidget {
  final TaskFilter filter;
  const _EmptyState({required this.filter});

  String get title {
    switch (filter) {
      case TaskFilter.today:
        return 'No tasks for today';
      case TaskFilter.upcoming:
        return 'No upcoming tasks';
      case TaskFilter.completed:
        return 'No completed tasks yet';
      case TaskFilter.all:
        return 'No tasks yet';
    }
  }

  String get subtitle {
    switch (filter) {
      case TaskFilter.today:
        return 'Add a task you want to finish today.';
      case TaskFilter.upcoming:
        return 'Plan ahead by adding a due date.';
      case TaskFilter.completed:
        return 'Complete tasks to see them here.';
      case TaskFilter.all:
        return 'Tap + to create your first task.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.task_alt, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              title,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------------- FIRST OPEN STATE ---------------- */

class _FirstOpenState extends StatelessWidget {
  final Future<void> Function() onContinue;

  const _FirstOpenState({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.waving_hand, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              'Welcome to TaskMate!',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'This message shows only the first time.\n'
              'Tap continue to start using the app.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onContinue, child: const Text('Continue')),
          ],
        ),
      ),
    );
  }
}
