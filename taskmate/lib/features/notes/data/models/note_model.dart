import 'package:hive/hive.dart';
import '../../domain/entities/note_entity.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel extends NoteEntity {
  @HiveField(0)
  final String noteId;

  @HiveField(1)
  final String noteTitle;

  @HiveField(2)
  final String noteContent;

  @HiveField(3)
  final bool notePinned;

  @HiveField(4)
  final DateTime noteCreatedAt;

  @HiveField(5)
  final DateTime noteUpdatedAt;

  const NoteModel({
    required this.noteId,
    required this.noteTitle,
    required this.noteContent,
    required this.notePinned,
    required this.noteCreatedAt,
    required this.noteUpdatedAt,
  }) : super(
         id: noteId,
         title: noteTitle,
         content: noteContent,
         isPinned: notePinned,
         createdAt: noteCreatedAt,
         updatedAt: noteUpdatedAt,
       );
}
