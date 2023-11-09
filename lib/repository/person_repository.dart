import 'package:boh_tourbuch/dao/person_dao.dart';

import '../models/person.dart';

class PersonRepository {
  final personDao = PersonDao();

  Future<int> createPerson(Person person) => personDao.createPerson(person);

  Future<Person?> getPersonById(int id) => personDao.getPersonById(id);

  Future<List<Person>> getAllPersons() => personDao.getAllPersons();
}
