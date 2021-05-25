// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';

// import 'Countries.dart';
// import 'Indian.dart';
// import 'SettingPage.dart';

// class BarChartSample2 extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => BarChartSample2State();
// }

// class BarChartSample2State extends State<BarChartSample2> {
//   // final Color leftBarColor = const Color(0xff53fdd7);
//   final Color rightBarColor = Colors.red;
//   Color leftBarColor = Colors.green;
//   final double width = 7;

//   List<BarChartGroupData> rawBarGroups;
//   List<BarChartGroupData> showingBarGroups;

//   int touchedGroupIndex = -1;

//   @override
//   void initState() {
//     super.initState();
//     final barGroup1 = makeGroupData(0, 5, 12);
//     final barGroup2 = makeGroupData(1, 16, 12);
//     final barGroup3 = makeGroupData(2, 18, 5);
//     final barGroup4 = makeGroupData(3, 20, 16);
//     final barGroup5 = makeGroupData(4, 17, 6);
//     final barGroup6 = makeGroupData(5, 19, 1.5);
//     final barGroup7 = makeGroupData(6, 10, 1.5);

//     final items = [
//       barGroup1,
//       barGroup2,
//       barGroup3,
//       barGroup4,
//       barGroup5,
//       barGroup6,
//       barGroup7,
//     ];

//     rawBarGroups = items;

//     showingBarGroups = rawBarGroups;
//   }

//   Widget yearly() {
//     return Container(
//       height: MediaQuery.of(context).size.height - 50,
//       child: Card(
//         elevation: 0,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
//         color: Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             mainAxisAlignment: MainAxisAlignment.start,
//             mainAxisSize: MainAxisSize.max,
//             children: <Widget>[
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         if (click == false) click = true;
//                       });
//                     },
//                     child: Container(
//                       width: 100,
//                       padding: EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                           color: click
//                               ? Colors.deepOrangeAccent
//                               : Colors.deepOrangeAccent[100],
//                           borderRadius: BorderRadius.circular(20)
//                           // borderRadius: BorderRadius.circular(4)
//                           ),
//                       child: Center(
//                         child: Text(
//                           'Yearly',
//                           style: TextStyle(
//                               fontSize: 20,
//                               color: Colors.white,
//                               fontWeight: FontWeight.w500),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 4,
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         if (click == true) click = false;
//                       });
//                     },
//                     child: Container(
//                       width: 100,
//                       padding: EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                           color: click == false
//                               ? Colors.deepOrangeAccent
//                               : Colors.deepOrangeAccent[100],
//                           borderRadius: BorderRadius.circular(20)),
//                       child: Center(
//                         child: Text(
//                           'Monthly',
//                           style: TextStyle(
//                               fontSize: 20,
//                               color: Colors.white,
//                               fontWeight: FontWeight.w500),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 38,
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: BarChart(
//                     BarChartData(
//                       maxY: 20,
//                       barTouchData: BarTouchData(
//                           touchTooltipData: BarTouchTooltipData(
//                             tooltipBgColor: Colors.grey,
//                             getTooltipItem: (_a, _b, _c, _d) => null,
//                           ),
//                           touchCallback: (response) {
//                             if (response.spot == null) {
//                               setState(() {
//                                 touchedGroupIndex = -1;
//                                 showingBarGroups = List.of(rawBarGroups);
//                               });
//                               return;
//                             }

//                             setState(() {
//                               if (response.touchInput is PointerExitEvent ||
//                                   response.touchInput is PointerUpEvent) {
//                                 touchedGroupIndex = -1;
//                                 showingBarGroups = List.of(rawBarGroups);
//                               } else {
//                                 showingBarGroups = List.of(rawBarGroups);
//                                 if (touchedGroupIndex != -1) {
//                                   var sum = 0.0;
//                                   for (var rod
//                                       in showingBarGroups[touchedGroupIndex]
//                                           .barRods) {
//                                     sum += rod.y;
//                                   }
//                                   final avg = sum /
//                                       showingBarGroups[touchedGroupIndex]
//                                           .barRods
//                                           .length;

//                                   showingBarGroups[touchedGroupIndex] =
//                                       showingBarGroups[touchedGroupIndex]
//                                           .copyWith(
//                                     barRods: showingBarGroups[touchedGroupIndex]
//                                         .barRods
//                                         .map((rod) {
//                                       return rod.copyWith(y: avg);
//                                     }).toList(),
//                                   );
//                                 }
//                               }
//                             });
//                           }),
//                       titlesData: FlTitlesData(
//                         show: true,
//                         bottomTitles: SideTitles(
//                           showTitles: true,
//                           getTextStyles: (value) => const TextStyle(
//                               color: Color(0xff7589a2),
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14),
//                           margin: 20,
//                           getTitles: (double value) {
//                             switch (value.toInt()) {
//                               case 0:
//                                 return 'JAN';
//                               case 1:
//                                 return 'Feb';
//                               case 2:
//                                 return 'Mar';
//                               case 3:
//                                 return 'Apr';
//                               case 4:
//                                 return 'Jun';
//                               case 5:
//                                 return 'Jul';
//                               case 6:
//                                 return 'Aug';
//                               default:
//                                 return '';
//                             }
//                           },
//                         ),
//                         leftTitles: SideTitles(
//                           showTitles: true,
//                           getTextStyles: (value) => const TextStyle(
//                               color: Color(0xff7589a2),
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14),
//                           margin: 32,
//                           reservedSize: 14,
//                           getTitles: (value) {
//                             if (value == 0) {
//                               return '1K';
//                             } else if (value == 10) {
//                               return '5K';
//                             } else if (value == 19) {
//                               return '10K';
//                             } else {
//                               return '';
//                             }
//                           },
//                         ),
//                       ),
//                       borderData: FlBorderData(
//                         show: false,
//                       ),
//                       barGroups: showingBarGroups,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 12,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   bool click = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Concure'),
//       ),
//       // body: click ? yearly() : ,
//       bottomNavigationBar: 
//     );
//   }

//   BarChartGroupData makeGroupData(int x, double y1, double y2) {
//     return BarChartGroupData(barsSpace: 4, x: x, barRods: [
//       BarChartRodData(
//         y: y1,
//         colors: [leftBarColor],
//         width: width,
//       ),
//       BarChartRodData(
//         y: y2,
//         colors: [rightBarColor],
//         width: width,
//       ),
//     ]);
//   }
// }
















// // LINE CHART

// // import 'package:fl_chart/fl_chart.dart';
// // import 'package:flutter/material.dart';
