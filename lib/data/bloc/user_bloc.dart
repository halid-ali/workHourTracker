import 'dart:async';

import 'package:work_hour_tracker/data/model/user_model.dart';
import 'package:work_hour_tracker/data/repo/user_repo.dart';

class UserBloc {
  final _userRepository = UserRepository();
  final _userController = StreamController<List<User>>.broadcast();

  Stream<List<User>> get users => _userController.stream;

  UserBloc() {
    getUsers();
  }

  Future<void> getUsers() async {
    _userController.sink.add(
      await _userRepository.getUsers(),
    );
  }

  Future<void> addUser(User user) async {
    await _userRepository.addUser(user);
    await getUsers();
  }

  Future<void> updateUser(User user) async {
    await _userRepository.updateUser(user);
    await getUsers();
  }

  Future<void> deleteUser(int id) async {
    await _userRepository.deleteUser(id);
    await getUsers();
  }

  void dispose() {
    _userController.close();
  }
}
