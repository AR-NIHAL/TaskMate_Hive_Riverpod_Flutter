import 'package:riverpod/riverpod.dart';
import 'package:taskmate/features/notes/data/datasources/note_local_datasource.dart';
import 'package:taskmate/features/notes/data/repositories/note_repository_impl.dart';
import 'package:taskmate/features/notes/domain/entities/note_entity.dart';
import 'package:taskmate/features/notes/domain/repositories/note_repository.dart';
import 'package:taskmate/features/notes/domain/usecases/add_note_usecase.dart';
import 'package:taskmate/features/notes/domain/usecases/get_note_usecase.dart';
import 'package:taskmate/features/notes/presentation/providers/notebox_provider.dart';
import 'package:taskmate/features/notes/presentation/providers/notes_notifier.dart';

final noteLocalDatasourceProvider = Provider<NoteLocalDatasource>((ref) {
  final box = ref.watch(noteBoxProvider);

  return NoteLocalDatasourceImpl(box);
});

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  final datasource = ref.watch(noteLocalDatasourceProvider);

  return NoteRepositoryImpl(datasource);
});

final addNoteUsecaseProvider = Provider<AddNoteUsecase>((ref) {
  final repository = ref.watch(noteRepositoryProvider);

  return AddNoteUsecase(repository);
});

final getNotesUsecaseProvider = Provider<GetNotesUsecase>((ref) {
  final repository = ref.watch(noteRepositoryProvider);

  return GetNotesUsecase(repository);
});

final notesNotifierProvider =
    AsyncNotifierProvider<NotesNotifier, List<NoteEntity>>(NotesNotifier.new);
