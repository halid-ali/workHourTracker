import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static Future<SharedPreferences> get _sp async {
    return await SharedPreferences.getInstance();
  }

  static Future<bool> contains(String key) async {
    return await _sp.then<bool>((sp) => sp.containsKey(key));
  }

  static Future<void> setInt(String key, int value) async {
    await _sp.then((sp) => sp.setInt(key, value));
  }

  static Future<int> getInt(String key) async {
    return await _sp.then<int>((sp) => sp.getInt(key));
  }

  static Future<void> setString(String key, String value) async {
    await _sp.then((sp) => sp.setString(key, value));
  }

  static Future<String> getString(String key) async {
    return await _sp.then<String>((sp) => sp.getString(key));
  }

  static Future<void> clear() async {
    await _sp.then((sp) => sp.clear());
  }
}
