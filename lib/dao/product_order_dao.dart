import 'package:sqflite_sqlcipher/sqflite.dart';

import '../databases/database.dart';
import '../models/product_order.dart';

class ProductOrderDao {
  final _database = DatabaseInstance.databaseInstance;

  Future<int> createProductOrder(ProductOrder productOrder) async {
    final Database db = await _database.database;
    return db.insert(productOrderTable, toDatabaseJson(productOrder));
  }

  Future<List<ProductOrder>> getProductOrdersByPersonId(int personId) async {
    final db = await _database.database;
    return (await db.query(productOrderTable,
            where: 'person_id = ?', whereArgs: [personId]))
        .map((productOrder) => fromDatabaseJson(productOrder))
        .toList();
  }

  Future<List<ProductOrder>> getAllByStatusAndType(
      OrderStatus status, List<int> productIds) async {
    final db = await _database.database;
    return (await db.query(productOrderTable,
            where:
                'status = ? and product_type_id IN (${productIds.join(',')})',
            whereArgs: [status.name]))
        .map((productOrder) => fromDatabaseJson(productOrder))
        .toList();
  }

  Future<int> updateProductOrder(ProductOrder productOrder) async {
    final Database db = await _database.database;
    return await db.update(productOrderTable, toDatabaseJson(productOrder),
        where: 'id = ?', whereArgs: [productOrder.id]);
  }

  ProductOrder fromDatabaseJson(Map<String, dynamic> data) {
    return ProductOrder(
      id: int.parse(data['id'].toString()),
      personId: int.parse(data['person_id'].toString()),
      lastIssueDate: data['last_issue_date'] == null
          ? null
          : DateTime.parse(data['last_issue_date'].toString()),
      productTypeId: int.parse(data['product_type_id'].toString()),
      lastReceivedDate: data['received_date'] == null
          ? null
          : DateTime.parse(data['received_date'].toString()),
      status: OrderStatus.values.byName(data['status'].toString()),
    );
  }

  Map<String, dynamic> toDatabaseJson(ProductOrder productOrder) => {
        'id': productOrder.id == -1 ? null : productOrder.id,
        'person_id': productOrder.personId,
        'last_issue_date': productOrder.lastIssueDate?.toIso8601String(),
        'product_type_id': productOrder.productTypeId,
        'received_date': productOrder.lastReceivedDate?.toIso8601String(),
        'status': productOrder.status.name
      };
}
