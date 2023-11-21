class Person {
  int id;
  String name;
  DateTime? blockedSince;
  String comment;

  Person(
      {this.id = -1,
      required this.name,
      this.blockedSince,
      this.comment = ''});
}
