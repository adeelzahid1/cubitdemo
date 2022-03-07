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

class NotesEditView extends StatefulWidget {
  NotesEditView({Key? key, this.note,}) : super(key: key);
  final Note? note;

  @override
  State<NotesEditView> createState() => _NotesEditViewState();
}

class _NotesEditViewState extends State<NotesEditView> {

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _title2Controller;
  late TextEditingController _contentController;

  late FocusNode _titleFocusNode;
  late FocusNode _title2FocusNode;
  late FocusNode _contentFocusNode;


  @override
  void initState() {
    _titleController = TextEditingController();
    _title2Controller = TextEditingController();
    _contentController = TextEditingController();

    _titleFocusNode = FocusNode();
    _title2FocusNode = FocusNode();
    _contentFocusNode = FocusNode();

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
// if editing an existing note, the form fields
    // are filled with the note attributes
    if (widget.note == null) {
      _titleController.text = '';
      _title2Controller.text = '';
      _contentController.text = '';
    } else {
      _titleController.text = widget.note!.title;
      _title2Controller.text = widget.note!.title2 ?? "";
      _contentController.text = widget.note!.content;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloc SQLite Crud - Edit Note'),
      ),
      body: BlocListener<NotesCubit, NotesState>(
        listener: _listner,
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
                          context.read<NotesCubit>().saveNote(widget.note?.id,
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
                                        widget.note?.id,
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

  void _listner(BuildContext context, NotesState state){
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

  }
}
