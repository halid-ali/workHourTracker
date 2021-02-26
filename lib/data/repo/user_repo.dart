import 'package:work_hour_tracker/data/dao/user_dao.dart';
import 'package:work_hour_tracker/data/model/user_model.dart';

class UserRepository {
  final userDao = UserDao();

  Future<List<User>> getUsers() => userDao.getUsers();

  Future<User> getUser(int id) => userDao.getUser(id);

  Future addUser(User user) => userDao.addUser(user);

  Future updateUser(User user) => userDao.updateUser(user);

  Future deleteUser(int id) => userDao.deleteUser(id);
}
