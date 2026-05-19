import 'package:taskmate/features/notes/domain/entities/note_entity.dart';

abstract class NoteRepository {
  Future<void> addNote(NoteEntity note);
  Future<List<NoteEntity>> getNotes();
}
