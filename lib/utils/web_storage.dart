import 'package:universal_html/prefer_universal/html.dart';

class WebStorage {
  WebStorage._internal();

  static final WebStorage instance = WebStorage._internal();

  factory WebStorage() {
    return instance;
  }

  String get userId => window.localStorage['userId'];

  set userId(String sid) => (sid == null)
      ? window.localStorage.remove('userId')
      : window.localStorage['userId'] = sid;
}
