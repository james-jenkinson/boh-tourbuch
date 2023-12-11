import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

const personTable = 'Persons';
const productTypeTable = 'ProductTypes';
const productOrderTable = 'ProductOrders';
const commentTable = 'Comments';
const faqTable = 'FAQ';

class DatabaseInstance {
  static final DatabaseInstance databaseInstance = DatabaseInstance();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _createDatabase();
      return _database!;
    }
  }

  Future<Database> _createDatabase() async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final String path = '${documentsDirectory.path}boh.db';

    return await openDatabase(
      path,
      version: 1,
      onCreate: _initDb,
      password:
          const String.fromEnvironment('DB_PASSWORD', defaultValue: '123456'),
    );
  }

  Future<void> _initDb(Database database, int version) async {
    await database.execute('''
      create table $personTable (
        id integer primary key,
        name text not null,
        blocked_since text,
        comment text not null
      )
    ''');

    await database.execute('''
      create table $productTypeTable (
        id integer primary key,
        name text not null,
        symbol text,
        image blob,
        deletable int not null,
        days_blocked int not null
      )
    ''');
    await database.execute('''
      create table $commentTable (
        id integer primary key,
        person_id integer not null,
        issued_date text not null,
        content text not null,
        comment_done integer not null,
        foreign key(person_id) references $personTable(id)
      )
    ''');
    await database.execute('''
      create table $productOrderTable (
        id integer primary key,
        person_id integer not null,
        last_issue_date text,
        product_type_id integer not null,
        received_date text,
        status text not null,
        foreign key(person_id) references $personTable(id),
        foreign key(product_type_id) references $productTypeTable(id)
      )
    ''');
    await database.execute('''
      create table $faqTable (
        id integer primary key,
        question text not null,
        answer text not null)
    ''');

    await database.insert(productTypeTable,
        {'name': 'Zelt', 'symbol': '⛺', 'days_blocked': 90, 'deletable': 0});
    await database.insert(productTypeTable, {
      'name': 'Schlafsack',
      'symbol': '💤',
      'days_blocked': 90,
      'deletable': 0
    });
    await database.insert(productTypeTable, {
      'name': 'Isomatte',
      'symbol': '🛏️',
      'days_blocked': 90,
      'deletable': 0
    });
    await database.insert(productTypeTable, {
      'name': 'Rucksack',
      'symbol': '🎒',
      'days_blocked': 90,
      'deletable': 0
    });
  }
}
