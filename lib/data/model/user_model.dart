class User {
  final int id;
  final String username;
  final String password;

  User({
    this.id,
    this.username,
    this.password,
  });

  factory User.fromJson(Map<String, dynamic> data) => User(
        id: data['id'],
        username: data['username'],
        password: data['password'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'password': password,
      };
}
