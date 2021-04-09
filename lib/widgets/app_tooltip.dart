import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTooltip extends StatelessWidget {
  final String message;
  final Widget child;

  const AppTooltip(
    this.message,
    this.child, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      padding: EdgeInsets.all(5.0),
      textStyle: GoogleFonts.openSans(fontSize: 15, color: Colors.white),
      decoration: BoxDecoration(color: Color(0xFF212529)),
      child: child,
    );
  }
}
