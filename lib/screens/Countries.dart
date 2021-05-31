import 'dart:convert';
import 'dart:ui';

import 'package:covid19_tracker/model/constants.dart';
import 'package:covid19_tracker/model/countries.dart';

import 'package:covid19_tracker/screens/SettingPage.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/country.dart';
import 'package:http/http.dart' as http;
import 'package:google_nav_bar/google_nav_bar.dart';

import 'Indian.dart';
import 'dashboard.dart';

class Cont extends StatefulWidget {
  const Cont({Key key}) : super(key: key);

  @override
  _Cont createState() => _Cont();
}

class _Cont extends State<Cont> with SingleTickerProviderStateMixin {
  var url =
      "https://doh.saal.ai/api/live";
  List data;
  int touchedIndex = -1;
var sumall;
var per_active;
var per_rec;
var country_code;
var per_confirmed;

  @override
  void initState() {
    super.initState();


    this.getData();
    //_controller.forward();
  }

  Future<String> getData() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {'Accept': 'application/json'});
    setState(() {
      dynamic convertJson = jsonDecode(response.body);
      data = convertJson['countries'];
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Concure'),
      ),
      body: data == null
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: getData,
        child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
            var country=data[index]['country'].toString();
            var confirmed=data[index]['confirmed'].toString();
            var active=data[index]['active'].toString();
            var recovered=data[index]['recovered'].toString();
            var deaths=data[index]['deaths'].toString();
            country_code=data[index]['countryCode'];
             sumall=data[index]['confirmed']+data[index]['recovered']+data[index]['active'];
             per_active=(data[index]['active']/sumall)*100;
             per_rec=(data[index]['recovered']/sumall)*100;

             per_confirmed=(data[index]['confirmed']/sumall)*100;
            return new Container(
                child: new Center(
                child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                new Container(

                child: ExpansionTile(
                leading:country_code.length==2?CountryPickerUtils.getDefaultFlagImage(Country(isoCode: country_code)):Text(''),
                  title: Text(
                  country,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
                  children:<Widget> [
                    ListTile(
                      title: Text(
                        'Active Cases:  ' +
                           active,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.deepOrangeAccent),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Confirmed Cases:  ' +
                           confirmed,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Recovered Cases:  ' +
                            recovered,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.green),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Deaths:  ' +
                            deaths,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.red),
                      ),
                    ),
                    Container(

                      child: Row(
                        children: <Widget>[
                          const SizedBox(
                            height: 18,
                          ),
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: PieChart(
                                PieChartData(
                                    pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                                      setState(() {
                                        final desiredTouch = pieTouchResponse.touchInput is! PointerExitEvent &&
                                            pieTouchResponse.touchInput is! PointerUpEvent;
                                        if (desiredTouch && pieTouchResponse.touchedSection != null) {
                                          touchedIndex = pieTouchResponse.touchedSection.touchedSectionIndex;
                                        } else {
                                          touchedIndex = -1;
                                        }
                                      });
                                    }),
                                    borderData: FlBorderData(
                                      show: false,
                                    ),
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 40,
                                    sections: showingSections()),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 4),
                                    color: Colors.blue,
                                    width: 10,
                                    height: 10,

                                  ),
                                  Text("Confirmed cases"),

                                ],),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 4),
                                    color: Colors.red,
                                    width: 10,
                                    height: 10,

                                  ),
                                  Text("Active Cases"),
                                ],),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 4),
                                    color: Colors.green,
                                    width: 10,
                                    height: 10,

                                  ),
                                  Text("Recovered Cases"),

                                ],),




                            ],
                          ),
                          const SizedBox(
                            width: 28,
                          ),
                        ],
                      ),
                    ),
                  ],

                )
            )
              ])
              )
            );
               }
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
              // rippleColor: Colors.black87,
              // hoverColor: Colors.yellow,
              gap: 8,
              // activeColor: Colors.black,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              // tabBackgroundColor: Colors.yellow,
              color: Colors.black,
              tabs: [
                GButton(
                  icon: Icons.apps,
                  // iconSize: 30,
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
                ),
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
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SettingPage()),
                    );
                  },
                ),
              ],
              selectedIndex: 1,
            ),
          ),
        ),
      ),
    );
  }


  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: per_confirmed,
            title: per_confirmed.toStringAsFixed(1),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.red,
            value: per_active,
            title: per_active.toStringAsFixed(1),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.green,
            value: per_rec,
            title: per_rec.toStringAsFixed(1),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );

        default:
          throw Error();
      }
    });
  }

}

