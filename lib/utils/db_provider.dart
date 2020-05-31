import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskreminderapp/models/remind.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ReminderAppDB.db");
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE Reminders ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "title TEXT,"
            "description TEXT,"
            "enabled BIT,"
            "dateTime TEXT"
            ")");
      },
    );
  }

 Future<int> addRemind(Remind newRemind) async {
    final db = await database;
    int result = await db.insert("Reminders", newRemind.toMap());
    return result;
  }

  getRemind(int id) async {
    final db = await database;
    var res = await db.query("Reminders", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Remind.fromMap(res.first) : Null;
  }

 Future<List<Remind>> getAllReminds() async {
    final db = await database;
    var res = await db.query("Reminders");
    List<Remind> list =
        res.isNotEmpty ? res.map((c) => Remind.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> updateRemind(Remind newRemind) async {
    final db = await database;
    int result = await db.update("Reminders", newRemind.toMap(),
        where: "id = ?", whereArgs: [newRemind.id]);
    return result;
  }

  deleteRemind(int id) async {
    final db = await database;
    db.delete("Reminders", where: "id = ?", whereArgs: [id]);
  }
}
