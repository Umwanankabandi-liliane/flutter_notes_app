// lib/presentation/screens/notes_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/notes_cubit.dart';
import '../cubits/notes_state.dart';
import '../cubits/auth_cubit.dart';
import '../widgets/note_card.dart';
import '../widgets/note_dialog.dart';
import '../../utils/snackbar_utils.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotesCubit>().fetchNotes();
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => NoteDialog(
        onSave: (text) {
          context.read<NotesCubit>().addNote(text);
        },
      ),
    );
  }

  void _showEditNoteDialog(String id, String currentText) {
    showDialog(
      context: context,
      builder: (context) => NoteDialog(
        note: null, // We'll pass the current text through the dialog
        onSave: (text) {
          context.read<NotesCubit>().updateNote(id, text);
        },
      ),
    );
  }

  void _showDeleteConfirmation(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Note'),
        content: Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<NotesCubit>().deleteNote(id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Notes'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().signOut();
            },
          ),
        ],
      ),
      body: BlocConsumer<NotesCubit, NotesState>(
        listener: (context, state) {
          if (state is NotesError) {
            SnackbarUtils.showError(context, state.message);
          } else if (state is NotesOperationSuccess) {
            SnackbarUtils.showSuccess(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is NotesLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is NotesLoaded) {
            if (state.notes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.note_add,
                      size: 80,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Nothing here yet—tap ➕ to add a note.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: state.notes.length,
              itemBuilder: (context, index) {
                final note = state.notes[index];
                return NoteCard(
                  note: note,
                  onEdit: () => _showEditNoteDialog(note.id, note.text),
                  onDelete: () => _showDeleteConfirmation(note.id),
                );
              },
            );
          } else if (state is NotesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 80, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<NotesCubit>().fetchNotes(),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
