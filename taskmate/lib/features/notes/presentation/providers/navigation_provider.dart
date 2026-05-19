import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/note_entity.dart';
import 'notes_provider.dart'; // তোমার আগের তৈরি করা notesNotifierProvider এখানে ইমপোর্ট করো

// বটম নেভিগেশনের কারেন্ট ইনডেক্স ট্র্যাক করার জন্য
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

// সার্চ বারের টেক্সট ট্র্যাক করার জন্য
final searchQueryProvider = StateProvider<String>((ref) => '');

// DERIVED STATE: মেইন নোট লিস্ট এবং সার্চ কুয়েরি কম্বাইন করে ফিল্টারড লিস্ট তৈরি করা
final filteredNotesProvider = Provider<AsyncValue<List<NoteEntity>>>((ref) {
  final notesAsync = ref.watch(notesNotifierProvider);
  final query = ref.watch(searchQueryProvider);

  // whenData মেথডটি শুধুমাত্র তখনই কাজ করবে যখন ডাটা সাকসেসফুলি লোড হবে
  return notesAsync.whenData((notes) {
    if (query.isEmpty) return notes;

    // টাইপ করা টেক্সটের সাথে টাইটেল বা কন্টেন্ট মিলিয়ে ফিল্টার করা হচ্ছে
    return notes.where((note) {
      final matchesTitle = note.title.toLowerCase().contains(
        query.toLowerCase(),
      );
      final matchesContent = note.content.toLowerCase().contains(
        query.toLowerCase(),
      );
      return matchesTitle || matchesContent;
    }).toList();
  });
});
