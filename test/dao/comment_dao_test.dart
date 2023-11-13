import 'package:boh_tourbuch/dao/comment_dao.dart';
import 'package:boh_tourbuch/models/comment.dart';
import 'package:test/test.dart';

void main() {
  late CommentDao commentDao;

  setUp(() => commentDao = CommentDao());

  test('fromDatabaseJson should return correct object', () {
    Map<String, dynamic> data = {
      'id': 161,
      'content': 'this is a comment',
      'done': 0,
      'order_id': 5
    };

    final result = commentDao.fromDatabaseJson(data);

    expect(result, isA<Comment>());
    expect(result.id, 161);
    expect(result.content, 'this is a comment');
    expect(result.done, false);
    expect(result.orderID, 5);
  });

  test('toDatabaseJson should return db map', () {
    final comment = Comment(
        id: 161,
        content: 'another comment',
        done: true,
        orderID: 5);

    final result = commentDao.toDatabaseJson(comment);

    expect(result, {
      'id': 161,
      'content': 'another comment',
      'done': 1,
      'order_id': 5
    });
  });
}
