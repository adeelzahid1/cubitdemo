
import 'package:cubitsqlitecrud/cubits/notes_cubit.dart';
import 'package:cubitsqlitecrud/models/note.dart';
import 'package:cubitsqlitecrud/views/note_edit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteListPage extends StatelessWidget {
  const NoteListPage({Key? key}) : super(key: key);

// the NotesCubit that was created and provided to MaterialApp is retrieved
  // via the .value constructor and execute the function to fetch the notes,
  // that is, new instances do not use the .value, existing instances do
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<NotesCubit>(context)..fetchNotes(),
      child: const DocumentsView(),
    );
  }
}

class DocumentsView extends StatelessWidget {
  const DocumentsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloc SQLite Crud - List of Notes'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              // delete all notes
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Delete All Notes'),
                  content: const Text('Confirm operation?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<NotesCubit>().deleteNotes();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(const SnackBar(
                            content: Text('Notes successfully deleted'),
                          ));
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );

            },
          ),
        ],
      ),
      body: const _Content(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // as the FAB creates a new grade, the grade is not a received parameter
          // on the editing screen
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const NoteEditPage(note: null)),
          );
        },
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NotesCubit>().state;
    // the description of the states is in the notes_state file
    // the states not treated here are used in the note editing screen
    // print('note list ' + state.toString());
    if (state is NotesInitial) {
      return const SizedBox();
    } else if (state is NotesLoading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    } else if (state is NotesLoaded) {
      //the message below appears if the note list is empty
      if (state.notes!.isEmpty) {
        return const Center(
          child:
              Text('There are no notes. Click the button below to register.'),
        );
      } else {
        return _NotesList(state.notes!);
      }
    } else {
      return const Center(
        child: Text('Error retrieving notes.'),
      );
    }
  }
}

class _NotesList extends StatelessWidget {
  const _NotesList(this.notes, {Key? key}) : super(key: key);
  final List<Note> notes;
  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: notes.length,
        itemBuilder: (context, index){
          return   Padding(
            padding: const EdgeInsets.all(2.5),
            child: ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: Text("$index ${notes[index].title} ${notes[index].title2 ?? ""}"),
              subtitle: Text(
                notes[index].content,
              ),
              trailing: Wrap(children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // the existing note is sent as a parameter to the
                        // editing screen to fill in the fields automatically
                          builder: (context) => NoteEditPage(note: notes[index])),
                    );
                  },
                ),
                IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // delete note by id
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Delete Note'),
                          content: const Text('Confirm operation?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<NotesCubit>().deleteNote(notes[index].id);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(const SnackBar(
                                    content: Text('Note successfully deleted'),
                                  ));
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }),
              ]),
            ),
          );
          // const Divider(
          //   height: 2,
          // ),
        }
    );

  }
}
