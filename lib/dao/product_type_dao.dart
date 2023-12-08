import 'package:sqflite_sqlcipher/sqflite.dart';

import '../databases/database.dart';
import '../models/product_type.dart';

class ProductTypeDao {
  final _database = DatabaseInstance.databaseInstance;

  Future<int> createProductType(ProductType productType) async {
    final Database db = await _database.database;
    return db.insert(productTypeTable, toDatabaseJson(productType));
  }

  Future<List<ProductType>> getProductTypes() async {
    final db = await _database.database;
    final List<Map<String, dynamic>> result = await db.query(productTypeTable);
    return result.map((e) => fromDatabaseJson(e)).toList();
  }

  Future<int> deleteProductTypeById(int id) async {
    final db = await _database.database;
    return await db.delete(productTypeTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateProductType(ProductType productType) async {
    final db = await _database.database;
    return await db.update(productTypeTable, toDatabaseJson(productType),
        where: 'id = ?', whereArgs: [productType.id]);
  }

  ProductType fromDatabaseJson(Map<String, dynamic> data) {
    return ProductType(
        id: int.parse(data['id'].toString()),
        name: data['name'].toString(),
        symbol: data['symbol'].toString(),
        daysBlocked: int.parse(data['days_blocked'].toString()),
        deletable: data['deletable'] == 1);
  }

  Map<String, dynamic> toDatabaseJson(ProductType productType) => {
        'id': productType.id == -1 ? null : productType.id,
        'name': productType.name,
        'symbol': productType.symbol,
        'days_blocked': productType.daysBlocked,
        'deletable': productType.deletable ? 1 : 0
      };
}
