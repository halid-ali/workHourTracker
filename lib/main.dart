import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:work_hour_tracker/generated/l10n.dart';
import 'package:work_hour_tracker/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:work_hour_tracker/utils/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(WorkHourTracker());
}

class WorkHourTracker extends StatefulWidget {
  @override
  _WorkHourTrackerState createState() => _WorkHourTrackerState();

  static _WorkHourTrackerState of(BuildContext context) =>
      context.findAncestorStateOfType<_WorkHourTrackerState>();
}

class _WorkHourTrackerState extends State<WorkHourTracker> {
  Locale _locale;

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      initialRoute: Login.isLogged()
          ? RouteGenerator.workHourOptionsPage
          : RouteGenerator.loginPage,
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
