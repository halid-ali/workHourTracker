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

  static Future<UserModel> getUser(String id) async {
    return _dbProvider.database
        .collection('users')
        .doc(id)
        .get()
        .then<UserModel>((value) {
      return UserModel.fromJson(id, value.data());
    });
  }

  static Future<void> addUser(UserModel user) async {
    await _dbProvider.database.collection('users').doc().set(user.toJson());
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
