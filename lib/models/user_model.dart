class User {
  final String id;
  late String firstName;
  late String lastName;
  late String email;
  late String password;
  late String role;

  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.password,
      required this.role});

  factory User.fromJson(Map<String, dynamic> user) {
    return User(
        id: user["_id"],
        firstName: user['firstName'],
        lastName: user["lastName"],
        email: user["email"],
        password: user["password"],
        role: user["role"]);
  }
}
