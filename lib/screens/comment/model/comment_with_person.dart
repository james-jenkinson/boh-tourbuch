import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/comment.dart';
import '../../../models/person.dart';

part 'comment_with_person.freezed.dart';

@freezed
class CommentWithPerson with _$CommentWithPerson {
  const factory CommentWithPerson(
      {required Comment comment, required Person person}) = _CommentWithPerson;
}
