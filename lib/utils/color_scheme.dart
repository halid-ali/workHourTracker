import 'package:flutter/material.dart';

class ColorScheme {
  Color _textColor;
  Color _backgroundColor;
  Color _borderColor;

  Color get textColor => _textColor;
  Color get backgroundColor => _backgroundColor;
  Color get borderColor => _borderColor;

  ColorScheme.blue() {
    _textColor = Color(0xFF003459);
    _borderColor = Color(0xFF031D44);
    _backgroundColor = Color(0xFF00B4D8);
  }

  ColorScheme.grey() {
    _textColor = Color(0xFF3B383A);
    _borderColor = Color(0xFF040101);
    _backgroundColor = Color(0xFF909595);
  }

  ColorScheme.green() {
    _textColor = Color(0xFF04471C);
    _borderColor = Color(0xFF0D2818);
    _backgroundColor = Color(0xFF96E072);
  }

  ColorScheme.yellow() {
    _textColor = Color(0xFFBC3908);
    _borderColor = Color(0xFF621708);
    _backgroundColor = Color(0xFFFCBF49);
  }

  ColorScheme.red() {
    _textColor = Color(0xFF5A0001);
    _borderColor = Color(0xFF22181C);
    _backgroundColor = Color(0xFFDE3C4B);
  }
}
