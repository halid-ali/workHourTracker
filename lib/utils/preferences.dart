import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Preferences {
  static FlutterSecureStorage get _sp {
    return FlutterSecureStorage();
  }

  static Future<bool> contains(String key) async {
    return await _sp.containsKey(key: key);
  }

  static Future<void> write(String key, String value) async {
    await _sp.write(key: key, value: value);
  }

  static Future<String> read(String key) async {
    return await _sp.read(key: key);
  }

  static Future<void> clear() async {
    await _sp.deleteAll();
  }
}
