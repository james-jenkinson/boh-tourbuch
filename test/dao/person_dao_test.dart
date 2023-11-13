import 'package:boh_tourbuch/dao/person_dao.dart';
import 'package:boh_tourbuch/models/person.dart';
import 'package:test/test.dart';

void main() {
  late PersonDao personDao;

  setUp(() => personDao = PersonDao());

  test('fromDatabaseJson should return correct object', () {
    Map<String, dynamic> data = {
      'id': 161,
      'first_name': 'Tomislav',
      'last_name': 'Piplica',
      'blocked': 1
    };

    final result = personDao.fromDatabaseJson(data);

    expect(result, isA<Person>());
    expect(result.id, 161);
    expect(result.firstName, 'Tomislav');
    expect(result.lastName, 'Piplica');
    expect(result.blocked, true);
  });

  test('toDatabaseJson should return db map', () {
    final person = Person(
        id: 161,
        firstName: 'Tomislav',
        lastName: 'Piplica',
        blocked: false);

    final result = personDao.toDatabaseJson(person);

    expect(result, {
      'id': 161,
      'first_name': 'Tomislav',
      'last_name': 'Piplica',
      'blocked': 0
    });
  });
}
