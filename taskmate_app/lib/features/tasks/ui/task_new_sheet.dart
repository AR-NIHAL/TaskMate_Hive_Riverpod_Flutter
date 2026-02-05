import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../state/task_providers.dart';

class TaskNewSheet extends ConsumerStatefulWidget {
  const TaskNewSheet({super.key});

  @override
  ConsumerState<TaskNewSheet> createState() => _TaskNewSheetState();
}

class _TaskNewSheetState extends ConsumerState<TaskNewSheet> {
  final _titleCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  DateTime? _dueAt;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      initialDate: _dueAt ?? now,
    );
    if (picked == null) return;

    // Set to end of day so it's inclusive for the "Today" filter
    setState(
      () => _dueAt = DateTime(picked.year, picked.month, picked.day, 23, 59),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This handles the keyboard overlaying the bottom sheet
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'New Task',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleCtrl,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'What needs to be done?',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _noteCtrl,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Note (optional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: Text(
                    _dueAt == null
                        ? 'Add due date'
                        : 'Due: ${DateFormat.yMMMd().format(_dueAt!)}',
                  ),
                ),
              ),
              if (_dueAt != null)
                IconButton(
                  onPressed: () => setState(() => _dueAt = null),
                  icon: const Icon(Icons.close),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: () async {
                final title = _titleCtrl.text.trim();
                if (title.isEmpty) return;

                await ref
                    .read(taskListProvider.notifier)
                    .addTask(title: title, note: _noteCtrl.text, dueAt: _dueAt);

                if (mounted) Navigator.pop(context);
              },
              child: const Text('Create Task'),
            ),
          ),
        ],
      ),
    );
  }
}
