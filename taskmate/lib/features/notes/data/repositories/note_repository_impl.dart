import 'package:taskmate/features/notes/data/datasources/note_local_datasource.dart';
import 'package:taskmate/features/notes/data/models/note_model.dart';

import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDatasource localDatasource;

  NoteRepositoryImpl(this.localDatasource);

  @override
  Future<void> addNote(NoteEntity note) async {
    final model = NoteModel(
      noteId: note.id,
      noteTitle: note.title,
      noteContent: note.content,
      notePinned: note.isPinned,
      noteCreatedAt: note.createdAt,
      noteUpdatedAt: note.updatedAt,
    );

    await localDatasource.addNote(model);
  }

  @override
  Future<List<NoteEntity>> getNotes() async {
    return await localDatasource.getNotes();
  }
}
