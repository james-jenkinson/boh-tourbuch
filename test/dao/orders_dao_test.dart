import 'package:boh_tourbuch/dao/orders_dao.dart';
import 'package:boh_tourbuch/models/order.dart';
import 'package:test/test.dart';

void main() {
  late OrdersDao ordersDao;

  setUp(() => ordersDao = OrdersDao());

  test('fromDatabaseJson should return correct object', () {
    Map<String, dynamic> data = {
      'id': 161,
      'person_id': 12,
      'order_date': '2011-10-05T14:48:00.000Z',
      'comment_id': null
    };

    final result = ordersDao.fromDatabaseJson(data);

    expect(result, isA<Order>());
    expect(result.id, 161);
    expect(result.personId, 12);
    expect(result.commentId, null);
    expect(result.orderDate, DateTime.parse('2011-10-05T14:48:00.000Z'));
  });

  test('toDatabaseJson should return db map', () {
    final order = Order(
        personId: 12,
        orderDate: DateTime.parse('2011-10-05T14:48:00.000Z'),
        id: 161,
        commentId: 11);

    final result = ordersDao.toDatabaseJson(order);

    expect(result, {
      'id': 161,
      'person_id': 12,
      'order_date': '2011-10-05T14:48:00.000Z',
      'comment_id': 11
    });
  });
}
