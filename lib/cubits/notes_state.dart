part of 'notes_cubit.dart';

abstract class NotesState {
  const NotesState();
}

// home screen state
class NotesInitial extends NotesState {
  const NotesInitial();

  @override
  List<Object?> get props => [];
}

// waiting for the operation to be performed
class NotesLoading extends NotesState {
  const NotesLoading();

  @override
  List<Object?> get props => [];
}

// list of notes loaded
class NotesLoaded extends NotesState {
  const NotesLoaded({
    this.notes,
  });

  final List<Note>? notes;

  NotesLoaded copyWith({
    List<Note>? notes,
  }) {
    return NotesLoaded(
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [notes];
}

// Failed to perform operation with notes
class NotesFailure extends NotesState {
  const NotesFailure();

  @override
  List<Object?> get props => [];
}

// operation performed successfully
class NotesSuccess extends NotesState {
  const NotesSuccess();

  @override
  List<Object?> get props => [];
}
