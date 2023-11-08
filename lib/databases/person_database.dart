import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

const personTable = "Persons";
class PersonDatabase {
  static final PersonDatabase personDatabase = PersonDatabase();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await createDatabase();
      return _database!;
    }
  }

  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = "${documentsDirectory.path}persons.db";

    return await openDatabase(path, version: 1, onCreate: initDb, password: "123456");
  }

  initDb(Database database, int version) async {
    await database.execute("create table $personTable ("
        "id integer primary key, "
        "name text"
        ")");
  }
}