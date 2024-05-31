// note_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/features/notes/domain/entities/note.dart';
// import 'package:quiz_app/features/notes/presentation/notifier/note_providers.dart';
import 'package:quiz_app/features/notes/presentation/bloc/note_state.dart';

class NoteScreen extends ConsumerStatefulWidget {
  const NoteScreen({super.key});

  @override
  ConsumerState<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends ConsumerState<NoteScreen> {
  final _updateFormKey = GlobalKey<FormState>();
  final _updatedNoteTextController = TextEditingController();
  final _newFormKey = GlobalKey<FormState>();
  final _newNoteTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(noteNotifierProvider.notifier).getNoteEvent();
  }

  @override
  void dispose() {
    _updatedNoteTextController.dispose();
    _newNoteTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final noteState = ref.watch(noteNotifierProvider);

    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: noteState.when(
          initial: _buildNewNoteForm,
          loading: _buildLoading,
          loaded: _buildUpdateNoteForm,
          error: _buildErrorFeedback,
          created: _buildNewNoteForm,
          updated: _buildNewNoteForm,
          deleted: _buildNewNoteForm,
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          context.pop();
        },
      ),
      title: Text('Notebook'),
      centerTitle: true,
    );
  }

  Widget _buildLoading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildUpdateNoteForm(NoteLoaded state) {
    _updatedNoteTextController.text = state.note.noteText;

    return Form(
      key: _updateFormKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    tooltip: 'delete note',
                    onPressed: () {
                      ref
                          .read(noteNotifierProvider.notifier)
                          .deleteNoteEvent(state.note);
                    },
                    icon: Icon(Icons.delete))
              ],
            ),
            SizedBox(height: 16),
            TextFormField(
              maxLines: 7,
              keyboardType: TextInputType.multiline,
              controller: _updatedNoteTextController,
              decoration: InputDecoration(
                hintText: 'Your note here',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Write some note to save';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            _buildSaveButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNewNoteForm() {
    return Form(
      key: _newFormKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notebook', style: TextStyle(fontSize: 20)),
            SizedBox(height: 16),
            TextFormField(
              controller: _newNoteTextController,
              decoration: InputDecoration(
                hintText: 'Your note here',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Write some note to be added';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            _buildCreateButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16.0),
          backgroundColor: const Color(0xFF4280EF),
        ),
        onPressed: () {
          if (_updateFormKey.currentState!.validate()) {
            ref.read(noteNotifierProvider.notifier).updateNoteEvent(Note(
                  noteText: _updatedNoteTextController.text,
                ));
          }
        },
        child: const Text(
          'Save Note',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16.0),
          backgroundColor: const Color(0xFF4280EF),
        ),
        onPressed: () {
          if (_newFormKey.currentState!.validate()) {
            ref.read(noteNotifierProvider.notifier).createNoteEvent(Note(
                  noteText: _newNoteTextController.text,
                ));
          }
        },
        child: const Text(
          'Create Note',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildErrorFeedback() {
    return Center(
      child: Text('Problem Occurred. Check back later'),
    );
  }
}
