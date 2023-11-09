import 'package:boh_tourbuch/dao/comment_dao.dart';

import '../models/comment.dart';

class CommentRepository {
  final _commentDao = CommentDao();

  Future<int> createComment(Comment comment) =>
      _commentDao.createComment(comment);

  Future<Comment?> getCommentById(int id) => _commentDao.getCommentById(id);

  Future<Comment?> getCommentByOrderId(int orderId) => _commentDao.getCommentByOrderId(orderId);

  Future<List<Comment>> getAllComments() => _commentDao.getAllComments();
}
