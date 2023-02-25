import 'package:flutter/material.dart';
import 'package:learning_dart/services/auth/auth_service.dart';
import 'package:learning_dart/services/crud/notes_service.dart';
import 'package:learning_dart/utilities/dialogs/generics/get_arguments.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  //We create here this note so that we are able to keep hold of the note
  //on the screen when hot reloading
  DatabaseNote? _note;
  late final NotesService _notesService;

  //We need a text editor controller for the note
  late final TextEditingController _textController;

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(
      note: note,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  @override
  void initState() {
    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

  Future<DatabaseNote> createOrGetExistingNote() async {
    //if the widget thats calls the functions sent a databaseNote
    final widgetNote = context.getArgument<DatabaseNote>();
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
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    //we create and return the new note
    final newNote = await _notesService.createNote(owner: owner);
    _note = newNote;
    return newNote;
  }

  //If the user discards the note and go to the previous screen
  //it is neccesary that the note isn't saved on the database
  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    //autosave the note
    final note = _note;
    final text = _textController.text;
    if (_textController.text.isNotEmpty && note != null) {
      await _notesService.updateNote(
        note: note,
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
