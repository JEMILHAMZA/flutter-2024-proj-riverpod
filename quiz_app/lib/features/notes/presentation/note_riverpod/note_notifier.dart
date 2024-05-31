import 'package:quiz_app/features/notes/domain/entities/note.dart';
import 'package:quiz_app/features/notes/domain/usecases/create_note_usecase.dart';
import 'package:quiz_app/features/notes/domain/usecases/delete_note_usecase.dart';
import 'package:quiz_app/features/notes/domain/usecases/get_note_usecase.dart';
import 'package:quiz_app/features/notes/domain/usecases/update_note_usecase.dart';
import 'package:quiz_app/features/notes/presentation/bloc/note_state.dart';
import 'package:riverpod/riverpod.dart';

class NoteNotifier extends StateNotifier<NoteState> {
  final CreateNote createNote;
  final DeleteNote deleteNote;
  final GetNote getNote;
  final UpdateNote updateNote;

  NoteNotifier({
    required this.createNote,
    required this.deleteNote,
    required this.getNote,
    required this.updateNote,
  }) : super(NoteInitial());

  Future<void> createNoteEvent(Note note) async {
    state = NoteLoading();
    final result = await createNote(note);
    result.fold(
      (failure) => state = NoteError('Failed to create note'),
      (success) => state = NoteCreated(success.message),
    );
  }

  Future<void> deleteNoteEvent() async {
    state = NoteLoading();
    final result = await deleteNote();
    result.fold(
      (failure) => state = NoteError('Failed to delete note'),
      (success) => state = NoteDeleted(success.message),
    );
  }

  Future<void> getNoteEvent() async {
    state = NoteLoading();
    final result = await getNote();
    result.fold(
      (failure) => state = NoteError('Failed to load note'),
      (note) => state = NoteLoaded(note),
    );
  }

  Future<void> updateNoteEvent(Note note) async {
    state = NoteLoading();
    final result = await updateNote(note);
    result.fold(
      (failure) => state = NoteError('Failed to update note'),
      (success) => state = NoteUpdated(success.message),
    );
  }
}
