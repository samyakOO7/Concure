import 'dart:async';
import 'package:covid19_tracker/services/networking.dart';
import 'package:http/http.dart' as http;
import 'package:covid19_tracker/model/config.dart';
import 'package:covid19_tracker/screens/dashboard.dart';
import 'package:covid19_tracker/screens/slot_booking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import "package:hive_flutter/hive_flutter.dart";
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await Hive.initFlutter();
  await GetStorage.init();
  box = await Hive.openBox('easyTheme');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _MyApp createState() => _MyApp();
}

Future<bool> checkAvailability2() async {
  GetStorage box = GetStorage();
  bool isAvailable = false;
  var currentDistrictId = box.read('district_Id');
  if (currentDistrictId != null) {
    String dateString = DateFormat("dd-MM-yyyy").format(DateTime.now());
    final _url =
        'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=$currentDistrictId&date=$dateString';
    // print(_url);
    var response = await http.get(_url);
    // print("res ${response.body}");
    if (response.statusCode == 200) {
      var r = covidvaccinebypinFromJson(response.body);
      List<Centers> s = r.centers;
      List<Session> rt;
      for (int i = 0; i < s.length; ++i) {
        rt = s[i].sessions;
        for (int j = 0; j < rt.length; ++j) {
          if (rt[j].minAgeLimit>0) {
            NotificationService r=new  NotificationService();
            r.ifAvailable(s[i], rt[j]);
            isAvailable = true;
          }
          if (isAvailable) {

          }
        }
      }
    }
  }
  return isAvailable;
}

class _MyApp extends State<MyApp> {
  Timer _timerForInter;
  @override
  void initState() {
    super.initState();
    _timerForInter = Timer.periodic(Duration(seconds: 60), (result) {
      Networking n = new Networking();
      n.get_notified();
      print("abc");
      checkAvailability2();

    });
    currentTheme.addListener(() {
      print("Changed");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
 return MultiProvider(
    child:
        MaterialApp(
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
        ),
     providers: [
       ChangeNotifierProvider(create: (_) => NotificationService())
    ]);
  }
}


class NotificationService extends ChangeNotifier{
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  Future initialize() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings("splash");

    IOSInitializationSettings iosInitializationSettings =
    IOSInitializationSettings();

    final InitializationSettings initializationSettings =
    InitializationSettings(android:androidInitializationSettings,iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: onSelectNotification);
  }

  Future<void> ifAvailable(Centers center, Session sesion) async {
    print('Vaccine Available in: ${center.pincode}');
    var android = AndroidNotificationDetails("1687497218170948721x8", "New Trips Notification", "Notification Channel for vendor. All the new trips notifications will arrive here.",importance: Importance.max,priority: Priority.high,
        showWhen: false);

    var ios = IOSNotificationDetails();

    var platform = new NotificationDetails(android:android,iOS:ios);

    await _flutterLocalNotificationsPlugin.show(0, "Vaccine Available at ${center.pincode}", "Totat Vaccine availabe ${sesion.availableCapacity} \n Book now ", platform);

  }
  Future shownotification() async {
    var interval = RepeatInterval.everyMinute;
    var android = AndroidNotificationDetails("1687497218170948721x8", "New Trips Notification", "Notification Channel for vendor. All the new trips notifications will arrive here.",importance: Importance.max,priority: Priority.high,
      showWhen: false);

    var ios = IOSNotificationDetails();

    var platform = new NotificationDetails(android:android,iOS:ios);

    await _flutterLocalNotificationsPlugin.periodicallyShow(
        5,"xya","abc",interval ,platform,
        payload: "Welcome to demo app");
    // await _flutterLocalNotificationsPlugin.periodicallyShow(
    //     5,"xyz","abc",show(),interval ,platform,
    //     payload: "Welcome to demo app");

  }
  Future onSelectNotification(String payload) {

  }
  Future<void> show()
  async {
    var android = AndroidNotificationDetails("1687497218170948721x8", "New Trips Notification", "Notification Channel for vendor. All the new trips notifications will arrive here.",importance: Importance.max,priority: Priority.high,
        showWhen: false);

    var ios = IOSNotificationDetails();

    var platform = new NotificationDetails(android:android,iOS:ios);

    await _flutterLocalNotificationsPlugin.show(0, "Demo", "Test Notification \n hello ", platform);
  }
  

}


