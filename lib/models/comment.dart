import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment.freezed.dart';

@freezed
class Comment with _$Comment {
  const factory Comment({
    @Default(-1) int id,
    required int personId,
    required DateTime issuedDate,
    @Default('') String content,
    @Default(false) bool commentDone,
  }) = _Comment;
}
