import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class AppToast {
  final BuildContext context;
  final String message;
  FToast fToast;
  Color color;
  IconData icon;

  AppToast.error(
    this.context,
    this.message,
  ) {
    color = Color(0xFFE5383B);
    icon = Icons.close_sharp;
    _show();
  }

  AppToast.info(
    this.context,
    this.message,
  ) {
    color = Color(0xFF0096C7);
    icon = Icons.info_outline;
    _show();
  }

  AppToast.success(
    this.context,
    this.message,
  ) {
    color = Color(0xFF38B000);
    icon = Icons.check_sharp;
    _show();
  }

  void _init() {
    fToast = FToast();
    fToast.init(context);
  }

  void _show() {
    _init();
    fToast.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 12.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: color,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 10),
            Text(
              message,
              style: GoogleFonts.openSans(fontSize: 17, color: Colors.white),
            ),
          ],
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }
}
