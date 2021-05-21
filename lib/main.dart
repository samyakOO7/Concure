import 'package:covid19_tracker/model/countries.dart';
import 'package:covid19_tracker/screens/Countries.dart';
import 'package:covid19_tracker/screens/Indian.dart';
import 'package:covid19_tracker/screens/dashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Covid 19 Tracker',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,

      ),
      home: DashboardScreen(),
    );
  }
}
