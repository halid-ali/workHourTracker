import 'package:flutter/material.dart';
import 'package:work_hour_tracker/generated/l10n.dart';
import 'package:work_hour_tracker/screens/login_screen.dart';
import 'package:work_hour_tracker/screens/main_screen.dart';
import 'package:work_hour_tracker/screens/register_screen.dart';
import 'package:work_hour_tracker/screens/settings/settings_screen.dart';

class RouteGenerator {
  static const homePage = '/';
  static const loginPage = '/login';
  static const registerPage = '/register';
  static const settingsPage = '/settings';

  const RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute<MainScreen>(
          builder: (_) => MainScreen(),
        );
      case loginPage:
        return MaterialPageRoute<LoginScreen>(
          builder: (_) => LoginScreen(),
        );
      case registerPage:
        return MaterialPageRoute<RegisterScreen>(
          builder: (_) => RegisterScreen(),
        );
      case settingsPage:
        return MaterialPageRoute<SettingsScreen>(
          builder: (_) => SettingsScreen(),
        );
      default:
        throw RouteException(S.current.route_exception_message);
    }
  }
}

class RouteException implements Exception {
  final String message;
  const RouteException(this.message);
}
