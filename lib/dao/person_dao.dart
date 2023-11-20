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

  Future<int> updatePerson(Person person) async {
    final Database db = await _database.database;
    return await db.update(personTable, toDatabaseJson(person),
        where: 'id = ?', whereArgs: [person.id]);
  }

  Future<List<Person>> getAllPersons() async {
    final db = await _database.database;
    final List<Map<String, dynamic>> result =
        await db.query(personTable, orderBy: 'name COLLATE NOCASE ASC');
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
    final blockedSince = data['blocked_since'];
    return Person(
        id: int.parse(data['id'].toString()),
        name: data['name'].toString().trim(),
        blockedSince: blockedSince != null
            ? DateTime.parse(blockedSince.toString())
            : null,
        comment: data['comment'].toString().trim());
  }

  Map<String, dynamic> toDatabaseJson(Person person) => {
        'id': person.id == -1 ? null : person.id,
        'name': person.name,
        'blocked_since': person.blockedSince?.toIso8601String(),
        'comment': person.comment
      };
}
