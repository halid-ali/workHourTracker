import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderFooterColumn extends StatelessWidget {
  final int flex;
  final String text;
  final Color textColor;
  final Color borderColor;
  final Color backgroundColor;
  final Alignment alignment;

  const HeaderFooterColumn({
    Key key,
    this.flex,
    this.text,
    this.textColor,
    this.borderColor,
    this.backgroundColor,
    this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        alignment: alignment ?? Alignment.centerLeft,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            width: 1,
            color: borderColor,
          ),
        ),
        padding: EdgeInsets.all(5),
        child: AutoSizeText(
          text,
          minFontSize: 1,
          maxFontSize: 19,
          maxLines: 1,
          style: GoogleFonts.openSans(
            color: textColor,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
