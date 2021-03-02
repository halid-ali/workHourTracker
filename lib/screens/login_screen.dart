import 'package:flutter/material.dart';
import 'package:work_hour_tracker/routes.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            child: TextButton(
              child: Text('Login Screen'),
              onPressed: () =>
                  Navigator.pushNamed(context, RouteGenerator.homePage),
            ),
          ),
        ),
      ),
    );
  }
}
