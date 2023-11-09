import 'package:boh_tourbuch/databases/database.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import '../models/product.dart';

class ProductDao {
  final database = DatabaseInstance.databaseInstance;

  Future<int> createProduct(Product product) async {
    final Database db = await database.database;
    return db.insert(productTable, toDatabaseJson(product));
  }

  Future<List<Product>> getProductsByOrderId(int orderId) async {
    final db = await database.database;
    return (await db
            .query(productTable, where: 'order_id = ?', whereArgs: [orderId]))
        .map((product) => fromDatabaseJson(product))
        .toList();
  }

  Product fromDatabaseJson(Map<String, dynamic> data) {
    return Product(
        id: data['id'],
        orderId: data['order_id'],
        productTypeId: data['product_type_id'],
        status: data['status'],
        receivedDate: data['received_date'] == null
            ? null
            : DateTime.parse(data['received_date']));
  }

  Map<String, dynamic> toDatabaseJson(Product product) => {
        "id": product.id == -1 ? null : product.id,
        "order_id": product.orderId,
        "product_type_id": product.productTypeId,
        "status": product.status.toString(),
        "received_date": product.receivedDate?.toIso8601String()
      };
}
