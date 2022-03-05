import 'package:cubitsqlitecrud/cubits/note_validation_cubit.dart';
import 'package:cubitsqlitecrud/cubits/notes_cubit.dart';
import 'package:cubitsqlitecrud/models/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteEditPage extends StatelessWidget {
  const NoteEditPage({Key? key, this.note}) : super(key: key);
  final Note? note;
// the NotesCubit that was created and provided to MaterialApp is retrieved
  // via the .value constructor, remembering that new instances do not use the .value,
  // only new instances of a cubit/bloc
  // NoteValidationCubit is created and provided for field validation
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: BlocProvider.of<NotesCubit>(context),
        ),
        BlocProvider(
          create: (context) => NoteValidationCubit(),
        ),
      ],
      child: NotesEditView(note: note),
    );
  }
}

class NotesEditView extends StatelessWidget {
  NotesEditView({
    Key? key,
    this.note,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _title2Controller = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  // final TextEditingController _contentController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _title2FocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();
  final Note? note;

  @override
  Widget build(BuildContext context) {
// if editing an existing note, the form fields
    // are filled with the note attributes
    if (note == null) {
      _titleController.text = '';
      _title2Controller.text = '';
      _contentController.text = '';
    } else {
      _titleController.text = note!.title;
      _title2Controller.text = note!.title2 ?? "";
      _contentController.text = note!.content;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloc SQLite Crud - Edit Note'),
      ),
      body: BlocListener<NotesCubit, NotesState>(
        listener: (context, state) {
// the state description is in the notes_state file and the states
          // untreated here are used in the note list screen
          // print(state.toString());
          if (state is NotesInitial) {
            const SizedBox();
          } else if (state is NotesLoading) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                });
          } else if (state is NotesSuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                content: Text('Operation performed successfully'),
              ));
                // after the note is saved, the notes are retrieved again and
            // the app re-displays the note list screen
            Navigator.pop(context);
            context.read<NotesCubit>().fetchNotes();
          } else if (state is NotesLoaded) {
            Navigator.pop(context);
          } else if (state is NotesFailure) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                content: Text('Error updating grade'),
              ));
          }
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BlocBuilder<NoteValidationCubit, NoteValidationState>(
                  builder: (context, state) {
                    return TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                      controller: _titleController,
                      focusNode: _titleFocusNode,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: _title2FocusNode.requestFocus,
                      onChanged: (text) {
                        // validation is performed on every field change
                        context.read<NoteValidationCubit>().validaForm(
                            _titleController.text, _title2Controller.text, _contentController.text);
                      },
                      onFieldSubmitted: (String value) {},
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        // the Not Validating state is emitted when there is a validation error
                        // in any field of the form and
                        // the error message is also displayed
                        if (state is NoteValidating) {
                          if (state.titleMessage == '') {
                            return null;
                          } else {
                            return state.titleMessage;
                          }
                        }
                      },
                    );
                  },
                ),
                BlocBuilder<NoteValidationCubit, NoteValidationState>(
                  builder: (context, state) {
                    return TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Title 2',
                      ),
                      controller: _title2Controller,
                      focusNode: _title2FocusNode,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: _contentFocusNode.requestFocus,
                      onChanged: (text) {
                        // validation is performed on every field change
                        context.read<NoteValidationCubit>().validaForm(
                            _titleController.text, _title2Controller.text, _contentController.text);
                      },
                      onFieldSubmitted: (String value) {},
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        // the Not Validating state is emitted when there is a validation error
                        // in any field of the form and
                        // the error message is also displayed
                        if (state is NoteValidating) {
                          if (state.titleMessage2 == '') {
                            return null;
                          } else {
                            return state.titleMessage2;
                          }
                        }
                      },
                    );
                  },
                ),
                BlocBuilder<NoteValidationCubit, NoteValidationState>(
                  builder: (context, state) {
                    return TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Contents',
                      ),
                      controller: _contentController,
                      focusNode: _contentFocusNode,
                      textInputAction: TextInputAction.done,
                      onChanged: (text) {
                        // validation is performed on every field change
                        context.read<NoteValidationCubit>().validaForm(
                            _titleController.text, _title2Controller.text, _contentController.text);
                      },
                      onFieldSubmitted: (String value) {
                        if (_formKey.currentState!.validate()) {
                          // close keyboard
                          FocusScope.of(context).unfocus();
                          context.read<NotesCubit>().saveNote(note?.id,
                              _titleController.text, _title2Controller.text, _contentController.text);
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        // the Not Validating state is emitted when there is a validation error
                        // in any field of the form and
                        // the error message is also displayed
                        if (state is NoteValidating) {
                          if (state.contentMessage == '') {
                            return null;
                          } else {
                            return state.contentMessage;
                          }
                        }
                      },
                    );
                  },
                ),






              // TextFormField(
              //   decoration: const InputDecoration(
              //     labelText: 'Contents',
              //   ),
              //   maxLength : 1,
              //   // controller: _contentController,
              //   // focusNode: _contentFocusNode,
              //   textInputAction: TextInputAction.done,
              //   onChanged: (text) {
              //     // validation is performed on every field change
              //     // context.read<NoteValidationCubit>().validaForm(
              //     //     _titleController.text, _contentController.text);
              //   },
              //   onFieldSubmitted: (String value) {
              //     if (_formKey.currentState!.validate()) {
              //       // close keyboard
              //       // FocusScope.of(context).unfocus();
              //       // context.read<NotesCubit>().saveNote(note?.id,
              //       //     _titleController.text, _contentController.text);
              //     }
              //   },
              //   autovalidateMode: AutovalidateMode.onUserInteraction,
              //   validator: (value) {},
              // ),



                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child:
                        BlocBuilder<NoteValidationCubit, NoteValidationState>(
                      builder: (context, state) {
                        // the save button is enabled only when
                        // the form is fully validated
                        return ElevatedButton(
                          onPressed: state is NoteValidated
                              ? () {
                                  if (_formKey.currentState!.validate()) {
                                    // close keyboard
                                    FocusScope.of(context).unfocus();
                                    context.read<NotesCubit>().saveNote(
                                        note?.id,
                                        _titleController.text,
                                        _title2Controller.text,
                                        _contentController.text);
                                  }
                                }
                              : null,
                          child: const Text('To save'),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
