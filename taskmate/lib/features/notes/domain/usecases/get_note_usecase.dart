import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';

class GetNotesUsecase {
  final NoteRepository repository;

  GetNotesUsecase(this.repository);

  Future<List<NoteEntity>> call() async {
    return await repository.getNotes();
  }
}
