import 'package:boh_tourbuch/databases/person_database.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../models/person.dart';

class PersonDao {
  final personDatabase = PersonDatabase.personDatabase;

  Future<int> createPerson(Person person) async {
    final Database db = await personDatabase.database;
    return db.insert(personTable, person.toDatabaseJson());
  }

  Future<List<Person>> getPersons() async {
    final db = await personDatabase.database;
    List<Map<String, dynamic>> result = await db.query(personTable, columns: ['id', 'name'], where: 'true = true');
    return result.map((e) => Person.fromDatabaseJson(e)).toList();
  }
}