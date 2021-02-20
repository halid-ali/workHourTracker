import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:work_hour_tracker/generated/l10n.dart';
import 'package:work_hour_tracker/routes.dart';

void main() {
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
      initialRoute: RouteGenerator.homePage,
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
