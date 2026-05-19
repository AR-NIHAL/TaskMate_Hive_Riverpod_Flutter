import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notes_provider.dart';
import 'add_note_page.dart';

class NotesListPage extends ConsumerWidget {
  const NotesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // নোটের স্টেট রিয়েক্টিভলি ওয়াচ করা হচ্ছে
    final notesState = ref.watch(notesNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Production Notes App')),
      body: notesState.when(
        // ১. সফলভাবে ডাটা লোড হলে এই পার্ট এক্সিকিউট হবে
        data: (notes) {
          if (notes.isEmpty) {
            return const Center(
              child: Text('No notes found. Click + to add one!'),
            );
          }
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    note.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(note.content),
                  trailing: Icon(
                    note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                    color: note.isPinned ? Colors.amber : Colors.grey,
                  ),
                ),
              );
            },
          );
        },
        // ২. ডাটা ব্যাকগ্রাউন্ডে লোড হওয়ার সময় যা দেখাবে
        loading: () => const Center(child: CircularProgressIndicator()),
        // ৩. কোনো এক্সেপশন বা ডাটাবেজ এরর হলে যা দেখাবে
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Something went wrong: $error',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNotePage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
