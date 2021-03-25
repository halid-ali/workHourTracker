import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  final String text;

  const AppLoading(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          backgroundColor: Color(0xFFCED4DA),
          strokeWidth: 1,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF495057)),
        ),
        SizedBox(height: 20),
        Text(text),
      ],
    );
  }
}
