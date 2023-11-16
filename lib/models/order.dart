class Order {
  int id;
  int personId;
  DateTime orderDate;
  String comment;
  bool commentDone;

  Order(
      {this.id = -1,
      required this.personId,
      required this.orderDate,
      this.comment = '',
      this.commentDone = false});
}
