import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'note_validation_state.dart';

class NoteValidationCubit extends Cubit<NoteValidationState> {
  NoteValidationCubit() : super(const NoteValidating());

//validate the note edit form
  void validaForm(String title, String? title2, String content) {
    String cubitTitleMessage = '';
    String cubitTitleMessage2 = '';
    String cubitContentMessage = '';
    bool formInvalid;

    formInvalid = false;
    if (title == '') {
      formInvalid = true;
      cubitTitleMessage = 'Fill in the title';
    } else {
      cubitTitleMessage = '';
    }

    if(title2 == ''){
      formInvalid = true;
      cubitTitleMessage2 = 'Fill in the title 2';
    }
    else{
      cubitTitleMessage2 = '';
    }

    if (content == '') {
      formInvalid = true;
      cubitContentMessage = 'Fill in the content';
    } else {
      cubitContentMessage = '';
    }

    if (formInvalid == true) {
      emit(NoteValidating(
        titleMessage: cubitTitleMessage,
        titleMessage2: cubitTitleMessage2,
        contentMessage: cubitContentMessage,
      ));
    } else {
      emit(const NoteValidated());
    }
  }
}
