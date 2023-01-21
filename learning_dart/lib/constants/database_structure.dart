//DATABASE DATA
const dbName = "notes.db";
const noteTable = "note";
const userTable = "user";

//common fields
const idColumn = "id";
//user fields
const emailColumn = "email";
//notes fields
const isSyncedWithCloudColumn = "is_synced_with_cloud";
const userIdColumn = "user_id";
const textColumn = "text";

//CREATE TABLES
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user"  (
        "id"	INTEGER NOT NULL,
        "email"	TEXT NOT NULL UNIQUE,
        PRIMARY KEY("id" AUTOINCREMENT)
      );''';

const createNoteTable = '''CREATE TABLE  IF NOT EXISTS "notes" (
        "id"	INTEGER NOT NULL,
        "user_id"	INTEGER NOT NULL,
        "text"	TEXT NOT NULL,
        "is_sync_with_cloud"	INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY("id" AUTOINCREMENT),
        FOREIGN KEY("user_id") REFERENCES "user"("id")
      )
      ''';
