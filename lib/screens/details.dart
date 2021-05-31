import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  String title, author, urlToImage, publishedAt, description;
  DetailsPage(
      {this.title,
        this.author,
        this.description,
        this.publishedAt,
        this.urlToImage});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        centerTitle: true,
        title: Text('Covid News'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Stack(
          children: <Widget>[
            Image.network(
              widget.urlToImage,
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
            ),
            // SizedBox(height: 200,),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 300.0, 0.0, 0.0),
              child: Container(
                // height: MediaQuery.of(context).size.height-500,
                width: MediaQuery.of(context).size.width,
                child: Material(
                  borderRadius: BorderRadius.circular(35.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Text(
                        widget.publishedAt.substring(0, 10),
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.redAccent,
                          fontWeight:  FontWeight.w500
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      Text(
                        widget.author,
                        style: TextStyle(fontSize: 15.0),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}