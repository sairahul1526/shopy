import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:shopy/screens/signup.dart';
import 'package:shopy/utils/api.dart';
import 'package:shopy/utils/models.dart';

import './dashboard.dart';
import '../utils/config.dart';
import '../utils/utils.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginState();
  }
}

class LoginState extends State<Login> {
  FocusNode textSecondFocusNode = new FocusNode();

  TextEditingController name = new TextEditingController();
  TextEditingController password = new TextEditingController();

  bool loggedIn = false;
  bool wrongCreds = false;

  String onesignalUserId = "";

  @override
  void initState() {
    super.initState();
  }

  void login() {
    checkInternet().then((internet) {
      if (internet == null || !internet) {
        oneButtonDialog(context, "No Internet connection", "", true);
        setState(() {
          loggedIn = false;
        });
      } else {
        setState(() {
          loggedIn = true;
        });
        Future<Users> userResponse = getUsers(Map.from({
          'username': name.text,
          'password': password.text,
        }));
        userResponse.then((response) {
          if (response == null ||
              response.meta == null ||
              response.meta.status != "200") {
            setState(() {
              loggedIn = false;
            });
          } else {
            if (response.users.length == 0) {
              setState(() {
                loggedIn = false;
                wrongCreds = true;
              });
            } else {
              prefs.setString('username', response.users[0].username);
              prefs.setString('userUID', response.users[0].userUID);
              prefs.setString('storeUID', response.users[0].storeUID);
              username = response.users[0].username;
              userUID = response.users[0].userUID;
              storeUID = response.users[0].storeUID;
              Future<Stores> storeResponse = getStores(Map.from({
                'store_u_id': storeUID,
              }));
              storeResponse.then((response) {
                if (response != null &&
                    response.stores != null &&
                    response.stores.length > 0) {
                  prefs.setString('storeName', response.stores[0].name);
                  storeName = response.stores[0].name;

                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new DashBoardActivity(true)));
                } else {
                  setState(() {
                    loggedIn = false;
                  });
                  prefs.clear();
                }
              });
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: ModalProgressHUD(
        child: new Container(
          margin: new EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.1,
              100,
              MediaQuery.of(context).size.width * 0.1,
              0),
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              new SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.width * 0.4,
                // child: new Image.asset('assets/appicon.png'),
              ),
              new Center(
                child: new Container(
                  margin: EdgeInsets.only(top: 10),
                  child: new Text("Shopy"),
                ),
              ),
              new Container(
                height: 50,
              ),
              new Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Colors.black),
                    right: BorderSide(color: Colors.black),
                    top: BorderSide(color: Colors.black),
                  ),
                ),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      margin: EdgeInsets.only(left: 15),
                      child: new Text(
                        "USERNAME",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    new Expanded(
                      child: new Container(
                        child: new TextField(
                          cursorColor: Colors.black,
                          controller: name,
                          autocorrect: false,
                          autofocus: true,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: 'rahul',
                          ),
                          onSubmitted: (String value) {
                            FocusScope.of(context)
                                .requestFocus(textSecondFocusNode);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Colors.black),
                    right: BorderSide(color: Colors.black),
                    top: BorderSide(color: Colors.black),
                    bottom: BorderSide(color: Colors.black),
                  ),
                ),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      margin: EdgeInsets.only(left: 15),
                      child: new Text(
                        "PASSWORD",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    new Expanded(
                      child: new Container(
                        child: new TextField(
                          cursorColor: Colors.black,
                          controller: password,
                          focusNode: textSecondFocusNode,
                          obscureText: true,
                          textInputAction: TextInputAction.go,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: '*******',
                          ),
                          onSubmitted: (String value) {
                            login();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                decoration: new BoxDecoration(
                  color: Colors.black,
                ),
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new FlatButton(
                        onPressed: () {
                          login();
                        },
                        child: new Text(
                          "Log In",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                child: new MaterialButton(
                  height: 40,
                  child: new Text(
                    "Don't have an account yet?\nSign Up.",
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new SignupActivity()));
                  },
                ),
              ),
              new Container(
                margin: new EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: new Center(
                  child: new Text(
                    wrongCreds ? "Incorrect Username/Password" : "",
                    style: new TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
        inAsyncCall: loggedIn,
      ),
    );
  }
}
