import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class SqlitePersistence {
  static const DatabaseName = 'todo_app.db';
  static const TodoTableName = 'todo';
  Database db;

  SqlitePersistence._(this.db);

  static Future<SqlitePersistence> create() async =>
      SqlitePersistence._(await database());

  static Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), DatabaseName),
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE $TodoTableName(
            id INTEGER PRIMARY KEY,
            description TEXT,
            status TEXT,
            preview TEXT,
            notify INTEGER,
            created_on TEXT
          )''',
        );
      },
      version: 1,
    );
  }

  Future<List<Map<String, dynamic>>> getActive() async {
    final res = await db.rawQuery(
      '''SELECT * FROM $TodoTableName WHERE status NOT LIKE 'deleted' ORDER BY DATETIME(created_on, 'unixepoch')''',
    );
    return res;
  }

  void upsert(Map<String, dynamic> object) async {
    await db.insert(
      TodoTableName,
      object,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void delete(int key) async {
    await db.delete(
      TodoTableName,
      where: '''id LIKE ?''',
      whereArgs: [key],
    );
  }
}
