import 'package:flutter/material.dart';
import 'package:shopy/screens/business.dart';

class SettingsActivity extends StatefulWidget {
  SettingsActivity();
  @override
  State<StatefulWidget> createState() {
    return new SettingsActivityState();
  }
}

class SettingsActivityState extends State<SettingsActivity> {
  TextEditingController name = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController address = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context, "");
            }),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: new Text(
          "Settings",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 4.0,
      ),
      body: new Container(
        margin: new EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.1,
            25, MediaQuery.of(context).size.width * 0.1, 0),
        child: new ListView(
          children: <Widget>[
            new Container(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text("Test"),
                ],
              ),
            ),
            new Container(
              height: 10,
            ),
            new Container(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    "Sai Kirana",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              height: 40,
            ),
            // new Container(
            //   child: new Text(
            //     "BUSINESS INFORMATION",
            //     style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //       fontSize: 14,
            //     ),
            //   ),
            // ),
            new GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new BusinessActivity()),
                );
              },
              child: new Container(
                color: Colors.transparent,
                height: 30,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: new Text(
                        "Business Information",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    new Icon(
                      Icons.arrow_right,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            new GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new BusinessActivity()),
                );
              },
              child: new Container(
                color: Colors.transparent,
                height: 30,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: new Text(
                        "Printer",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    new Icon(
                      Icons.arrow_right,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            new GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new BusinessActivity()),
                );
              },
              child: new Container(
                color: Colors.transparent,
                height: 30,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: new Text(
                        "Sales Tax",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    new Icon(
                      Icons.arrow_right,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
