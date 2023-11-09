class Product {
  int id;
  int orderId;
  int productTypeId;
  ProductStatus status;
  DateTime? receivedDate;

  Product(
      {this.id = -1,
      required this.orderId,
      required this.productTypeId,
      required this.status,
      this.receivedDate});
}

enum ProductStatus { ordered, received, notOrdered }
