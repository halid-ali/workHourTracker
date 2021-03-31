import 'package:flutter/material.dart';
import 'package:work_hour_tracker/generated/l10n.dart';
import 'package:work_hour_tracker/routes.dart';
import 'package:work_hour_tracker/utils/login.dart';
import 'package:work_hour_tracker/widgets/app_drawer_menu.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userId = Login.getUserId();
    var username = Login.getUsername();
    return FutureBuilder(
        future: Future.wait([userId, username]),
        builder: (context, AsyncSnapshot<List<String>> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return Drawer(
            child: Column(
              children: [
                Container(
                  height: 200,
                  child: Image.asset(
                    'chronometer.png',
                    width: 180,
                  ),
                ),
                Divider(height: 20),
                Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(10.0),
                      child: Text('Username: ${snapshot.data[1]}'),
                    ),
                    _getButtons(context),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget _getButtons(BuildContext context) {
    return FutureBuilder(
      future: Login.isLogged(),
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        final isLogged = snapshot.data;
        if (isLogged) {
          return Column(
            children: [
              Divider(height: 5),
              DrawerMenu(
                text: S.of(context).history,
                icon: Icons.history_sharp,
                func: () =>
                    Navigator.pushNamed(context, RouteGenerator.historyPage),
              ),
              Divider(height: 5),
              DrawerMenu(
                text: S.of(context).settings,
                icon: Icons.settings_sharp,
                func: () =>
                    Navigator.pushNamed(context, RouteGenerator.settingsPage),
              ),
              Divider(height: 5),
              DrawerMenu(
                text: S.of(context).logout,
                icon: Icons.close_sharp,
                func: () {
                  Login.logout();
                  Navigator.pushNamed(context, RouteGenerator.loginPage);
                },
              ),
              Divider(height: 5),
            ],
          );
        } else {
          return Column(
            children: [
              DrawerMenu(
                text: S.of(context).login,
                icon: Icons.login_sharp,
                func: () =>
                    Navigator.pushNamed(context, RouteGenerator.loginPage),
              ),
              Divider(height: 5),
              DrawerMenu(
                text: S.of(context).register,
                icon: Icons.person_add_sharp,
                func: () =>
                    Navigator.pushNamed(context, RouteGenerator.registerPage),
              ),
              Divider(height: 5),
            ],
          );
        }
      },
    );
  }
}
