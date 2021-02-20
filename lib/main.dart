import 'package:flutter/material.dart';
import 'package:work_hour_tracker/routes.dart';

void main() {
  runApp(WorkHourTracker());
}

class WorkHourTracker extends StatefulWidget {
  @override
  _WorkHourTrackerState createState() => _WorkHourTrackerState();
}

class _WorkHourTrackerState extends State<WorkHourTracker> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: RouteGenerator.homePage,
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
