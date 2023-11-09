import 'package:boh_tourbuch/dao/comment_dao.dart';

import '../models/comment.dart';

class CommentRepository {
  final CommentDao commentDao = CommentDao();

  Future<int> createComment(Comment comment) =>
      commentDao.createComment(comment);

  Future<Comment?> getCommentById(int id) => commentDao.getCommentById(id);

  Future<Comment?> getCommentByOrderId(int orderId) => commentDao.getCommentByOrderId(orderId);

  Future<List<Comment>> getAllComments() => commentDao.getAllComments();
}
