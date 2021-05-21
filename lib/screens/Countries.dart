import 'package:covid19_tracker/model/countries.dart';
import 'package:covid19_tracker/model/covid19_dashboard.dart';
import 'package:covid19_tracker/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/country.dart';
import 'package:intl/intl.dart';
class Cont extends StatefulWidget {
  const Cont({Key key}) : super(key: key);

  @override
  _Cont createState() => _Cont();
}

class _Cont extends State<Cont> with SingleTickerProviderStateMixin{
  Covid19Dashboard data;
  AnimationController _controller;
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


   ] )));}



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


