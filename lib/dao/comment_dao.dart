import 'package:flutter/foundation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../databases/database.dart';
import '../models/comment.dart';

class CommentDao {
  final _database = DatabaseInstance.databaseInstance;

  Future<int> createComment(Comment comment) async {
    final Database db = await _database.database;
    return db.insert(commentTable, toDatabaseJson(comment));
  }

  Future<int> updateComment(Comment comment) async {
    final Database db = await _database.database;
    return await db.update(commentTable, toDatabaseJson(comment),
        where: 'id = ?', whereArgs: [comment.id]);
  }

  Future<Comment?> getCommentById(int id) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> result =
        await db.query(commentTable, where: 'id = ?', whereArgs: [id]);
    if (result.length == 1) {
      return fromDatabaseJson(result.first);
    } else {
      if (kDebugMode) {
        print('0 or more than 1 comments found for id $id');
      }
      return null;
    }
  }

  Future<List<Comment>> getCommentsByPersonId(int personId) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> result = await db
        .query(commentTable, where: 'person_id = ?', whereArgs: [personId]);
    return result.map((e) => fromDatabaseJson(e)).toList();
  }

  Future<void> deleteCommentsByPersonId(int personId) async {
    final db = await _database.database;
    await db
        .delete(commentTable, where: 'person_id = ?', whereArgs: [personId]);
  }

  Future<List<Comment>> getAllCommentsByStatus(bool commentOpen) async {
    final db = await _database.database;
    final List<Map<String, dynamic>> result = await db.query(commentTable,
        where: 'comment_done != ?',
        whereArgs: [commentOpen ? 1 : 0],
        orderBy: 'issued_date asc',
        limit: 1000);
    return result.map((e) => fromDatabaseJson(e)).toList();
  }

  Comment fromDatabaseJson(Map<String, dynamic> data) {
    return Comment(
        id: int.parse(data['id'].toString()),
        personId: int.parse(data['person_id'].toString()),
        issuedDate: DateTime.parse(data['issued_date'].toString()),
        content: data['content'].toString(),
        commentDone: data['comment_done'] == 1);
  }

  Map<String, dynamic> toDatabaseJson(Comment comment) => {
        'id': comment.id == -1 ? null : comment.id,
        'person_id': comment.personId,
        'issued_date': comment.issuedDate.toIso8601String(),
        'content': comment.content,
        'comment_done': comment.commentDone ? 1 : 0
      };
}
