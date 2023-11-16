import 'package:boh_tourbuch/databases/database.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../models/order.dart';

class OrdersDao {
  final _database = DatabaseInstance.databaseInstance;

  Future<int> createOrder(Order order) async {
    final Database db = await _database.database;
    return db.insert(orderTable, toDatabaseJson(order));
  }

  Future<Order?> getOrderById(int id) async {
    final db = await _database.database;
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
    final db = await _database.database;
    List<Map<String, dynamic>> result = await db.query(orderTable,
        where: 'person_id = ?',
        whereArgs: [personId],
        orderBy: 'order_date desc');
    return result.map((e) => fromDatabaseJson(e)).toList();
  }

  Future<Iterable<Order>> getAllOrdersWithComment(bool commentOpen) async {
    final db = await _database.database;
    List<Map<String, dynamic>> result = await db.query(orderTable,
        where:
            '(comment IS NOT NULL OR comment IS NOT "") AND comment_done != ?',
        whereArgs: [commentOpen ? 1 : 0],
        orderBy: 'order_date desc',
        limit: 1000);
    return result.map((e) => fromDatabaseJson(e));
  }

  Order fromDatabaseJson(Map<String, dynamic> data) {
    return Order(
        id: data['id'],
        personId: data['person_id'],
        orderDate: DateTime.parse(data['order_date']),
        comment: data['comment'],
        commentDone: data['comment_done'] == 1);
  }

  Map<String, dynamic> toDatabaseJson(Order order) => {
        "id": order.id == -1 ? null : order.id,
        'person_id': order.personId,
        'order_date': order.orderDate.toIso8601String(),
        'comment': order.comment,
        'comment_done': order.commentDone ? 1 : 0
      };
}
