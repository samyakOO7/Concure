import 'package:covid19_tracker/model/constants.dart';
import 'package:covid19_tracker/screens/slot_booking.dart';
import 'package:covid19_tracker/services/networking.dart';
import 'package:covid19_tracker/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get_storage/get_storage.dart';

class VaccinebyPin extends StatefulWidget {
  @override
  _VaccinebyPinState createState() => _VaccinebyPinState();
}


class _VaccinebyPinState extends State<VaccinebyPin> {
  final box = GetStorage();
  Future<List<Centers>> checkavailabilty1(String p, String d) async {
    // print("pincode "+p);
    // print("date "+d);

    var url = Uri.parse(
        'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=${p}&date=${d}');
    var response = await http.get(url);
    // print("res ${response.body}");
    if (response.statusCode == 200) {
      var r = covidvaccinebypinFromJson(response.body);
      List<Centers> s = r.centers;
      box.write('state_name', '${s[0].stateName}');
      box.write('district_name', '${s[0].districtName}');
      Networking n=new Networking();
       n.get_notified();
      checkAvailability2();
      return s;
    } else {
      throw Exception('Unexpected error occured!');
    }
  }
  List<Centers> cn;
  TextEditingController pin = new TextEditingController();
  final dateController = TextEditingController();
  String date = "";
  String pincode = "";
  String t = "";
  // bool find = true;
  var no_slots;
  // static  String click = "OK";

  @override
  Widget build(BuildContext context) {
    Color theme = Colors.green;

    return Scaffold(
        appBar: AppBar(
          title: Text("Get Notified for Vaccine"),
          titleSpacing: 00.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_outlined),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          toolbarHeight: 60.2,
        ), //AppBar
        body: Container(
            padding: EdgeInsets.all(10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Get notified for vaccine",
                      style: TextStyle(
                          // color: Colors.deepPurpleAccent,
                        color:theme,

                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Enter Pincode",
                      style: TextStyle(
                          // color: Colors.deepPurpleAccent,
                        color : theme,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
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
                      style: TextStyle(
                          // color: Colors.deepPurpleAccent,
                        color:theme,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
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
                                lastDate: DateTime(2021, 12),
                                builder: (BuildContext context, Widget picker) {
                                  return Theme(
                                    //TODO: change colors
                                    data: ThemeData.dark().copyWith(
                                      colorScheme: ColorScheme.dark(
                                        primary: Colors.deepPurpleAccent,
                                        onPrimary: Colors.white,
                                        // surface: Colors.pink,
                                        surface: constant.downbar,
                                        onSurface: Colors.yellow,
                                      ),
                                      // dialogBackgroundColor: Colors.green[900],
                                      dialogBackgroundColor: constant.downbar,
                                    ),
                                    child: picker,
                                  );
                                }).then((selectedDate) {
                              //TODO: handle selected date
                              if (selectedDate != null) {
                                date = DateFormat("dd-MM-yyyy")
                                    .format(selectedDate);
                                dateController.text = date.toString();
                              }
                            });
                          }),
                      labelText: 'Date',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),


                  GestureDetector(
                    onTap: () async {
                      t = pincode;
                      pincode = pin.text;
                      date = dateController.text;
                      box.write('pincode', pincode.toString());
                      box.write('date', date);
                      // print(click);
                      setState(() async {
                        cn = await checkavailabilty1(pincode, date);
                        // for(Centers  c in cn)
                        //   print(c);
                        setState(() {});
                      }
                      );
                    },
                    child: Container(

                      height: 50,
                      width: MediaQuery.of(context).size.width-160,
                      decoration: BoxDecoration(
                        color: theme,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepOrangeAccent,
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                            offset: Offset(2.0, 1.0), // shadow direction: bottom right
                          )
                        ],
                      ),
                      child: Center(

                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.white, fontSize: 23),
                        ),
                      ),

                    ),
                  ),
                  // SizedBox(height: 10,),
                  // Divider(color: Colors.blueGrey,thickness: 1,),
                  SizedBox(height: 30,),
                  Expanded(
                      child: Center(
                          child: ListView.builder(
                              itemCount: cn == null ? 0 : cn.length,
                              itemBuilder: (BuildContext context, int index) {
                                Centers cdata = cn[index];
                                List<Session> s = cdata.sessions;
                                // print("sessions length "+s.length.toString());
                                bool fortyfive = false;
                                bool eighteen = false;

                                for(Session si in s)
                                  {
                                    String date1 = si.date.toString();

                                    int age = int.parse(si.minAgeLimit.toString());
                                    // print("date check : "+(date1==date).toString());
                                  if(date1 == date) {
                                    if (age == 18)
                                      eighteen = true;
                                    else if (age == 45)
                                      fortyfive = true;
                                  }

                                    // print("min age limit is "+si.minAgeLimit.toString());
                                  }

                                // print("forty "+fortyfive.toString());
                                // print("eight "+eighteen.toString());


                                // for(Session si in s)
                                //   print("sessions are "+si.toString());
                                List<VaccineFee> v = cdata.vaccineFees;
                                int i = 0;

                                Session sdata = s[i];
                                // print("sdata "+sdata.toString());


                                i <= s.length ? ++i : 0;
                                int slots = sdata.slots.length;
                                // print("slots ares"+sdata.s);


                                // print("here slots " + sdata.slots.toString());

                                List<Widget> ls = new List();

                                for (String s in sdata.slots) {
                                  ls.add(new Text(
                                    s + "    ",
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.red),
                                  ),
                                  );
                                  ls.add(   SizedBox(height: 7,));

                                }

                                return Container(
                                    child: Center(
                                        child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: new Container(
                                      child: ExpansionTile(
                                    title: Text(
                                      cdata.name,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    children: <Widget>[
                                      ListTile(
                                        title: Text(
                                          cdata.districtName +
                                              ", " +
                                              cdata.stateName +
                                              ", " +
                                              cdata.pincode.toString(),
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.red),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          sdata.date +
                                              ", \nAvailable for   :  "+ (eighteen?"18+ ":"")+(fortyfive?",45+ ":"")+""+"\n"+
                                              sdata.vaccine+
                                          "  : " +
                                          sdata.availableCapacity.toString(),
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.red),
                                        ),
                                      ),
                                      ListTile(
                                        title: Container(
                                          child: Column(children: <Widget>[
                                            Text(
                                              "Time slots",
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.red),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: ls,
                                              ),
                                            ),
                                          ]),
                                        ),

                                        // onPressed:
                                        leading:  sdata.availableCapacity > 0 ? GestureDetector(
                                          onTap: (){
                                            try {
                                              launch('https://cowin.gov.in/home');
                                            } on Exception catch (e) {
                                              print(e);
                                            }
                                          },
                                          child: Container(
                                            // semanticContainer: true,
                                            // elevation: 2,
                                            // shadowColor: Colors.green,
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.red,
                                                  blurRadius: 2.0,
                                                  spreadRadius: 0.0,
                                                  offset: Offset(2.0, 1.0), // shadow direction: bottom right
                                                )
                                              ],
                                              
                                              color:Colors.green,
                                              borderRadius: BorderRadius.circular(30),
                                            ),

                                            child: Text(
                                              "Book now ",
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ):
                                            Container(child: Text(
                                              "Not Available",
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black),
                                            ),)

                                      ),
                                    ],
                                  )),

                                  /*ExpandableNotifier(// <-- Provides ExpandableController to its children
                              child: Column(
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
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: <Widget>[
                                                    Container(
                                                        child: Column(
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
                                  ),*/
                                )));
                              })))
                ])));
  }
}
