class User {
  final String id;
  final String name;
  final String email;
  final String role;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.role});

  factory User.fromJson(Map<String, dynamic> user) {
    return User(
        id: user['_id'],
        name: user["name"],
        email: user["email"],
        role: user["role"]);
  }
}
