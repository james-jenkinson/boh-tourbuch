import 'package:boh_tourbuch/databases/database.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../models/order.dart';

class OrdersDao {
  final database = DatabaseInstance.databaseInstance;

  Future<int> createOrder(Order order) async {
    final Database db = await database.database;
    return db.insert(orderTable, toDatabaseJson(order));
  }

  Future<Order?> getOrderById(int id) async {
    final db = await database.database;
    List<Map<String, dynamic>> result =
        await db.query(orderTable, where: 'id = ?', whereArgs: [id]);
    if (result.length == 1) {
      return fromDatabaseJson(result.first);
    } else {
      if (kDebugMode) {
        print("0 or more than 1 orders found for id $id");
      }
      return null;
    }
  }

  Future<List<Order>> getOrdersByPersonId(int personId) async {
    final db = await database.database;
    List<Map<String, dynamic>> result = await db
        .query(orderTable, where: 'person_id = ?', whereArgs: [personId]);
    return result.map((e) => fromDatabaseJson(e)).toList();
  }

  Order fromDatabaseJson(Map<String, dynamic> data) {
    return Order(
        id: data['id'],
        personId: data['person_id'],
        orderDate: DateTime.parse(data['order_date']),
        commentId: data['comment_id']);
  }

  Map<String, dynamic> toDatabaseJson(Order order) => {
        "id": order.id == -1 ? null : order.id,
        'person_id': order.personId,
        'order_date': order.orderDate.toIso8601String(),
        'comment_id': order.commentId
      };
}
