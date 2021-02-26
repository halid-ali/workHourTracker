import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          _buildButton(context, 'england', 'en'),
          _buildButton(context, 'deutschland', 'de'),
          _buildButton(context, 'turkiye', 'tr'),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String flag, String locale) {
    return InkWell(
      onTap: () => WorkHourTracker.of(context).setLocale(Locale(locale)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SvgPicture.asset('$flag.svg', height: 48),
      ),
    );
  }
}
