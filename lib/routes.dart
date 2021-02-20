import 'package:flutter/material.dart';
import 'package:work_hour_tracker/screens/main_screen.dart';

class RouteGenerator {
  static const homePage = '/';

  const RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute<MainScreen>(
          builder: (_) => MainScreen(),
        );
      default:
        throw RouteException("Route not found.");
    }
  }
}

class RouteException implements Exception {
  final String message;
  const RouteException(this.message);
}
