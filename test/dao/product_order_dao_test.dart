import 'package:boh_tourbuch/dao/product_order_dao.dart';
import 'package:boh_tourbuch/models/product_order.dart';
import 'package:test/test.dart';

void main() {
  late ProductOrderDao productOrderDao;

  setUp(() => productOrderDao = ProductOrderDao());

  test('fromDatabaseJson should return correct object', () {
    final Map<String, dynamic> data = {
      'id': 161,
      'person_id': 5,
      'last_issue_date': '2021-10-05T14:48:00.000Z',
      'product_type_id': 7,
      'status': OrderStatus.ordered.name,
      'received_date': '2011-10-05T14:48:00.000Z',
    };

    final result = productOrderDao.fromDatabaseJson(data);

    expect(result, isA<ProductOrder>());
    expect(result.id, 161);
    expect(result.personId, 5);
    expect(result.lastIssueDate, DateTime.parse('2021-10-05T14:48:00.000Z'));
    expect(result.productTypeId, 7);
    expect(result.lastReceivedDate, DateTime.parse('2011-10-05T14:48:00.000Z'));
    expect(result.status, OrderStatus.ordered);
  });

  test('toDatabaseJson should return db map', () {
    final productOrder = ProductOrder(
        id: 161,
        personId: 5,
        lastIssueDate: DateTime.parse('2021-10-05T14:48:00.000Z'),
        productTypeId: 7,
        status: OrderStatus.notOrdered,
        lastReceivedDate: DateTime.parse('2011-10-05T14:48:00.000Z'));

    final result = productOrderDao.toDatabaseJson(productOrder);

    expect(result, {
      'id': 161,
      'person_id': 5,
      'last_issue_date': '2021-10-05T14:48:00.000Z',
      'product_type_id': 7,
      'status': 'notOrdered',
      'received_date': '2011-10-05T14:48:00.000Z',
    });
  });
}
