import 'package:covid19_tracker/model/countries.dart';
import 'package:covid19_tracker/model/covid19_dashboard.dart';
import 'package:covid19_tracker/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/country.dart';
import 'package:intl/intl.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'Indian.dart';
import 'dashboard.dart';
class Cont extends StatefulWidget {
  const Cont({Key key}) : super(key: key);

  @override
  _Cont createState() => _Cont();
}

class _Cont extends State<Cont> with SingleTickerProviderStateMixin{
  Covid19Dashboard data;
  AnimationController _controller;
  var _selectedIndex = 0;
  final formatter = NumberFormat.decimalPattern('en-US');
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    getData();
    //_controller.forward();
  }
  Future<void> getData() async {
    Networking network = Networking();
    Covid19Dashboard result = await network.getDashboardData();
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
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          var item = data.countries[index];
          return buildExpansionTile(item, index);
        }, childCount: data.countries.length),
      )


   ], ),),
      bottomNavigationBar:  Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen(),),);
                  },
                ),
                GButton(
                  icon: Icons.find_in_page,
                  iconColor: Colors.purpleAccent,
                  text: 'Countries',
                  backgroundColor: Colors.purple[100],
                  textColor: Colors.purple,
                  iconActiveColor: Colors.purpleAccent[200],
                  // onPressed: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => Cont()),
                  //   );
                  //
                  // },
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
//
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => MytestApp()),
                    // );
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
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => MytestApp()),
                    // );
                  },
                ),
              ],
              selectedIndex: 1,
              // onTabChange: (index) {
              //   setState(() {
              //     _selectedIndex = index;
              //   });
              // },
            ),
          ),
        ),
      ),

    );}



  ExpansionTile buildExpansionTile(Countries item, int index) {
    return ExpansionTile(

      leading: item.countryCode.length == 2
          ? CountryPickerUtils.getDefaultFlagImage(
          Country(isoCode: item.countryCode))
          : Text(''),
      title: Text('${item.country}'),
      trailing: Text('${formatter.format(item.confirmed)}'),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                buildDetailText(
                    color: Colors.black, count: index + 1, text: 'Rank'),
                buildDetailText(
                    color: Colors.blue, count: item.active, text: 'Active'),
                buildDetailText(
                    color: Colors.green,
                    count: item.recovered,
                    text: 'Recovered'),
                buildDetailText(
                    color: Colors.red, count: item.deaths, text: 'Deaths'),
              ]),
            ],
          ),
        )
      ],
    );
  }
  Widget buildDetailText({int count, Color color, String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        '$text: ${formatter.format(count)}',
        style: TextStyle(color: color),
      ),
    );
  }





}


