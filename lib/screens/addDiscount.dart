import 'package:flutter/material.dart';

import '../utils/utils.dart';

class AddDiscountActivity extends StatefulWidget {
  final String amount;
  final bool type;

  AddDiscountActivity(this.type, this.amount);

  @override
  State<StatefulWidget> createState() {
    return new AddDiscountActivityState(this.type, this.amount);
  }
}

class AddDiscountActivityState extends State<AddDiscountActivity> {
  TextEditingController discount = new TextEditingController();

  bool type;
  String amount;

  String tempamount;

  AddDiscountActivityState(this.type, this.amount);

  @override
  void initState() {
    super.initState();

    this.discount.text = amount;
    tempamount = amount;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: new Container(
          child: new FlatButton(
            onPressed: () {
              if (discount.text.length > 0) {
                Navigator.pop(context, [type, discount.text]);
              } else {
                Navigator.pop(context, []);
              }
            },
            child: new Text("APPLY"),
          ),
        ),
        elevation: 0,
      ),
      appBar: new AppBar(
        backgroundColor: Colors.white,
        title: new Text(
          "Discount",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              setState(() {
                discount.text = "";
              });
            },
            child: new Text("Clear"),
          ),
        ],
        elevation: 4.0,
      ),
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: new Container(
          height: MediaQuery.of(context).size.height,
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
                    new Expanded(
                      child: new Container(
                        margin: EdgeInsets.only(left: 15),
                        child: new TextField(
                          cursorColor: Colors.black,
                          controller: discount,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: type ? "0 %" : "₹ 0.00",
                          ),
                          onChanged: (String text) {
                            setState(() {
                              if (text.length > 0) {
                                if (double.parse(text) > 0) {
                                  if (tempamount.length > text.length) {
                                    discount.text = (double.parse(text) / 10)
                                        .toStringAsFixed(2);
                                  } else {
                                    if (tempamount.length > 0) {
                                      discount.text = (double.parse(text) * 10)
                                          .toStringAsFixed(2);
                                    } else {
                                      discount.text = (double.parse(text) / 100)
                                          .toStringAsFixed(2);
                                    }
                                  }
                                } else {
                                  discount.text = "";
                                }
                              }
                              tempamount = discount.text;
                            });
                          },
                          onSubmitted: (String value) {},
                        ),
                      ),
                    ),
                    new Container(
                      margin: EdgeInsets.only(right: 15),
                      child: new CustomSwitch(
                        activeColor: Colors.black,
                        value: type,
                        offString: "₹",
                        onString: "%",
                        onChanged: (value) {
                          setState(() {
                            type = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
