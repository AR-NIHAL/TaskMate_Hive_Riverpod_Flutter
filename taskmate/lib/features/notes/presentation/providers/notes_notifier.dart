import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmate/features/notes/domain/usecases/get_note_usecase.dart';
import 'package:taskmate/features/notes/presentation/providers/notes_provider.dart';

import '../../domain/entities/note_entity.dart';
import '../../domain/usecases/add_note_usecase.dart';

class NotesNotifier extends AsyncNotifier<List<NoteEntity>> {
  late final GetNotesUsecase _getNotesUsecase;
  late final AddNoteUsecase _addNoteUsecase;

  @override
  Future<List<NoteEntity>> build() async {
    _getNotesUsecase = ref.read(getNotesUsecaseProvider);
    _addNoteUsecase = ref.read(addNoteUsecaseProvider);

    return await _getNotesUsecase();
  }

  Future<void> addNote(NoteEntity note) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _addNoteUsecase(note);

      return await _getNotesUsecase();
    });
  }
}
