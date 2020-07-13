import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shopy/screens/login.dart';
import 'dart:io' show Platform;
import 'dart:async';

import './screens/dashboard.dart';
import './utils/config.dart';
import './utils/utils.dart';

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Shopy",
    home: new MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
        brightness: Brightness.light,
      ),
      title: 'Shopy',
      home: MyHomePage(title: 'Shopy'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    checkVibration();
    if (Platform.isAndroid) {
      headers["appversion"] = APPVERSION.ANDROID;
      if (kReleaseMode) {
        headers["apikey"] = APIKEY.ANDROID_LIVE;
      } else {
        headers["apikey"] = APIKEY.ANDROID_TEST;
      }
    } else {
      headers["appversion"] = APPVERSION.IOS;
      if (kReleaseMode) {
        headers["apikey"] = APIKEY.IOS_LIVE;
      } else {
        headers["apikey"] = APIKEY.IOS_TEST;
      }
    }

    Future.delayed(Duration(seconds: 1), () {
      Future<bool> prefInit = initSharedPreference();
      prefInit.then((onValue) {
        if (onValue) {
          if (prefs.getString("username") != null &&
              prefs.getString("username").length > 0) {
            username = prefs.getString("username");
            userUID = prefs.getString("userUID");
            storeUID = prefs.getString("storeUID");
            storeName = prefs.getString("storeName");
            phone = prefs.getString("phone");
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (BuildContext context) =>
                    new DashBoardActivity(true)));
          } else {
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (BuildContext context) => new Login()));
          }
        } else {
          Navigator.of(context).pushReplacement(new MaterialPageRoute(
              builder: (BuildContext context) => new Login()));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: new Center(
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    "Shopy",
                    style: new TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
