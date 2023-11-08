class Person {
  int id = -1;
  String name;

  Person({this.id = -1, required this.name});

  factory Person.fromDatabaseJson(Map<String, dynamic> data) =>
      Person( id: data['id'], name: data['name']);

  Map<String, dynamic> toDatabaseJson() => {"name": name};
}
