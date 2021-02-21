import 'package:flutter/material.dart';
import 'package:work_hour_tracker/main.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildLanguagesRow(context),
          Divider(height: 20),
          DrawerHeader(
            child: Icon(Icons.timer_sharp, size: 90),
          ),
          Divider(height: 20),
          Container(
            child: Text('My drawer'),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguagesRow(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildButton(context, 'EN', 'en'),
          SizedBox(width: 10),
          _buildButton(context, 'DE', 'de'),
          SizedBox(width: 10),
          _buildButton(context, 'TR', 'tr'),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, String locale) {
    return ElevatedButton(
      onPressed: () => WorkHourTracker.of(context).setLocale(Locale(locale)),
      child: Text(text),
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.all(
          Colors.grey,
        ),
        padding: MaterialStateProperty.all(
          EdgeInsets.zero,
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
      ),
    );
  }
}
