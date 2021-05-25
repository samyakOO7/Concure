import 'dart:convert';


import 'package:covid19_tracker/screens/Indian.dart';
import 'package:covid19_tracker/screens/slot_booking.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
class VaccinebyPin extends StatefulWidget {
  @override
  _VaccinebyPinState createState() => _VaccinebyPinState();
}
Future<List<Centers>> checkavailabilty1(String p,String d)
async {
  var url = Uri.parse('https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=${p}&date=${d}');
  var response = await http.get(url);
  print("res ${response.body}");
  if (response.statusCode == 200) {
    var r=covidvaccinebypinFromJson(response.body);
    List<Centers> s=r.centers;
    print(r.toString());
    return s;
  } else {
    throw Exception('Unexpected error occured!');
  }
}
class _VaccinebyPinState extends State<VaccinebyPin> {
  List<Centers> cn;
  TextEditingController  pin = new TextEditingController();
  final dateController = TextEditingController();
  String date="";
  String pincode="";
  String t="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get Notified for Vaccine availability"),
        titleSpacing: 00.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: ()
          {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        toolbarHeight: 60.2,

      ), //AppBar
      body:Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(10),
              child: Text(
                 "Get notified for vaccine",style: TextStyle(color: Colors.deepPurpleAccent,fontSize: 25,fontWeight: FontWeight.bold),
              ),
            ),
             Container(
               alignment: Alignment.topLeft,
               padding: EdgeInsets.all(10),
               child: Text(
                 "Enter Pincode",
                style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 15,fontWeight: FontWeight.bold),
            ),
             ),
            TextField(
              controller: pin,
              decoration: InputDecoration(
                icon: Icon(Icons.location_city_sharp),
                labelText: 'Local Pin Code',
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child: Text(
                "Enter Date",
                style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 15,fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                icon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2019, 1),
                        lastDate: DateTime(2021,12),
                        builder: (BuildContext context, Widget picker){
                          return Theme(
                            //TODO: change colors
                            data: ThemeData.dark().copyWith(
                              colorScheme: ColorScheme.dark(
                                primary: Colors.deepPurpleAccent,
                                onPrimary: Colors.white,
                                surface: Colors.pink,
                                onSurface: Colors.yellow,
                              ),
                              dialogBackgroundColor:Colors.green[900],
                            ),
                            child: picker,);
                        })
                        .then((selectedDate) {
                      //TODO: handle selected date
                      if(selectedDate!=null){
                        date=DateFormat("dd-MM-yyyy").format(selectedDate);
                        dateController.text = date.toString();
                      }
                    });
                  }
                ),
                labelText: 'Date',
              ),
            ),


SizedBox(height: 20,),




                      DialogButton(
                        color: Colors.deepPurpleAccent,
                        onPressed: ()
                        {
                          t=pincode;
                          pincode=pin.text;
                          date=dateController.text;
                          setState(() {
                            checkavailabilty1(pincode,date).then((value) {
                              cn = value;
                            });
                          });

                        },
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),





            Expanded(
              child: Center(
                child: (cn==null) ? Text("Enter PinCode"):
                ListView.builder(
                    itemCount: cn==null?0:cn.length,
                    itemBuilder: (BuildContext context, int index) {
                      Centers cdata=cn[index];
                      List<Session> s=cdata.sessions;
                      List<VaccineFee> v=cdata.vaccineFees;
                      int i=0;
                      Session sdata=s[i];
                      i<=s.length?++i:0;
                      return  Container(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ExpandableNotifier(// <-- Provides ExpandableController to its children
                              child: Row(
                                children: [
                                  SizedBox(
                                    width:MediaQuery.of(context).size.width-60.5,
                                    child: Expandable(// <-- Driven by ExpandableController from ExpandableNotifier
                                      collapsed: ExpandableButton(// <-- Expands when tapped on the cover photo
                                        child: Padding(
                                          padding: MediaQuery.of(context).padding,
                                          child: Text('${cdata.name}'),
                                        ),
                                      ),
                                      expanded: Column(
                                          children: [
                                            Padding(
                                                padding: MediaQuery.of(context).padding,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: <Widget>[
                                                    Container(
                                                        child: Row(
                                                            children: [
                                                              IconButton(
                                                                icon: Icon(Icons.coronavirus),
                                                                onPressed: (){},
                                                              ),
                                                              Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children:[
                                                                    Text(
                                                                        'Vaccine ${sdata.vaccine}= ${sdata.availableCapacity}',
                                                                        style: TextStyle(
                                                                          fontFamily: 'Montserrat',
                                                                          fontSize: 17.0,
                                                                          fontWeight: FontWeight.bold,
                                                                        )
                                                                    ),
                                                                    Text(
                                                                      '${cdata.address}',
                                                                      style: TextStyle(
                                                                        fontFamily: 'Montserrat',
                                                                        fontSize: 17.0,
                                                                        color: Colors.black87,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      'Fee : ${cdata.feeType}',
                                                                      style: TextStyle(
                                                                        fontFamily: 'Montserrat',
                                                                        fontSize: 17.0,
                                                                        color: Colors.black87,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                        'Tag ${sdata.minAgeLimit}+',
                                                                        style: TextStyle(
                                                                          fontFamily: 'Montserrat',
                                                                          fontSize: 17.0,
                                                                          color: Colors.black87,
                                                                          fontWeight: FontWeight.bold,
                                                                        )
                                                                    ),
                                                                  ]
                                                              )
                                                            ]
                                                        )
                                                    ),
                                                    ExpandableButton(
                                                      child:Icon(Icons.keyboard_arrow_up),
                                                    )
                                                  ],
                                                )
                                            ),
                                            // Text(' Fee Type ${cdata.feeType}'),
                                            // Text('Vaccine Available: ${sdata.vaccine}= ${sdata.availableCapacity}'),
                                            // Text('Tag ${sdata.minAgeLimit}+'),
                                            // Text('Date;  ${sdata.date}'),
                                            // ExpandableButton(       // <-- Collapses when tapped on
                                            //   child: Text("Back"),
                                            // ),
                                          ]
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    height: 20,
                                    thickness: 5,
                                    indent: 20,
                                    endIndent: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                      //   ListTile(
                      //   title: Text('${cdata.name}'),
                      // );
                    }
                ),
              ),
            ),
          ],
        ),
      ), //Center
    );
  }
}