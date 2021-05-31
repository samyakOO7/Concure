import 'dart:async';

import 'package:covid19_tracker/model/constants.dart';
import 'package:covid19_tracker/model/config.dart';
import 'package:covid19_tracker/screens/newsPage.dart';
import 'package:covid19_tracker/screens/slot.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Countries.dart';
import 'Indian.dart';

import 'dashboard.dart';
import 'graphsline.dart';

class SettingPage extends StatefulWidget {
  _SettingPage createState() => _SettingPage();
}

class _SettingPage extends State<SettingPage> {
  var isSwitched = false;

  Future<bool> Savesettings(bool swit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSwitched', isSwitched);

    return prefs.commit();
  }

  Future<bool> Getsettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isSwitched = prefs.getBool('isSwitched');
    return isSwitched;
  }

  String title = "      Select Dark Mode";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      Getsettings().then(update);
    });
  }

  FutureOr update(bool value) {
    setState(() {
      if (value == null) {
        isSwitched = true;
      } else {
        isSwitched = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Icon blub = IconDa(Icons.lightbulb, size: 35,);
    IconData blub = Icons.brightness_3_sharp;
    IconData blub2 = Icons.brightness_6;

    return Scaffold(
      appBar: AppBar(
        title: Text('Concure'),
      ),
      body: Container(
        // color: Colors.red,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.values[5],
          children: [

            Card(
              elevation: 3,
              child: Row(
                // crossAxisAlignment: Cross/isAlignment.spaceEvenly,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 23),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: GestureDetector(
                      child: Icon(
                        isSwitched ? blub : blub2,
                        size: 35,
                      ),
                      onTap: () {
                        if (isSwitched == false) {
                          isSwitched = true;

                          title = "       Select Dark Mode";
                          constant.navbar = Colors.white;
                          constant.tapInfo = Colors.blue;

                          constant().setcolor(Colors.black, Color(0xff202c3b));
                        } else {
                          isSwitched = false;

                          constant.navbar = Color(0xff202c3b);

                          title = "       Select Light Mode";
                          constant.tapInfo = Colors.greenAccent;
                          constant().setcolor(Colors.white, Colors.cyan);
                        }
                        currentTheme.switchTheme();
                        Savesettings(isSwitched);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50,),
            Container(
              height: MediaQuery.of(context).size.height - 500,
              // height:  MediaQuery.of(context).size.height -600,
              // color: Colors.yellow,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  clickbutton(
                    'Graphical Data',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GraphsLine()),
                      );
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  clickbutton('Covid News', () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),),);

                  }),
                  SizedBox(height: 10,),
                  clickbutton('Vaccinator', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VaccinebyPin()),
                    );
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  clickbutton('Donate', () {
                    launch('https://covid19responsefund.org/en/');
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  clickbutton(
                    'Myth Busters',
                    () {
                      launch(
                          'https://www.who.int/emergencies/diseases/novel-coronavirus-2019/advice-for-public/myth-busters');
                    },
                  ),
                ],

            Text("Set Dark Mode",style: TextStyle(fontSize: 20),),
            Padding(
              padding:  EdgeInsets.all(20),
              child: GestureDetector
                (child: Icon(isSwitched?blub:blub2,size: 35,), onTap: (){

                if(isSwitched==false)
                {
                  isSwitched = true;
                  // print("HERE make ");
                  constant().setcolor(Colors.black, Color(0xff202c3b));


                }
                else
                {
                  isSwitched = false;


                  constant().setcolor(Colors.white,Colors.cyan);


                }
                currentTheme.switchTheme();
                Savesettings(isSwitched);




              },

              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: constant.navbar,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              gap: 8,

              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),

              color: Colors.black,
              tabs: [
                GButton(
                  icon: Icons.apps,
                  iconSize: 30,
                  text: 'Home',
                  backgroundColor: Colors.red[100],
                  textColor: Colors.red,
                  iconActiveColor: Colors.red,
                  iconColor: Colors.red,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashboardScreen(),
                      ),
                    );
                  },
                ),
                GButton(
                    icon: Icons.find_in_page,
                    iconColor: Colors.purpleAccent,
                    text: 'Countries',
                    backgroundColor: Colors.purple[100],
                    textColor: Colors.purple,
                    iconActiveColor: Colors.purpleAccent[200],
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Cont()),
                      );
                    }),
                GButton(
                  icon: Icons.countertops,
                  text: 'States',
                  iconColor: Colors.pink,
                  backgroundColor: Colors.pink[100],
                  textColor: Colors.pink,
                  iconActiveColor: Colors.redAccent,
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Indian()));
                  },
                ),
                GButton(
                  icon: Icons.settings,
                  text: 'Settings',
                  iconColor: Colors.blue,
                  backgroundColor: Colors.blue[100],
                  textColor: Colors.blue[500],
                  iconActiveColor: Colors.blue[600],
                ),
              ],
              selectedIndex: 3,
              // onTabChange: (index) {
              //   setState(() {
              //     _selectedIndex = index;
              //   });
              // },
            ),
          ),
        ),
      ),
    );
  }

  Widget clickbutton(String title, fuction()) {
    return GestureDetector(
      onTap: fuction,
      child: Container(
        decoration: BoxDecoration(
            color: constant.downbar, borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('  ' + title,
                style: TextStyle(
                  // letterSpacing: 0
                  fontSize: 23,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                )),
            Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 27,
            ),
          ],
        ),
      ),
    );
  }
}
