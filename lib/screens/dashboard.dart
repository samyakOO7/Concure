import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:covid19_tracker/model/countries.dart';
import 'package:covid19_tracker/model/covid19_dashboard.dart';
import 'package:covid19_tracker/screens/Countries.dart';
import 'package:covid19_tracker/screens/Indian.dart';
import 'package:covid19_tracker/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/country.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  Covid19Dashboard data;
  AnimationController _controller;
  Animation _curvedAnimation;
 var _selectedIndex=0;
  PageController _pageController;
  @override
  void initState() {

    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _curvedAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);


    _pageController = PageController();
    getData();
    //_controller.forward();
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
                          color: Colors.black,
                          count: data.confirmed),
                      buildSummerCard(
                          text: 'Active',
                          color: Colors.blue,
                          count: data.active),
                      buildSummerCard(
                          text: 'Recovered',
                          color: Colors.green,
                          count: data.recovered),
                      buildSummerCard(
                          text: 'Deaths',
                          color: Colors.red,
                          count: data.deaths),
                    ]),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text('Result date: ${data.date}'),
                      ),
                    )
                  ])),

                ],
              )
              //  ListView.builder(
              //     itemCount: data.countries.length,
              //     itemBuilder: (context, index) {
              //       var item = data.countries[index];
              //       return buildExpansionTile(item, index);
              //     }),
              ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() => _selectedIndex = index);

         setState(() {
           if(_selectedIndex==1)
           {
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => Cont()),
             );
           }
           else if(_selectedIndex==2)
           {Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => Indian()));

           }
         });
        },
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.apps),
            title: Text('Home'),
            activeColor: Colors.red,

          ),
          BottomNavyBarItem(
              icon: Icon(Icons.find_in_page_rounded),
              title: Text('Countries'),
              activeColor: Colors.purpleAccent
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.countertops),
              title: Text('States'),
              activeColor: Colors.pink
          ),
          BottomNavyBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings'),
              activeColor: Colors.blue
          ),
        ],
      )

    );
  }

  Widget buildSummerCard({int count, Color color, String text}) {
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

  final formatter = NumberFormat.decimalPattern('en-US');


}
