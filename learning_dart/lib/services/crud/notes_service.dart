import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

import '../../constants/database_structure.dart';
import 'crud_exceptions.dart';

class NotesService {
  Database? _db;

  //OPEN AND CLOSE DB
  Future<void> open() async {
    //after opening the database, is going to store objects on our services
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }

    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      //OPEN THE DB
      final db = await openDatabase(dbPath);
      _db = db;

      //Create tables from the consts
      await db.execute(createUserTable);
      await db.execute(createNoteTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  //GET CURRENT DB
  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  /*
  USER FUNCTIONS
  */

  //CREATE USER
  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );

    if (results.isNotEmpty) {
      throw UserAlreadyExists();
    }

    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });

    return DatabaseUser(
      id: userId,
      email: email,
    );
  }

  //DELETE USER FROM DB
  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  //GET USER BY EMAIL
  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );

    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

  /*
  NOTES FUNCTIONS
  */

  //CREATE A NOTE FROM A USER
  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();

    final dbUser = await getUser(email: owner.email);

    //check that the owner exists on the db with correct id
    if (owner != dbUser) {
      throw CouldNotFindUser();
    }

    const text = "";
    // create the note
    final notesId = await db.insert(noteTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSyncedWithCloudColumn: 1,
    });

    final note = DatabaseNote(
      id: notesId,
      userId: owner.id,
      text: text,
      isSyncedWithCloud: true,
    );

    return note;
  }

  //DELETE A NOTE WITH ID
  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      noteTable,
      where: "id = ?",
      whereArgs: [id],
    );
    //if we could delete anything we throw the exception
    if (deletedCount == 0) {
      throw CouldNotDeleteNote();
    }
  }

  //DELETE ALL NOTES
  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(noteTable);
  }

  //GET ALL NOTES
  Future<Iterable<DatabaseNote>> getAllNotes() async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);

    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  //GET NOTE BY ID
  Future<DatabaseNote> getNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      userTable,
      limit: 1,
      where: "id = ?",
      whereArgs: [id],
    );

    if (notes.isEmpty) {
      throw CouldNotFindNote();
    } else {
      return DatabaseNote.fromRow(notes.first);
    }
  }

  //UPDATE CONTENT OF A NOTE
  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    final db = _getDatabaseOrThrow();
    await getNote(id: note.id);

    final updatesCounts = await db.update(noteTable, {
      textColumn: text,
      isSyncedWithCloudColumn: 0,
    });

    if (updatesCounts == 0) {
      throw CouldNotUpdateNote();
    } else {
      return await getNote(id: note.id);
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => "Person, ID =  $id, email = $email";

  //we are going to compare our object only with a DatabaseUser instance
  @override
  bool operator ==(covariant DatabaseUser other);

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        //it will evaluate the int, and if it is equal to 1 it will asing true
        //else is goint to assing false
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      "Note, ID = $id, userId = $userId, isSyncedWithCloud = $isSyncedWithCloud";

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;
}
