
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';

import 'dart:async';

import 'package:http/http.dart' as http;
class Indian extends StatefulWidget {
  const Indian({Key key}) : super(key: key);

  @override
  _Indian createState() => _Indian ();
}

class _Indian extends State<Indian> {
  var url="https://api.apify.com/v2/key-value-stores/toDWvRj1JpTXiM8FF/records/LATEST?disableRedirect=true";
  List data;
@override
  void initState()
  {
    super.initState();
    this.getJsonData();
  }
  // ignore: missing_return
  Future<String> getJsonData() async {
    var response = await http.get(Uri.encodeFull(url),headers: {'Accept':'application/json'});
    setState(() {
      dynamic convertJson = jsonDecode(response.body);
      data=convertJson['regionData'];
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
    body: ListView.builder(
      itemCount: data==null?0:data.length,
      itemBuilder: (BuildContext context, int index){
        return new Container(
          child: new Center(child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Card(
                child: ExpansionTile(
              title: Text(
                  data[index]['region'],style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),),
                    children: <Widget>[
                    ListTile(

              title: Text('Active Cases:  '+data[index]['activeCases'].toString(),style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400,color: Colors.red),),

                /*new Container(child: new Text(data[index]['region']),padding: const EdgeInsets.all(20),),*/

              ),
                      ListTile(
                        title: Text('Total Recovered:  '+data[index]['recovered'].toString()+'      '+'Newly Recovered:  '+data[index]['newRecovered'].toString(),style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400,color: Colors.green),),

                        /*new Container(child: new Text(data[index]['region']),padding: const EdgeInsets.all(20),),*/

                      ),
                      ListTile(
                        title: Text('Total Decreased:  '+data[index]['deceased'].toString()+'            '+'Newly Decreased:  '+data[index]['newDeceased'].toString(),style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400,color: Colors.indigo),),

                        /*new Container(child: new Text(data[index]['region']),padding: const EdgeInsets.all(20),),*/

                      ),
                      ListTile(
                        title: Text('Total Infected:  '+data[index]['totalInfected'].toString()+'            '+'Newly Infected:  '+data[index]['newInfected'].toString(),style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400,color: Colors.indigo),),

                        /*new Container(child: new Text(data[index]['region']),padding: const EdgeInsets.all(20),),*/

                      ),
                    ])
              )
            ],
          ),),
        );
      }
    ));
  }



  
}