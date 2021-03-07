import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppButton extends StatefulWidget {
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final Function onSubmitFunction;

  AppButton({
    Key key,
    this.text,
    this.textColor = Colors.white,
    this.backgroundColor,
    this.onSubmitFunction,
  }) : super(key: key);

  @override
  _AppButtonState createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        color: widget.backgroundColor,
        padding: EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 15,
        ),
        alignment: Alignment.center,
        child: Text(
          widget.text,
          style: GoogleFonts.merriweather(
            color: widget.textColor,
            fontSize: 17,
          ),
        ),
      ),
      onTap: widget.onSubmitFunction,
    );
  }
}
