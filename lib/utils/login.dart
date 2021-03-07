import 'package:work_hour_tracker/utils/platform_info.dart';
import 'package:work_hour_tracker/utils/web_storage.dart';

import 'preferences.dart';

class Login {
  static bool isLogged() {
    bool result = false;

    if (PlatformInfo.isWeb()) {
      result = WebStorage.instance.userId != null;
    } else {
      Preferences.contains('userId').then((value) => result = value);
    }

    return result;
  }

  static void logout() {
    if (PlatformInfo.isWeb()) {
      WebStorage.instance.userId = null;
    } else {
      Preferences.clear();
    }
  }

  static String getUsername() {
    String username;
    if (PlatformInfo.isWeb()) {
      username = WebStorage.instance.username;
    } else {
      Preferences.read('username').then((value) => username = value);
    }

    return username;
  }

  static String getUserId() {
    String userId;
    if (PlatformInfo.isWeb()) {
      userId = WebStorage.instance.userId;
    } else {
      Preferences.read('userId').then((value) => userId = value);
    }

    return userId;
  }
}
