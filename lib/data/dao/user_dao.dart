import 'package:work_hour_tracker/data/database.dart';
import 'package:work_hour_tracker/data/model/user_model.dart';

class UserDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> addUser(User user) async {
    final db = await dbProvider.database;
    var result = await db.insert('users', user.toJson());

    return result;
  }

  Future<List<User>> getUsers() async {
    final db = await dbProvider.database;
    var result = await db.query('users');

    List<User> users =
        result.isNotEmpty ? result.map((u) => User.fromJson(u)).toList() : [];
    return users;
  }

  Future<User> getUser(int id) async {
    final db = await dbProvider.database;
    var result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: <dynamic>[id],
    );

    return result.isNotEmpty ? User.fromJson(result.first) : null;
  }

  Future<int> updateUser(User user) async {
    final db = await dbProvider.database;
    var result = await db.update(
      'users',
      user.toJson(),
      where: 'id = ?',
      whereArgs: <int>[user.id],
    );

    return result;
  }

  Future<int> deleteUser(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: <dynamic>[id],
    );

    return result;
  }
}
