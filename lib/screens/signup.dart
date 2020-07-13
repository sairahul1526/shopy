import 'package:flutter/material.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../utils/utils.dart';
import '../utils/api.dart';
import '../utils/config.dart';

class SignupActivity extends StatefulWidget {
  SignupActivity();

  @override
  State<StatefulWidget> createState() {
    return new SignupActivityState();
  }
}

class SignupActivityState extends State<SignupActivity> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController email = new TextEditingController();

  bool loading = false;
  SignupActivityState();

  String errorText = "";

  @override
  void initState() {
    super.initState();
  }

  void signup() {
    if (username.text.length == 0) {
      setState(() {
        errorText = "Username Required";
        loading = false;
      });
      return;
    } else {
      setState(() {
        errorText = "";
      });
    }
    if (password.text.length == 0) {
      setState(() {
        errorText = "Password Required";
        loading = false;
      });
      return;
    } else {
      setState(() {
        errorText = "";
      });
    }
    if (email.text.length == 0) {
      setState(() {
        errorText = "Email Required";
        loading = false;
      });
      return;
    } else {
      setState(() {
        errorText = "";
      });
    }
    setState(() {
      loading = true;
    });
    Future<bool> load = add(
      API.USER,
      Map.from({
        'username': username.text,
        'password': password.text,
        'email': email.text,
      }),
    );
    load.then((onValue) {
      setState(() {
        loading = false;
      });
      if (onValue != null) {
        Navigator.pop(context, "");
      } else {
        oneButtonDialog(context, "Network error", "Please try again", true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: new Text(
          "Sign Up",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 4.0,
      ),
      body: ModalProgressHUD(
        child: new Container(
          margin: new EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.1,
              25,
              MediaQuery.of(context).size.width * 0.1,
              0),
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
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
                          controller: username,
                          textInputAction: TextInputAction.go,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: 'rahul',
                          ),
                          onSubmitted: (String value) {},
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
                          obscureText: true,
                          textInputAction: TextInputAction.go,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: '******',
                          ),
                          onSubmitted: (String value) {},
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
                        "EMAIL",
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
                          controller: email,
                          textInputAction: TextInputAction.go,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: 'rahul@gmail.com',
                          ),
                          onSubmitted: (String value) {},
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
                          signup();
                        },
                        child: new Text(
                          "Sign Up",
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
                  margin: new EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: new Center(
                    child: new Text(
                      errorText.length > 0 ? errorText : "",
                      style: new TextStyle(color: Colors.black),
                    ),
                  )),
            ],
          ),
        ),
        inAsyncCall: loading,
      ),
    );
  }
}
