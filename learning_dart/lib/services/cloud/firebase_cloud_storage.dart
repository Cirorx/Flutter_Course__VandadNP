import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learning_dart/services/cloud/cloud_note.dart';
import 'package:learning_dart/services/cloud/cloud_storage_constanst.dart';
import 'package:learning_dart/services/cloud/cloud_storage_exceptions.dart';

class FireBaseCloudStorage {
  FireBaseCloudStorage._sharedInstance();
  static final FireBaseCloudStorage _shared =
      FireBaseCloudStorage._sharedInstance();
  factory FireBaseCloudStorage() => _shared;

  //Grab all the notes
  final notes = FirebaseFirestore.instance.collection("notes");

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: "",
    });

    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: "",
    );
  }

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    //get all the notes from an owner
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotGetAllNoteException();
    }
  }

  //Get all notes and filter them with userId
  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.ownerUserId == ownerUserId));

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteNote({
    required String documentId,
  }) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }
}
