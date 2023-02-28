import 'package:flutter/material.dart';
import 'package:learning_dart/services/auth/auth_service.dart';
import 'package:learning_dart/services/cloud/cloud_note.dart';
import 'package:learning_dart/services/cloud/firebase_cloud_storage.dart';
import 'package:learning_dart/utilities/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:learning_dart/utilities/generics/get_arguments.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  //We create here this note so that we are able to keep hold of the note
  //on the screen when hot reloading
  CloudNote? _note;
  late final FireBaseCloudStorage _notesService;

  //We need a text editor controller for the note
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = FireBaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(
      documentId: note.documentId,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<CloudNote> createOrGetExistingNote() async {
    //if the widget thats calls the functions sent a databaseNote
    final widgetNote = context.getArgument<CloudNote>();
    if (widgetNote != null) {
      _note = widgetNote;
      //set the text
      _textController.text = widgetNote.text;
      return widgetNote;
    }
    //if note wasnt created, we create it
    final existingNote = _note;
    if (existingNote != null) return existingNote;

    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    //we create and return the new note
    final newNote = await _notesService.createNewNote(ownerUserId: userId);
    _note = newNote;
    return newNote;
  }

  //If the user discards the note and go to the previous screen
  //it is neccesary that the note isn't saved on the database
  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    //autosave the note
    final note = _note;
    final text = _textController.text;
    if (_textController.text.isNotEmpty && note != null) {
      await _notesService.updateNote(
        documentId: note.documentId,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("New note"),
          actions: [
            IconButton(
              onPressed: () async {
                final text = _textController.text;
                if (_note == null || text.isEmpty) {
                  await showCannotShareEmptyNoteDialog(context);
                } else {
                  Share.share(text);
                }
              },
              icon: const Icon(Icons.share),
            )
          ],
        ),
        body: FutureBuilder(
          future: createOrGetExistingNote(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _setupTextControllerListener();
                return TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                      hintText: "Start typing your notes here..."),
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
