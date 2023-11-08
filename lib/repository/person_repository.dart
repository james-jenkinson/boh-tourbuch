import 'package:boh_tourbuch/dao/person_dao.dart';

import '../models/person.dart';

class PersonRepository {
  final personDao = PersonDao();

  Future createPerson(Person person) => personDao.createPerson(person);

  Future<List<Person>> getAllPersons() => personDao.getPersons();
}