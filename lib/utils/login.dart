import 'package:work_hour_tracker/utils/session_manager.dart';

class Login {
  static Future<bool> isLogged() async {
    return SessionManager.containsKey(SessionKey.userId);
  }

  static void logout() => SessionManager.clear();

  static Future<String> getUserId() async {
    return SessionManager.read(SessionKey.userId);
  }

  static Future<String> getUsername() async {
    return SessionManager.read(SessionKey.username);
  }
}

class SessionData {
  Future<bool> get isLogged async =>
      SessionManager.containsKey(SessionKey.userId);
  Future<String> get userId async => SessionManager.read(SessionKey.userId);
  Future<String> get username async => SessionManager.read(SessionKey.username);
}
