class Order {
  int id;
  int personId;
  DateTime createDate;
  String comment;
  bool commentDone;

  Order(
      {this.id = -1,
      required this.personId,
      required this.createDate,
      this.comment = '',
      this.commentDone = false});
}
