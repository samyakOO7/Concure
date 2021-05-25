import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:covid19_tracker/widget/line_tiles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const indiaurl =
    'https://api.apify.com/v2/key-value-stores/toDWvRj1JpTXiM8FF/records/LATEST?disableRedirect=true';

class LineChartWidget extends StatefulWidget {

  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {


  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  final List<Color> gradientColors1 = [
    const Color(0xffff0000),
  ];

  Map<dynamic, dynamic> indiaDATA;

  fetchStateData() async
  {

    http.Response response = await http.get(indiaurl);
    setState(() {
      indiaDATA = json.decode(response.body);

      }

    //     name:  indiaDATA['regionData'][index]['region'].toString(),
    // Active: indiaDATA['regionData'][index]['totalInfected'].toString(),
    // death: indiaDATA['regionData'][index]['deceased'].toString(),
    // newactive: indiaDATA['regionData'][index]['newInfected'],
    // newdeath:indiaDATA['regionData'][index]['newDeceased'].toString() ,
    // recovered: indiaDATA['regionData'][index]['recovered'].toString(),
  // newrecovered: indiaDATA['regionData'][index]['newRecovered'].toString(),

    );
  }

  @override
  Widget build(BuildContext context) => LineChart(
    LineChartData(
      minX: 0,
      maxX: 12,
      minY: 0,
      maxY: 6,
      titlesData: LineTitles.getTitleData(),
      gridData: FlGridData(
        show: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        drawVerticalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 2.5),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          // dotData: FlDotData(show: false),
          /*belowBarData: BarAreaData(
            show: true,
            colors: gradientColors
                .map((color) => color.withOpacity(0.3))
                .toList(),
          ),*/
        ),
        LineChartBarData(
          spots: [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 2.5),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          //isCurved: true,
          colors: gradientColors1,
          barWidth: 2,

          dotData: FlDotData(
            show: false,
          ),

          // dotData: FlDotData(show: false),
          //belowBarData: BarAreaData(
          //  show: true,
          // colors: gradientColors
          //    .map((color) => color.withOpacity(0.3))
          //    .toList(),
          //),
        ),
      ],
    ),
  );
}
