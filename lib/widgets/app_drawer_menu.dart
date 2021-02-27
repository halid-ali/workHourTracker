import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerMenu extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function func;

  const DrawerMenu({
    Key key,
    this.text,
    this.icon,
    this.func,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: func,
      hoverColor: Color(0xFFF0F0F0),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Row(
          children: [
            Icon(icon, size: 27),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  text,
                  style: GoogleFonts.merriweather(fontSize: 17),
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_sharp, size: 20),
          ],
        ),
      ),
    );
  }
}
