import 'package:boh_tourbuch/dao/product_type_dao.dart';
import 'package:boh_tourbuch/models/product_type.dart';
import 'package:test/test.dart';

void main() {
  late ProductTypeDao productTypeDao;

  setUp(() => productTypeDao = ProductTypeDao());

  test('fromDatabaseJson should return correct object', () {
    Map<String, dynamic> data = {
      'id': 161,
      'name': 'Zelt',
      'material_icon_identifier': 'tent'
    };

    final result = productTypeDao.fromDatabaseJson(data);

    expect(result, isA<ProductType>());
    expect(result.id, 161);
    expect(result.name, 'Zelt');
    expect(result.materialIconIdentifier, 'tent');
  });

  test('toDatabaseJson should return db map', () {
    final productType = ProductType(
        id: 161,
        name: 'Zelt',
        materialIconIdentifier: 'tent');

    final result = productTypeDao.toDatabaseJson(productType);

    expect(result, {
      'id': 161,
      'name': 'Zelt',
      'material_icon_identifier': 'tent'
    });
  });
}
