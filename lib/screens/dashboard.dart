import 'package:covid19_tracker/model/constants.dart';
import 'package:covid19_tracker/model/covid19_dashboard.dart';
import 'package:covid19_tracker/screens/Countries.dart';
import 'package:covid19_tracker/screens/Indian.dart';
import 'package:covid19_tracker/screens/SettingPage.dart';

import 'package:covid19_tracker/screens/graphsline.dart';

import 'package:covid19_tracker/services/networking.dart';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:google_nav_bar/google_nav_bar.dart';

import 'slot.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  var response;
  static int d1, d2, d3, d4, d5, d6, d7;
  static String day1, day2, day3, day4, day5, day6, day7;
  dynamic daily7;
  Covid19Dashboard data;
  AnimationController _controller;
  Animation _curvedAnimation;
  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  bool isPlaying = false;

  List<dynamic> dataList;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _curvedAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);
    getData();
  }

  Future<void> getData() async {
    Networking network = Networking();
    Covid19Dashboard result = await network.getDashboardData();
    response = await http.get('https://api.covid19india.org/data.json');
    daily7 = jsonDecode(response.body);
    dataList = daily7['cases_time_series'];

    dataList.removeRange(0, dataList.length - 7);
    d1 = int.parse(dataList[0]['dailyconfirmed']);
    d2 = int.parse(dataList[1]['dailyconfirmed']);
    d3 = int.parse(dataList[2]['dailyconfirmed']);
    d4 = int.parse(dataList[3]['dailyconfirmed']);
    d5 = int.parse(dataList[4]['dailyconfirmed']);
    d6 = int.parse(dataList[5]['dailyconfirmed']);
    d7 = int.parse(dataList[6]['dailyconfirmed']);
    day1 = (dataList[0]['date']).toString();
    day2 = (dataList[1]['date']).toString();
    day3 = (dataList[2]['date']).toString();
    day4 = (dataList[3]['date']).toString();
    day5 = (dataList[4]['date']).toString();
    day6 = (dataList[5]['date']).toString();
    day7 = (dataList[6]['date']).toString();

    // print('d1 '+d1.toString());
    // print('d2 '+d2.toString());
    // print('d3 '+d3.toString());
    // print('d4 '+d4.toString());
    // print('d5 '+d5.toString());
    // print('d6 '+d6.toString());
    // print('d7 '+d7.toString());
    // print(dataList);
    setState(() {
      data = result;
      if (data != null) {
        _controller.reset();
        _controller.forward();
      }
    });
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
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                    ),
                    delegate: SliverChildListDelegate([
                      buildSummerCard(
                          text: 'Confirmed',
                          color: constant().getcolor(),
                          count: data.confirmed),
                      buildSummerCard(
                          text: 'Active',
                          color: Colors.blue,
                          count: data.active),
                      buildSummerCard(
                          text: 'Recovered',
                          color: Colors.lightGreen,
                          count: data.recovered),
                      buildSummerCard(
                          text: 'Deaths',
                          color: Colors.red,
                          count: data.deaths),
                    ]),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Text('Result date: ${data.date}'),
                          ),
                        )
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        AspectRatio(
                          aspectRatio: 1,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                            color: const Color(0xff81e5cd),
                            child: Stack(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Text(
                                        'Covid Infection in India',
                                        style: TextStyle(
                                            color: const Color(0xff0f4a3c),
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        'Daily Cases from last 7 days',
                                        style: TextStyle(
                                            color: const Color(0xff379982),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 38,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: BarChart(
                                            mainBarData(),
                                            swapAnimationDuration: animDuration,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
                  onPressed: () {},
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
                  },
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
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSummerCard({int count, Color color, String text}) {
    // color = Color(0xffFC9B87) ;
    return ScaleTransition(
      scale: Tween<double>(begin: 0, end: 1).animate(_curvedAnimation),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  text,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${formatter.format(count)}',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                )
              ],
            )),
      ),
    );
  }

  final formatter = NumberFormat.decimalPattern('en-US');

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [Colors.yellow] : [barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 400000,
            colors: [barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, d1.toDouble(),
                isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, d2.toDouble(),
                isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, d3.toDouble(),
                isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, d4.toDouble(),
                isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, d5.toDouble(),
                isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, d6.toDouble(),
                isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, d7.toDouble(),
                isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.red,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = day1;
                  break;
                case 1:
                  weekDay = day2;
                  break;
                case 2:
                  weekDay = day3;
                  break;
                case 3:
                  weekDay = day4;
                  break;
                case 4:
                  weekDay = day5;
                  break;
                case 5:
                  weekDay = day6;
                  break;
                case 6:
                  weekDay = day7;
                  break;
                default:
                  throw Error();
              }
              return BarTooltipItem(
                weekDay + '\n',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: (rod.y).toString(),
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! PointerUpEvent &&
                barTouchResponse.touchInput is! PointerExitEvent) {
              //  touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: false,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'M';
              case 1:
                return 'T';
              case 2:
                return 'W';
              case 3:
                return 'T';
              case 4:
                return 'F';
              case 5:
                return 'S';
              case 6:
                return 'S';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }
}
