class Person {
  int id;
  String firstName;
  String lastName;
  bool blocked = false;

  Person(
      {this.id = -1,
      required this.firstName,
      required this.lastName,
      this.blocked = false});
}
