class Comment {
  int id;
  int personId;
  DateTime issuedDate;
  String content;
  bool commentDone;

  Comment(
      {this.id = -1,
      required this.personId,
      required this.issuedDate,
      this.content = '',
      this.commentDone = false});
}
