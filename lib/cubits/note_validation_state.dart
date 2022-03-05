part of 'note_validation_cubit.dart';

abstract class NoteValidationState extends Equatable {
  const NoteValidationState();
}

// form fields awaiting successful validation
class NoteValidating extends NoteValidationState {
  const NoteValidating({
    this.titleMessage,
    this.titleMessage2,
    this.contentMessage,
  });

  final String? titleMessage;
  final String? titleMessage2;
  final String? contentMessage;

  NoteValidating copyWith({
    String? titleMessage,
    String? titleMessage2,
    String? contentMessage,
  }) {
    return NoteValidating(
      titleMessage: titleMessage ?? this.titleMessage,
      titleMessage2: titleMessage2 ?? this.titleMessage2,
      contentMessage: contentMessage ?? this.contentMessage,
    );
  }

  @override
  List<Object?> get props => [titleMessage, titleMessage2, contentMessage];
}

// form fields validated successfully
class NoteValidated extends NoteValidationState {
  const NoteValidated();

  @override
  List<Object> get props => [];
}
