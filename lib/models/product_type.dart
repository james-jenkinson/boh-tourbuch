class ProductType {
  int id;
  String name;
  String symbol;
  int daysBlocked;
  bool deletable;

  ProductType(
      {this.id = -1,
      required this.name,
      required this.symbol,
      required this.daysBlocked,
      required this.deletable});
}
