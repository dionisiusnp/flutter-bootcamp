import 'dart:convert';

class User {
  int? id;
  String? name;
  String? email;
  String? password;
  DateTime? created_at;

  User({this.id, this.name, this.email, this.password, this.created_at});
  factory User.fromJson(Map<String, dynamic> map) {
    return User(
        id: map["id"],
        name: map["name"],
        email: map["email"],
        password: map["password"],
        created_at: DateTime.parse(map["created_at"]));
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "password": password,
      "created_at": created_at?.toIso8601String()
    };
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, password: $password, created_at: $created_at}';
  }
}

List<User> UserFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<User>.from((data as List).map((item) => User.fromJson(item)));
}

String userToJson(User data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}