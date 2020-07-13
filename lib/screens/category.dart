import 'package:flutter/material.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shopy/utils/api.dart';
import 'package:shopy/utils/config.dart';
import 'package:shopy/utils/models.dart';
import 'package:shopy/utils/utils.dart';

class CategoryActivity extends StatefulWidget {
  final Category category;
  CategoryActivity(this.category);
  @override
  State<StatefulWidget> createState() {
    return new CategoryActivityState(category);
  }
}

class CategoryActivityState extends State<CategoryActivity> {
  TextEditingController name = new TextEditingController();

  bool loading = false;

  Category category;
  CategoryActivityState(this.category);
  @override
  void initState() {
    super.initState();

    if (category != null) {
      name.text = category.name;
    }
  }

  void categoryapi() {
    setState(() {
      loading = true;
    });

    checkInternet().then((internet) {
      if (internet == null || !internet) {
        oneButtonDialog(context, "No Internet connection", "", true);
        setState(() {
          loading = false;
        });
      } else {
        if (name.text.length == 0) {
          oneButtonDialog(context, "Please enter category name", "", true);
          setState(() {
            loading = false;
          });
          return;
        }

        Future<bool> load;
        if (category != null) {
          load = update(
            API.CATEGORY,
            Map.from({
              "name": name.text,
              'modified_by': userUID,
            }),
            Map.from({"category_u_id": category.categoryUID}),
          );
        } else {
          load = add(
            API.CATEGORY,
            Map.from({
              "store_u_id": storeUID,
              "name": name.text,
              'created_by': userUID,
              'modified_by': userUID,
            }),
          );
        }
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return new ModalProgressHUD(
      inAsyncCall: loading,
      child: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white,
          title: new Text(
            (category != null ? "Edit" : "New") + " Category",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 4.0,
          actions: <Widget>[
            new IconButton(
              onPressed: () {
                Future<bool> dialog = twoButtonDialog(
                    context,
                    "Delete category",
                    "When you delete a category, the products remain saved but with no category assigned to them");

                dialog.then((onValue) {
                  if (onValue) {
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
                          API.CATEGORY,
                          Map.from({
                            'status': '0',
                            'modified_by': userUID,
                          }),
                          Map.from({'category_u_id': category.categoryUID}),
                        );
                        load.then((value) {
                          setState(() {
                            loading = false;
                          });
                          if (onValue != null) {
                            Navigator.pop(context, "");
                          } else {
                            oneButtonDialog(context, "Network error",
                                "Please try again", true);
                          }
                        });
                      }
                    });
                  }
                });
              },
              icon: new Icon(Icons.delete),
            ),
          ],
        ),
        body: new Container(
          margin: new EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width * 0.1,
            25,
            MediaQuery.of(context).size.width * 0.1,
            0,
          ),
          child: new ListView(
            shrinkWrap: true,
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
                        "NAME",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    new Expanded(
                      child: new Container(
                        padding: EdgeInsets.only(right: 15),
                        child: new TextField(
                          cursorColor: Colors.black,
                          controller: name,
                          textInputAction: TextInputAction.done,
                          textAlign: TextAlign.end,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: 'Staples & Oils',
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
                          categoryapi();
                        },
                        child: new Text(
                          category == null ? "ADD" : "SAVE",
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
