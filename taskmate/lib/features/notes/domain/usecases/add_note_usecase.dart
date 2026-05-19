import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';

class AddNoteUsecase {
  final NoteRepository repository;

  AddNoteUsecase(this.repository);

  Future<void> call(NoteEntity note) async {
    if (note.title.trim().isEmpty) {
      throw Exception('Title cannot be empty');
    }

    await repository.addNote(note);
  }
}
