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
      hoverColor: Color(0xFFE1E5F2),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                child: Text(
                  text,
                  style: GoogleFonts.merriweather(fontSize: 17),
                ),
              ),
            ),
            Icon(icon, size: 27),
          ],
        ),
      ),
    );
  }
}
