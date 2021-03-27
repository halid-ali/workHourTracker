import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:universal_html/prefer_universal/html.dart';
import 'package:work_hour_tracker/utils/platform_info.dart';

class SessionManager {
  SessionManager._internal();
  static final SessionManager instance = SessionManager._internal();
  static final FlutterSecureStorage _fss = FlutterSecureStorage();

  factory SessionManager() => instance;

  static Future<bool> containsKey(SessionKey key) async {
    if (PlatformInfo.isWeb())
      return window.localStorage.containsKey(key.value);
    else
      return await _fss.containsKey(key: key.value);
  }

  static Future<void> write(SessionKey key, String value) async {
    if (PlatformInfo.isWeb())
      window.localStorage[key.value] = value;
    else
      await _fss.write(key: key.value, value: value);
  }

  static Future<String> read(SessionKey key) async {
    if (PlatformInfo.isWeb())
      return window.localStorage[key.value];
    else
      return await _fss.read(key: key.value);
  }

  static Future<void> clear() async {
    if (PlatformInfo.isWeb())
      window.localStorage.clear();
    else
      await _fss.deleteAll();
  }
}

enum SessionKey { settingsId, userId, username }

extension ParseToString on SessionKey {
  String get value => this.toString().split('.').last;
}
