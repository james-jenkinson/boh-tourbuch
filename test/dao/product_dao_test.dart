import 'package:boh_tourbuch/dao/product_dao.dart';
import 'package:boh_tourbuch/models/product.dart';
import 'package:test/test.dart';

void main() {
  late ProductDao productDao;

  setUp(() => productDao = ProductDao());

  test('fromDatabaseJson should return correct object', () {
    final Map<String, dynamic> data = {
      'id': 161,
      'order_id': 5,
      'received_date': '2011-10-05T14:48:00.000Z',
      'product_type_id': 7,
      'status': 'notOrdered'
    };

    final result = productDao.fromDatabaseJson(data);

    expect(result, isA<Product>());
    expect(result.id, 161);
    expect(result.productTypeId, 7);
    expect(result.receivedDate, DateTime.parse('2011-10-05T14:48:00.000Z'));
    expect(result.status, ProductStatus.notOrdered);
    expect(result.orderId, 5);
  });

  test('toDatabaseJson should return db map', () {
    final product = Product(
        id: 161,
        productTypeId: 7,
        status: ProductStatus.received,
        orderId: 5,
        receivedDate: DateTime.parse('2011-10-05T14:48:00.000Z'));

    final result = productDao.toDatabaseJson(product);

    expect(result, {
      'id': 161,
      'order_id': 5,
      'received_date': '2011-10-05T14:48:00.000Z',
      'product_type_id': 7,
      'status': 'received'
    });
  });
}
