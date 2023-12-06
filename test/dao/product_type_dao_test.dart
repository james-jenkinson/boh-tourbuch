import 'package:boh_tourbuch/dao/product_type_dao.dart';
import 'package:boh_tourbuch/models/product_type.dart';
import 'package:test/test.dart';

void main() {
  late ProductTypeDao productTypeDao;

  setUp(() => productTypeDao = ProductTypeDao());

  test('fromDatabaseJson should return correct object', () {
    final Map<String, dynamic> data = {
      'id': 161,
      'name': 'Zelt',
      'symbol': '⛺',
      'days_blocked': 90,
      'deletable': 1
    };

    final result = productTypeDao.fromDatabaseJson(data);

    expect(result, isA<ProductType>());
    expect(result.id, 161);
    expect(result.name, 'Zelt');
    expect(result.symbol, '⛺');
    expect(result.daysBlocked, 90);
    expect(result.deletable, true);
  });

  test('toDatabaseJson should return db map', () {
    const productType = ProductType(
        id: 161, name: 'Zelt', symbol: '⛺', daysBlocked: 90, deletable: false);

    final result = productTypeDao.toDatabaseJson(productType);

    expect(result, {
      'id': 161,
      'name': 'Zelt',
      'symbol': '⛺',
      'deletable': 0,
      'days_blocked': 90
    });
  });
}
