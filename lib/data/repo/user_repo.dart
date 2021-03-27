import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_hour_tracker/data/db_provider.dart';
import 'package:work_hour_tracker/data/model/user_model.dart';

class UserRepository {
  static final _dbProvider = DbProvider.provider;

  static Stream<QuerySnapshot> getUsers() {
    return _dbProvider.database
        .collection('users')
        .snapshots(includeMetadataChanges: true);
  }

  static Future<UserModel> getUser(String username) async {
    return _dbProvider.database
        .collection('users')
        .get()
        .then<UserModel>((value) => value.docs
            .map((e) => UserModel.fromJson(e.id, e.data()))
            .where((e) => e.username == username)
            .first)
        .catchError((error) => null);
  }

  static Future<String> addUser(UserModel user) async {
    String id;
    await _dbProvider.database
        .collection('users')
        .add(user.toJson())
        .then((value) => id = value.id);

    return id;
  }

  static Future<void> updateUser(UserModel user) async {
    await _dbProvider.database
        .collection('users')
        .doc(user.id)
        .update(user.toJson());
  }

  static Future<void> deleteUser(String id) async {
    await _dbProvider.database.collection('users').doc(id).delete();
  }
}
