import 'package:flutter/material.dart';

class TrackButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Function onPressCallback;
  final Function isActiveCallback;

  const TrackButton({
    Key key,
    this.icon,
    this.color,
    this.onPressCallback,
    this.isActiveCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: ElevatedButton(
          onPressed: () => onPressCallback(),
          child: Icon(icon),
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(
              isActiveCallback() ? color : Color(0xFFC0C0C0),
            ),
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
