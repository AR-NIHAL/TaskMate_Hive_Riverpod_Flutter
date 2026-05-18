import 'package:hive/hive.dart';
import 'package:taskmate/features/notes/data/models/note_model.dart';

abstract class NoteLocalDatasource {
  Future<void> addNote(NoteModel note);
  Future<List<NoteModel>> getNotes();
}

class NoteLocalDatasourceImpl implements NoteLocalDatasource {
  final Box<NoteModel> noteBox;
  NoteLocalDatasourceImpl(this.noteBox);

  @override
  Future<void> addNote(NoteModel note) async {
    await noteBox.put(note.id, note);
  }

  @override
  Future<List<NoteModel>> getNotes() async {
    return noteBox.values.toList();
  }
}
