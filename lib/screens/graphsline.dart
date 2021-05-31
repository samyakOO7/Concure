import 'package:covid19_tracker/model/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:stack/stack.dart' as st;
import 'Countries.dart';
import 'Indian.dart';
import 'SettingPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GraphsLine extends StatefulWidget {
  @override
  _GraphsLineState createState() => _GraphsLineState();
}

class _GraphsLineState extends State<GraphsLine> {
  int getmonth(String val) {
    int first = int.parse(val[5]);
    int second = int.parse(val[6]);
    if (first == 1) {
      return 10 + second;
    } else
      return second;
  }

  var response;

  List greenspots;
  List redspots;

  List greenspotsformonth;
  List redspotsformonth;
  List<dynamic> dataList;
  List blackspots;

  dynamic daily7;
  bool isShowingMainData;
  st.Stack<FlSpot> stgreen;
  st.Stack<FlSpot> stred;
  int getdate(String s) {
    int first = int.parse(s[8]);
    int second = int.parse(s[9]);
    if (first == 3) {
      return 30;
    } else if (first == 2)
      return 20 + second;
    else if (first == 1)
      return 10 + second;
    else
      return second;
  }

  Future<void> getDatamonthly() async {
    response = await http.get('https://api.covid19india.org/data.json');
    daily7 = jsonDecode(response.body);
    dataList = daily7['cases_time_series'];
    dataList.removeRange(0, 337);
    int month = 1;
    stgreen = st.Stack<FlSpot>();
    stred = st.Stack<FlSpot>();

    greenspots = new List<FlSpot>();
    blackspots = new List<FlSpot>();
    redspots = new List<FlSpot>();

    int lastmonth = getmonth(dataList[dataList.length - 1]['dateymd']);
    ;

    // print(dataList);

    int temp = 0;
    int tempred = 0;
    int tempdeath = 0;
    greenspotsformonth = new List<FlSpot>();
    redspotsformonth = new List<FlSpot>();

    for (int i = dataList.length - 1; i >= 0; i--) {
      month = getmonth(dataList[i]['dateymd']);

      if (month != lastmonth) {
        // print("FOR MONTH " + lastmonth.toString());

        while (stgreen.isEmpty == false) {
          greenspotsformonth.add(stgreen.pop());
        }
        while (stred.isEmpty == false) {
          redspotsformonth.add(stred.pop());
        }

        break;
      }
      tempred = int.parse(dataList[i]['dailyconfirmed']);
      temp = int.parse(dataList[i]['dailyrecovered']);
      int date = getdate(dataList[i]['dateymd']);
      FlSpot fl = new FlSpot(
          double.parse(date.toString()), double.parse(temp.toString()));
      stgreen.push(fl);
      FlSpot fl2 = new FlSpot(
          double.parse(date.toString()), double.parse(tempred.toString()));

      stred.push(fl2);
    }
    setState(() {});
  }

  Future<void> getData() async {
    response = await http.get('https://api.covid19india.org/data.json');
    daily7 = jsonDecode(response.body);
    dataList = daily7['cases_time_series'];
    dataList.removeRange(0, 337);
    int month = 1;
    greenspots = new List<FlSpot>();
    blackspots = new List<FlSpot>();
    redspots = new List<FlSpot>();

    int lastmonth = 1;

    print(dataList);

    int temp = 0;
    int tempred = 0;
    int tempdeath = 0;

    for (int i = 0; i < dataList.length; i++) {
      month = getmonth(dataList[i]['dateymd']);

      if (month != lastmonth) {
        print("FOR MONTH " + lastmonth.toString());

        FlSpot fl = new FlSpot(
            double.parse(lastmonth.toString()), double.parse(temp.toString()));
        greenspots.add(fl);

        FlSpot fl2 = new FlSpot(double.parse(lastmonth.toString()),
            double.parse(tempred.toString()));
        redspots.add(fl2);

        FlSpot fl3 = new FlSpot(double.parse(lastmonth.toString()),
            double.parse(tempdeath.toString()));
        blackspots.add(fl3);

        temp = 0;
        tempdeath = 0;
        tempred = 0;
        lastmonth = month;
      }

      tempdeath += int.parse(dataList[i]['dailydeceased']);
      tempred += int.parse(dataList[i]['dailyconfirmed']);
      temp += int.parse(dataList[i]['dailyrecovered']);
    }

    print("MONTH IS " + month.toString());

    FlSpot fl = new FlSpot(
        double.parse(month.toString()), double.parse(temp.toString()));
    greenspots.add(fl);

    FlSpot fl2 = new FlSpot(
        double.parse(month.toString()), double.parse(tempred.toString()));
    redspots.add(fl2);
    FlSpot fl3 = new FlSpot(
        double.parse(month.toString()), double.parse(tempdeath.toString()));
    blackspots.add(fl3);
    print("length of green spots " + greenspots.length.toString());
    print(greenspots);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
    getData();
    getDatamonthly();
  }

  // int selectedIndex = 0;
  int segmentedControlGroupValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Concure'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: CupertinoSlidingSegmentedControl<int>(
              onValueChanged: (val) =>
                  setState(() => segmentedControlGroupValue = val),
              groupValue: segmentedControlGroupValue,
              padding: EdgeInsets.all(4.0),
              children: <int, Widget>{
                0: Text(
                  "Yearly Data",
                ),
                1: Text("Mothly data")
              },
            ),
          ),
          const SizedBox(
            height: 37,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,

            children: <Widget>[
              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Container(
                    margin:
                    EdgeInsets.only(right: 4),
                    color: Colors.red,
                    width: 15,
                    height: 15,
                  ),
                  Text("Infected    ",style: TextStyle(fontSize: 17),),
                ],
              ),


              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Container(
                    margin:
                    EdgeInsets.only(right: 4),
                    color: Colors.green,
                    width: 15,
                    height: 15,
                  ),
                  Text("Recovered",style: TextStyle(fontSize: 17),),
                ],
              ),
            ],
          ),
          Expanded(
              child: segmentedControlGroupValue == 0
                  ? (greenspots == null
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                padding:
                const EdgeInsets.only(right: 16.0, left: 6.0),
                child: LineChart(
                  sampleData1(),
                  // swapAnimationDuration: const Duration(milliseconds: 250),
                ),
              ))
                  : (greenspotsformonth == null
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                padding:
                const EdgeInsets.only(right: 16.0, left: 6.0),
                child: LineChart(
                  sampleData2(),
                  // swapAnimationDuration:
                  // const Duration(milliseconds: 250),
                ),
              ))),
          const SizedBox(
            height: 10,
          ),
        ],
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

  LineChartData sampleData1() {
    return LineChartData(
      // backgroundColor: Colors.black54,
      lineTouchData: LineTouchData(

        touchTooltipData: LineTouchTooltipData(

          tooltipBgColor: Colors.blueGrey.withOpacity(0.9),
        ),
        touchCallback: (LineTouchResponse touchResponse) {

        },
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: true,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 32,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return 'J';
              case 2:
                return 'F';
              case 3:
                return 'M';
              case 4:
                return 'A';
              case 5:
                return 'M';
              case 6:
                return 'J';
              case 7:
                return 'J';
              case 8:
                return 'A';
              case 9:
                return 'S';
              case 10:
                return 'O';
              case 11:
                return 'N';
              case 12:
                return 'D';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1000000:
                return '1000k';
              case 2000000:
                return '2000k';
              case 3000000:
                return '3000k';
            // return '30k';
              case 4000000:
                return '4000k';
              case 5000000:
                return '5000k';
              case 6000000:
                return '6000k';
              case 7000000:
                return '7000k';
              case 8000000:
                return '8000k';
              case 9000000:
                return '9000k';
            }
            return '';
          },
          margin: 8,
          reservedSize: 40,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 2,
          ),
          left: BorderSide(
            color: Color(0xff4e4965),
            // color: Colors.,
            width: 2,
            // color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: 12,
      maxY: 10000000,
      minY: 0,
      lineBarsData: linesBarData1(),
    );
  }

  List<LineChartBarData> linesBarData1() {
    LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: redspots,
      isCurved: true,
      colors: [Colors.red],
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    LineChartBarData lineChartBarData2 = LineChartBarData(
      spots: greenspots,
      isCurved: true,
      // colors: [const Color(0xff4af699)],
      colors: [Colors.green],
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(show: false, colors: [
        const Color(0x00aa4cfc),
      ]),
    );

    return [
      lineChartBarData1,
      lineChartBarData2,
      // lineChartBarData3,
    ];
  }

  LineChartData sampleData2() {
    return LineChartData(
      // backgroundColor: Colors.black54,
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.9),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: true,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 32,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1';

              case 5:
                return '5';
              case 10:
                return '10';

              case 15:
                return '15';

              case 20:
                return '20';

              case 25:
                return '25';

              case 30:
                return '30';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 200000:
                return '200k';
              case 300000:
                return '300k';
              case 400000:
                return '400k';
              case 500000:
                return '500k';
              case 600000:
                return '600k';
              case 250000:
                return '250k';
              case 350000:
                return '350k';
            // return '350k';
              case 450000:
                return '450k';
              case 550000:
                return '550k';
            }
            return '';
          },
          margin: 8,
          reservedSize: 40,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 2,
          ),
          left: BorderSide(
            color: Color(0xff4e4965),
            // color: Colors.,
            width: 2,
            // color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: 30,
      maxY: 600000,
      minY: 0,
      lineBarsData: linesBarData2(),
    );
  }

  List<LineChartBarData> linesBarData2() {
    LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: redspotsformonth,
      isCurved: true,
      colors: [Colors.red],
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    LineChartBarData lineChartBarData2 = LineChartBarData(
      spots: greenspotsformonth,
      isCurved: true,
      // colors: [const Color(0xff4af699)],
      colors: [Colors.green],
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: false, colors: [
        const Color(0x00aa4cfc),
      ]),
    );

    return [
      lineChartBarData1,
      lineChartBarData2,
      // lineChartBarData3,
    ];
  }
}