import 'package:flutter/material.dart';
import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shopy/screens/dashboard.dart';

import '../utils/utils.dart';
import '../utils/api.dart';
import '../utils/config.dart';
import '../utils/models.dart';

class StoreActivity extends StatefulWidget {
  StoreActivity();

  @override
  State<StatefulWidget> createState() {
    return new StoreActivityState();
  }
}

class StoreActivityState extends State<StoreActivity> {
  TextEditingController name = new TextEditingController();
  TextEditingController address = new TextEditingController();

  bool loading = false;
  StoreActivityState();

  String errorText = "";

  @override
  void initState() {
    super.initState();
  }

  void addstore() {
    setState(() {
      loading = true;
    });
    Future<bool> load = add(
      API.STORE,
      Map.from({
        'name': name.text,
        'address': address.text,
        'created_by': userUID,
        'modified_by': userUID,
      }),
    );
    load.then((onValue) {
      if (onValue != null && onValue) {
        new Timer(const Duration(seconds: 1), () {
          Future<Stores> storeResponse = getStores(Map.from({
            'name': name.text,
          }));
          storeResponse.then((response) {
            if (response == null ||
                response.meta == null ||
                response.meta.status != "200") {
              setState(() {
                loading = false;
              });
            } else {
              if (response.stores.length == 0) {
                setState(() {
                  loading = false;
                });
              } else {
                Future<bool> load = update(
                  API.USER,
                  Map.from({
                    'store_u_id': response.stores[0].storeUID,
                    'modified_by': userUID,
                  }),
                  Map.from({
                    'user_u_id': userUID,
                  }),
                );

                load.then((value) {
                  setState(() {
                    loading = false;
                  });
                  if (value != null && value) {
                    storeName = response.stores[0].name;
                    storeUID = response.stores[0].storeUID;
                    prefs.setString('storeName', response.stores[0].name);
                    prefs.setString('storeUID', response.stores[0].storeUID);

                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new DashBoardActivity(true)));
                  }
                });
              }
            }
          });
        });
      } else {
        setState(() {
          loading = false;
        });
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
          "New Store",
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
                          textInputAction: TextInputAction.go,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: 'Rahul Kirana Store',
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
                          addstore();
                        },
                        child: new Text(
                          "Add",
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
