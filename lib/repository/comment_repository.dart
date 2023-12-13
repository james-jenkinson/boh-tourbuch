import '../dao/comment_dao.dart';
import '../models/comment.dart';

class CommentRepository {
  final _commentDao = CommentDao();

  Future<int> createComment(Comment comment) =>
      _commentDao.createComment(comment);

  Future<int> updateComment(Comment comment) =>
      _commentDao.updateComment(comment);

  Future<Comment?> getCommentById(int id) => _commentDao.getCommentById(id);

  Future<List<Comment>> getCommentsByPersonId(int personId) =>
      _commentDao.getCommentsByPersonId(personId);

  Future<void> deleteCommentsByPersonId(int personId) =>
      _commentDao.deleteCommentsByPersonId(personId);

  Future<void> deleteCommentById(int commentId) =>
      _commentDao.deleteCommentsById(commentId);

  Future<List<Comment>> getAllCommentsByStatus(bool commentOpen) =>
      _commentDao.getAllCommentsByStatus(commentOpen);
}
