class Order {
  int id;
  int personId;
  DateTime orderDate;
  int? commentId;

  Order({this.id = -1, required this.personId, required this.orderDate, this.commentId});
}
