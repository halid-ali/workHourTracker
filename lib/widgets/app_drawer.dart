import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart';
import 'package:work_hour_tracker/main.dart';
import 'package:work_hour_tracker/routes.dart';
import 'package:work_hour_tracker/widgets/app_drawer_menu.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildLanguagesRow(context),
          Divider(height: 20),
          Container(
            child: Image.asset(
              'chronometer.png',
              width: 180,
            ),
          ),
          Divider(height: 20),
          Column(
            children: [
              ..._getButtons(context),
            ],
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

  List<Widget> _getButtons(BuildContext context) {
    return [
      DrawerMenu(
        text: 'Login',
        icon: Icons.login_sharp,
        func: () => Navigator.pushNamed(context, RouteGenerator.loginPage),
      ),
      Divider(height: 5),
      DrawerMenu(
        text: 'Register',
        icon: Icons.person_add_sharp,
        func: () => Navigator.pushNamed(context, RouteGenerator.registerPage),
      ),
      Divider(height: 5),
      DrawerMenu(
        text: 'Settings',
        icon: Icons.settings_sharp,
        func: () => Navigator.pushNamed(context, RouteGenerator.settingsPage),
      ),
      Divider(height: 5),
    ];
  }
}
