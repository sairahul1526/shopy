import 'package:flutter/material.dart';
import 'package:shopy/screens/login.dart';
import 'package:shopy/utils/api.dart';
import 'package:shopy/utils/config.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shopy/utils/models.dart';
import 'dart:async';

import 'package:shopy/utils/utils.dart';

class BusinessActivity extends StatefulWidget {
  BusinessActivity();
  @override
  State<StatefulWidget> createState() {
    return new BusinessActivityState();
  }
}

class BusinessActivityState extends State<BusinessActivity> {
  TextEditingController name = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController address = new TextEditingController();

  bool loading = false;
  @override
  void initState() {
    super.initState();

    getstoreapi();
  }

  void logout() {
    prefs.clear();
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (BuildContext context) => new Login()));
  }

  void getstoreapi() {
    checkInternet().then((internet) {
      if (internet == null || !internet) {
        oneButtonDialog(context, "No Internet connection", "", true);
        setState(() {
          loading = false;
        });
      } else {
        setState(() {
          loading = true;
        });
        Future<Stores> data = getStores({"store_u_id": storeUID});
        data.then((response) {
          if (response != null) {
            if (response.stores != null && response.stores.length > 0) {
              name.text = response.stores[0].name;
              email.text = response.stores[0].email;
              phone.text = response.stores[0].phone;
              address.text = response.stores[0].address;
            } else {
              logout();
            }
            if (response.meta != null && response.meta.messageType == "1") {
              oneButtonDialog(context, "", response.meta.message,
                  !(response.meta.status == STATUS_403));
            }
            setState(() {
              loading = false;
            });
          } else {
            new Timer(Duration(milliseconds: random.nextInt(5) * 1000), () {
              setState(() {
                getstoreapi();
              });
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new ModalProgressHUD(
      inAsyncCall: loading,
      child: new Scaffold(
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
            "Business Information",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 4.0,
        ),
        body: new Container(
          margin: new EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.1,
              25,
              MediaQuery.of(context).size.width * 0.1,
              0),
          child: new ListView(
            children: <Widget>[
              new Container(
                height: 15,
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
                        "NAME",
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
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: 'Sai Kirana',
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
                        "PHONE",
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
                          controller: phone,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: '9112332101',
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
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: 'sai.kirana@gmail.com',
                          ),
                          onSubmitted: (String value) {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Colors.black),
                    right: BorderSide(color: Colors.black),
                    bottom: BorderSide(color: Colors.black),
                    top: BorderSide(color: Colors.black),
                  ),
                ),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: new Container(
                        margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
                        child: new TextField(
                          cursorColor: Colors.black,
                          controller: address,
                          maxLines: 5,
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: 'Address',
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
                          setState(() {
                            loading = true;
                          });
                          checkInternet().then((internet) {
                            if (internet == null || !internet) {
                              oneButtonDialog(
                                  context, "No Internet connection", "", true);
                              setState(() {
                                loading = false;
                              });
                            } else {
                              Future<bool> load = update(
                                API.STORE,
                                Map.from({
                                  'name': name.text,
                                  'email': email.text,
                                  'phone': phone.text,
                                  'address': address.text,
                                  'modified_by': userUID,
                                }),
                                Map.from({'store_u_id': storeUID}),
                              );
                              load.then((value) {
                                setState(() {
                                  loading = false;
                                });
                                if (value != null) {
                                  storeName = name.text;
                                  Navigator.pop(context);
                                } else {
                                  oneButtonDialog(context, "Network error",
                                      "Please try again", true);
                                }
                              });
                            }
                          });
                        },
                        child: new Text(
                          "SAVE",
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
            ],
          ),
        ),
      ),
    );
  }
}
