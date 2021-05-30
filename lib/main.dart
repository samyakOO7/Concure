import 'package:covid19_tracker/model/config.dart';
import 'package:covid19_tracker/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import "package:hive_flutter/hive_flutter.dart";

void main() async {
  await Hive.initFlutter();
  box = await Hive.openBox('easyTheme');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      print("Changed");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Concure',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.grey,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: currentTheme.currentTheme(),
      home: DashboardScreen(),
    );
  }
}
