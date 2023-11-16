import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

const personTable = 'Persons';
const orderTable = 'Orders';
const commentTable = 'Comments';
const productTable = 'Products';
const productTypeTable = 'ProductTypes';

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
    final Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final String path = '${documentsDirectory.path}boh.db';

    return await openDatabase(path,
        version: 1, onCreate: _initDb, password: '123456');
  }

  Future<void> _initDb(Database database, int version) async {
    await database.execute("create table $personTable ("
        "id integer primary key, "
        "first_name text not null, "
        "last_name text not null, "
        "blocked integer not null"
        ")");
    await database.execute("create table $orderTable ("
        "id integer primary key, "
        "person_id integer not null, "
        "comment text not null, "
        "comment_done integer not null, "
        "order_date text not null, "
        "foreign key(person_id) references $personTable(id)"
        ")");
    await database.execute("create table $productTable ("
        "id integer primary key, "
        "order_id integer not null, "
        "product_type_id integer not null, "
        "status text not null, "
        "received_date text, "
        "foreign key(product_type_id) references $productTypeTable(id), "
        "foreign key(order_id) references $orderTable(id)"
        ")");
    await database.execute("create table $productTypeTable ("
        "id integer primary key, "
        "name text not null, "
        "symbol text not null, "
        "deletable int not null, "
        "days_blocked int not null"
        ")");
    await database.insert(productTypeTable, {
      'name': 'Zelt',
      'symbol': '⛺',
      'days_blocked': 90,
      'deletable': 0
    });
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
