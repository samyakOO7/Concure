import 'dart:ffi';
import 'dart:io';

import 'package:covid19_tracker/model/config.dart';
import 'package:covid19_tracker/model/constants.dart';
import 'package:covid19_tracker/screens/SettingPage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'dart:async';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:http/http.dart' as http;

import 'Countries.dart';
import 'dashboard.dart';

class Indian extends StatefulWidget {
  const Indian({Key key}) : super(key: key);

  @override
  _Indian createState() => _Indian();
}

class _Indian extends State<Indian> {
  var url =
      "https://api.apify.com/v2/key-value-stores/toDWvRj1JpTXiM8FF/records/LATEST?disableRedirect=true";
  List data;
  int touchedIndex = -1;
  var sumall;
  double per_activ;
  double per_rec;
  double per_inf;
  static String active,
      totalRecovered,
      nRec,
      tdecre,
      nDecre,
      tinfec,
      nInfec,
      title;

  @override
  void initState() {
    super.initState();
    this.getJsonData();
  }

  // ignore: missing_return
  Future<String> getJsonData() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {'Accept': 'application/json'});
    setState(() {
      dynamic convertJson = jsonDecode(response.body);
      data = convertJson['regionData'];
    });
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Concure'),
      ),

      body: data == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int index) {
                title = data[index]['region'].toString();

                active = data[index]['activeCases'].toString();
                totalRecovered = data[index]['recovered'].toString();
                nRec = data[index]['newRecovered'].toString();

                tdecre = data[index]['deceased'].toString();
                nDecre = data[index]['newDeceased'].toString();
                tinfec = data[index]['totalInfected'].toString();
                nInfec = data[index]['newInfected'].toString();

                sumall = data[index]['activeCases'] +
                    data[index]['recovered'] +
                    data[index]['totalInfected'];
                per_activ = (data[index]['activeCases'] / sumall) * 100;
                per_inf = (data[index]['totalInfected'] / sumall) * 100;
                per_rec = (data[index]['recovered'] / sumall) * 100;

                return new Container(
                  child: new Center(
                    child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          new Container(
                            child: ExpansionTile(
                              title: Text(
                                title,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              children: <Widget>[
                                ListTile(
                                  title: Text(
                                    'Active Cases:  ' +
                                        data[index]['activeCases'].toString(),
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.deepOrangeAccent),
                                  ),
                                ),
                                Pan(
                                  tr: totalRecovered,
                                  nr: nRec,
                                  td: tdecre,
                                  nd: nDecre,
                                  ti: tinfec,
                                  ni: nInfec,
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
                                                pieTouchData: PieTouchData(
                                                    touchCallback:
                                                        (pieTouchResponse) {
                                                  setState(() {
                                                    final desiredTouch =
                                                        pieTouchResponse
                                                                    .touchInput
                                                                is! PointerExitEvent &&
                                                            pieTouchResponse
                                                                    .touchInput
                                                                is! PointerUpEvent;
                                                    if (desiredTouch &&
                                                        pieTouchResponse
                                                                .touchedSection !=
                                                            null) {
                                                      touchedIndex =
                                                          pieTouchResponse
                                                              .touchedSection
                                                              .touchedSectionIndex;
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
                                                sections: showingSections(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                margin:
                                                EdgeInsets.only(right: 4),
                                                color: Colors.red,
                                                width: 10,
                                                height: 10,
                                              ),
                                              Text("Active cases"),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                margin:
                                                EdgeInsets.only(right: 4),
                                                color: Colors.blue,
                                                width: 10,
                                                height: 10,
                                              ),
                                              Text("Infected"),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                margin:
                                                EdgeInsets.only(right: 4),
                                                color: Colors.green,
                                                width: 10,
                                                height: 10,
                                              ),
                                              Text("Recovered"),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 28,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                );
              }),

      //NAVIGATION BAR

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
                  },
                ),
                GButton(
                  icon: Icons.countertops,
                  text: 'States',
                  iconColor: Colors.pink,
                  backgroundColor: Colors.pink[100],
                  textColor: Colors.pink,
                  iconActiveColor: Colors.redAccent,

//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => Indian()));
// //
//
//               },
                ),
                GButton(
                  icon: Icons.settings,
                  text: 'Settings',
                  iconColor: Colors.blue,
                  backgroundColor: Colors.blue[100],
                  textColor: Colors.blue[500],
                  iconActiveColor: Colors.blue[600],
                  onPressed: () {
                    //TODO

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SettingPage()),
                    );
                  },
                ),
              ],
              selectedIndex: 2,
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
            color: Colors.red,
            value: per_activ,
            title: per_activ.toStringAsFixed(1),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.blue,
            value: per_inf,
            title: per_inf.toStringAsFixed(1),
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

Widget Pan({String tr, String nr, String td, String nd, String ti, String ni}) {
  int tri , nri, tdi, ndi, tii,nii;
  tri = int.parse(tr);
  nri = int.parse(nr);
  tdi = int.parse(td);
  ndi = int.parse(nd);
  tii = int.parse(ti);
  nii =  int.parse(ni);
  if(tri < 0)
    tri = -1 * tri;
  if(nri < 0 )
    nri = -1 * nri;
  if(tdi < 0)
    tdi = -1 * tdi;
  if(ndi < 0)
    ndi = -1 * ndi ;
  if(tii < 0)
    tii = -1 * tii;
  if(nii < 0)
    nii = -1 * nii;



  return Container(
    // height: 0,
    child: GridView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 3),
      children: <Widget>[
        StatusPanel2(
          textColor: Colors.green,
          title: 'Total Recovered',
          count: tri.toString(),
        ),
        StatusPanel2(
          textColor: Colors.green,
          title: 'Newly Recovered',
          count: nri.toString(),
        ),
        StatusPanel2(
          // panelColor: Colors.blue[100],
          textColor: Colors.red[600],
          title: 'Total Deceased',
          count: ndi.toString(),
        ),
        StatusPanel2(
          textColor: Colors.red[600],
          title: 'Newly Deceased',
          count: ndi.toString(),
        ),
        StatusPanel2(
          textColor: Colors.blue,
          title: 'Total Infected',
          count: tii.toString(),
        ),
        StatusPanel2(
          // panelColor: Colors.blue[100],
          textColor: Colors.blue,
          title: 'Newly Infected',
          count: nii.toString(),
        ),
      ],
    ),
  );
}

// static String active, totalRecovered, nRec, tdecre, nDecre, tinfec, nInfec,title;

class StatusPanel2 extends StatelessWidget {
  // final Color panelColor;

  final Color textColor;

  final String title;

  final String count;

  const StatusPanel2({Key key, this.textColor, this.title, this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    return Container(
      // margin: EdgeInsets.all(5),
      // color: panelColor,
      // height: 40,
      // width: width / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15, color: textColor)),
          SizedBox(
            height: 4,
          ),
          Text(count,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15, color: textColor))
        ],
      ),
    );
  }
}
