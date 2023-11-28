import 'package:boh_tourbuch/dao/comment_dao.dart';
import 'package:boh_tourbuch/models/comment.dart';
import 'package:test/test.dart';

void main() {
  late CommentDao commentsDao;

  setUp(() => commentsDao = CommentDao());

  test('fromDatabaseJson should return correct object', () {
    final Map<String, dynamic> data = {
      'id': 161,
      'person_id': 12,
      'issued_date': '2011-10-05T14:48:00.000Z',
      'content': '',
      'comment_done': 0
    };

    final result = commentsDao.fromDatabaseJson(data);

    expect(result, isA<Comment>());
    expect(result.id, 161);
    expect(result.personId, 12);
    expect(result.content, '');
    expect(result.commentDone, false);
    expect(result.issuedDate, DateTime.parse('2011-10-05T14:48:00.000Z'));
  });

  test('toDatabaseJson should return db map', () {
    final order = Comment(
        personId: 12,
        issuedDate: DateTime.parse('2011-10-05T14:48:00.000Z'),
        id: 161,
        content: 'juhu',
        commentDone: true);

    final result = commentsDao.toDatabaseJson(order);

    expect(result, {
      'id': 161,
      'person_id': 12,
      'issued_date': '2011-10-05T14:48:00.000Z',
      'content': 'juhu',
      'comment_done': 1
    });
  });
}
