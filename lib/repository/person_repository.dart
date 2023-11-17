import '../dao/person_dao.dart';
import '../models/person.dart';

class PersonRepository {
  final _personDao = PersonDao();

  Future<int> createPerson(Person person) => _personDao.createPerson(person);

  Future<Person?> getPersonById(int id) => _personDao.getPersonById(id);

  Future<List<Person>> getAllPersons() => _personDao.getAllPersons();
}
