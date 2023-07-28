class User {
  User(this.id, this.name, this.lastName, this.phone);

  final String id;
  final String name;
  final String lastName;
  final int phone;

  getId() => id;

  getName() => name;

  getLastName() => lastName;

  getPhone() => phone;
}
