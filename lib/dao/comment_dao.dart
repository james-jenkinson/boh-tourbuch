import 'package:boh_tourbuch/models/comment.dart';
import 'package:flutter/foundation.dart';

import '../databases/database.dart';

class CommentDao {
  final database = DatabaseInstance.databaseInstance;

  Future<int> createComment(Comment comment) async {
    final db = await database.database;
    return db.insert(commentTable, toDatabaseJson(comment));
  }

  Future<List<Comment>> getAllComments() async {
    final db = await database.database;
    return (await db.query(commentTable))
        .map((comment) => fromDatabaseJson(comment))
        .toList();
  }

  Future<Comment?> getCommentById(int id) async {
    final db = await database.database;
    List<Map<String, dynamic>> result =
        await db.query(commentTable, where: 'id = ?', whereArgs: [id]);
    if (result.length == 1) {
      return fromDatabaseJson(result.first);
    } else {
      if (kDebugMode) {
        print("0 or more than 1 comments found for id $id");
      }
      return null;
    }
  }

  Future<Comment?> getCommentByOrderId(int orderId) async {
    final db = await database.database;
    List<Map<String, dynamic>> result = await db
        .query(commentTable, where: 'order_id = ?', whereArgs: [orderId]);
    if (result.length == 1) {
      return fromDatabaseJson(result.first);
    } else {
      if (kDebugMode) {
        print("0 or more than 1 comments found for id $orderId");
      }
      return null;
    }
  }

  Comment fromDatabaseJson(Map<String, dynamic> data) {
    return Comment(
        id: data['id'],
        content: data['content'],
        done: data['done'] == 1,
        orderID: data['order_id']);
  }

  Map<String, dynamic> toDatabaseJson(Comment comment) => {
        "id": comment.id == -1 ? null : comment.id,
        "content": comment.content,
        "done": comment.done ? 1 : 0,
        "order_id": comment.orderID
      };
}
