import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/note_entity.dart';
import '../providers/notes_provider.dart';

class AddNotePage extends ConsumerStatefulWidget {
  const AddNotePage({super.key});

  @override
  ConsumerState<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends ConsumerState<AddNotePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _submitNote() async {
    final note = NoteEntity(
      id: const Uuid().v4(), // Unique ID generation
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      isPinned: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Notifier এর মাধ্যমে নোট অ্যাড করার রিকোয়েস্ট পাঠানো হচ্ছে
    await ref.read(notesNotifierProvider.notifier).addNote(note);

    // অ্যাপের বর্তমান স্টেট চেক করে সাকসেস বা এরর মেসেজ দেখানো
    final state = ref.read(notesNotifierProvider);

    if (mounted) {
      if (state.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note added successfully!')),
        );
        Navigator.pop(context); // সাকসেস হলে ব্যাক স্ক্রিনে নিয়ে যাওয়া
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // নোট অ্যাড হওয়ার সময় UI-তে লোডিং ইন্ডিকেটর দেখানোর জন্য স্টেট রিড করা
    final state = ref.watch(notesNotifierProvider);
    final isLoading = state is AsyncLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Add New Note')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              enabled: !isLoading,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              enabled: !isLoading,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submitNote,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Save Note'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
