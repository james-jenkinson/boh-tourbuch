import 'package:flutter/foundation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../databases/database.dart';
import '../models/person.dart';

class PersonDao {
  final _database = DatabaseInstance.databaseInstance;

  Future<int> createPerson(Person person) async {
    final Database db = await _database.database;
    return db.insert(personTable, toDatabaseJson(person));
  }

  Future<List<Person>> getAllPersons() async {
    final db = await _database.database;
    final List<Map<String, dynamic>> result = await db.query(personTable);
    return result.map((e) => fromDatabaseJson(e)).toList();
  }

  Future<Person?> getPersonById(int id) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> result =
        await db.query(personTable, where: 'id = ?', whereArgs: [id]);
    if (result.length == 1) {
      return fromDatabaseJson(result.first);
    } else {
      if (kDebugMode) {
        print('0 or more than 1 persons found for id $id');
      }
      return null;
    }
  }

  Person fromDatabaseJson(Map<String, dynamic> data) {
    return Person(
        id:  int.parse(data['id'].toString()),
        firstName: data['first_name'].toString(),
        lastName: data['last_name'].toString(),
        blocked: data['blocked'] == 1);
  }

  Map<String, dynamic> toDatabaseJson(Person person) => {
        'id': person.id == -1 ? null : person.id,
        'first_name': person.firstName,
        'last_name': person.lastName,
        'blocked':  person.blocked ? 1 : 0
      };
}
