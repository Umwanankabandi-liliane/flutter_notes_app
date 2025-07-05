import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/note_repository.dart';
import 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  final NoteRepository _noteRepository;

  NotesCubit(this._noteRepository) : super(NotesInitial());

  Future<void> fetchNotes() async {
    emit(NotesLoading());
    try {
      final notes = await _noteRepository.fetchNotes();
      emit(NotesLoaded(notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> addNote(String text) async {
    try {
      await _noteRepository.addNote(text);
      final notes = await _noteRepository.fetchNotes();
      emit(NotesOperationSuccess('Note added successfully', notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> updateNote(String id, String text) async {
    try {
      await _noteRepository.updateNote(id, text);
      final notes = await _noteRepository.fetchNotes();
      emit(NotesOperationSuccess('Note updated successfully', notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _noteRepository.deleteNote(id);
      final notes = await _noteRepository.fetchNotes();
      emit(NotesOperationSuccess('Note deleted successfully', notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }
}
