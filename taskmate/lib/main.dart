import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskmate/features/notes/data/models/note_model.dart';
import 'package:taskmate/features/notes/presentation/pages/home_page.dart';
import 'package:taskmate/features/notes/presentation/pages/notes_list_page.dart';
import 'package:taskmate/features/notes/presentation/providers/notebox_provider.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(NoteModelAdapter());

  final box = await Hive.openBox<NoteModel>('notes_box');

  runApp(
    ProviderScope(
      overrides: [noteBoxProvider.overrideWithValue(box)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(), // আমাদের বানানো সেই রিয়েক্টিভ স্ক্রিন
    );
  }
}
