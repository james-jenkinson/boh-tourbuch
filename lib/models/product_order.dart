class ProductOrder {
  int id;
  int personId;
  DateTime? lastIssueDate;
  int productTypeId;
  DateTime? lastReceivedDate;
  OrderStatus status;

  ProductOrder(
      {this.id = -1,
      required this.personId,
      this.lastIssueDate,
      required this.productTypeId,
      this.lastReceivedDate,
      required this.status});
}

enum OrderStatus { notOrdered, ordered, received }
