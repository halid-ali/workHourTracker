class UserModel {
  final String id;
  final String username;
  final String password;
  final String email;

  UserModel({
    this.id,
    this.username,
    this.password,
    this.email,
  });

  factory UserModel.fromJson(String id, Map<String, dynamic> data) => UserModel(
        id: id,
        username: data['username'] as String,
        password: data['password'] as String,
        email: data['email'] as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'username': username,
        'password': password,
        'email': email,
      };
}
