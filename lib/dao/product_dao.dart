import 'package:sqflite_sqlcipher/sqflite.dart';

import '../databases/database.dart';
import '../models/product.dart';

class ProductDao {
  final _database = DatabaseInstance.databaseInstance;

  Future<int> createProduct(Product product) async {
    final Database db = await _database.database;
    return db.insert(productTable, toDatabaseJson(product));
  }

  Future<List<Product>> getProductsByOrderId(int orderId) async {
    final db = await _database.database;
    return (await db
            .query(productTable, where: 'order_id = ?', whereArgs: [orderId]))
        .map((product) => fromDatabaseJson(product))
        .toList();
  }

  Product fromDatabaseJson(Map<String, dynamic> data) {
    return Product(
        id: int.parse(data['id'].toString()),
        orderId: int.parse(data['order_id'].toString()),
        productTypeId: int.parse(data['product_type_id'].toString()),
        status: ProductStatus.values.byName(data['status'].toString()),
        receivedDate: data['received_date'] == null
            ? null
            : DateTime.parse(data['received_date'].toString()));
  }

  Map<String, dynamic> toDatabaseJson(Product product) => {
        'id': product.id == -1 ? null : product.id,
        'order_id': product.orderId,
        'product_type_id': product.productTypeId,
        'status': product.status.name,
        'received_date': product.receivedDate?.toIso8601String()
      };
}
