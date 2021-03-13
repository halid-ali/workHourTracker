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

  static Future<UserModel> getUser(String userId) async {
    return _dbProvider.database
        .collection('users')
        .doc(userId)
        .get()
        .then<UserModel>((value) {
      return UserModel.fromJson(userId, value.data());
    });
  }

  static void addUser(UserModel user) {
    _dbProvider.database
        .collection('users')
        .doc()
        .set(user.toJson())
        .then((value) {})
        .catchError((error) => print(error));
  }

  static void updateUser(UserModel user) {
    _dbProvider.database
        .collection('users')
        .doc(user.id)
        .update(user.toJson())
        .then((value) {})
        .catchError((error) => print(error));
  }

  static void deleteUser(String id) {
    _dbProvider.database
        .collection('users')
        .doc(id)
        .delete()
        .then((value) {})
        .catchError((error) => print(error));
  }
}
