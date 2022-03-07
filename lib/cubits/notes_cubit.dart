import 'package:bloc/bloc.dart';
import 'package:cubitsqlitecrud/db/database_provider.dart';
import 'package:cubitsqlitecrud/models/note.dart';
part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit({required DatabaseProvider databaseProvider})
      : _databaseProvider = databaseProvider,
        super(const NotesInitial());

//instance of the sqlite database
  final DatabaseProvider _databaseProvider;

// fetch all notes
  Future<void> fetchNotes() async {
    emit(const NotesLoading());
    try {
      final notes = await _databaseProvider.fetchNotes();
      emit(NotesLoaded(
        notes: notes,
      ));
    } on Exception {
      emit(const NotesFailure());
    }
  }

  //delete note using an id
  Future<void> deleteNote(id) async {
    emit(const NotesLoading());

    // the line below in this cubit simulates processing time on the server
    // serves to test the circular indicator
    await Future.delayed(const Duration(seconds: 2));
    try {
      await _databaseProvider.delete(id);
      fetchNotes();
    } on Exception {
      emit(const NotesFailure());
    }
  }

  //delete all notes
  Future<void> deleteNotes() async {
    emit(const NotesLoading());

    await Future.delayed(const Duration(seconds: 2));
    try {
      await _databaseProvider.deleteAll();
      emit(const NotesLoaded(
        notes: [],
      ));
    } on Exception {
      emit(const NotesFailure());
    }
  }

  // save note
  Future<void> saveNote(int? id, String title, String title2, String content) async {
    Note editNote = Note(id: id, title: title, title2: title2, content: content);
    emit(const NotesLoading());
    await Future.delayed(const Duration(seconds: 2));
    try {
      //if the method did not receive an id, the note will be included, otherwise
      //the existing note will be updated by the id
      print("$title $title2");
      if (id == null) {
        editNote = await _databaseProvider.save(editNote);
      } else {
        editNote = await _databaseProvider.update(editNote);
      }
      emit(const NotesSuccess());
    // getNotes();
    } on Exception {
      emit(const NotesFailure());
    }
  }

}
