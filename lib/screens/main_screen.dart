import 'package:flutter/material.dart';
import 'package:work_hour_tracker/utils/platform_info.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainScreen createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: PlatformInfo.isWeb()
                  ? 500
                  : MediaQuery.of(context).size.width,
            ),
          ),
        ),
        drawer: Drawer(),
      ),
    );
  }
}
