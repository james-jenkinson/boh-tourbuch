import 'package:boh_tourbuch/dao/person_dao.dart';
import 'package:boh_tourbuch/models/person.dart';
import 'package:test/test.dart';

void main() {
  late PersonDao personDao;

  setUp(() => personDao = PersonDao());

  test('fromDatabaseJson should return correct object', () {
    final Map<String, dynamic> data = {
      'id': 161,
      'name': 'Tomislav Piplica',
      'blocked_since': '2011-10-05T14:48:00.000Z',
      'comment': 'abc'
    };

    final result = personDao.fromDatabaseJson(data);

    expect(result, isA<Person>());
    expect(result.id, 161);
    expect(result.name, 'Tomislav Piplica');
    expect(result.blockedSince, DateTime.parse('2011-10-05T14:48:00.000Z'));
    expect(result.comment, 'abc');
  });

  test('toDatabaseJson should return db map', () {
    const person = Person(
      id: 161,
      name: 'Tomislav Piplica',
      blockedSince: null,
    );

    final result = personDao.toDatabaseJson(person);

    expect(result, {
      'id': 161,
      'name': 'Tomislav Piplica',
      'blocked_since': null,
      'comment': ''
    });
  });
}
