import 'package:flutter/material.dart';
import 'package:shopy/screens/complete.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:async';
import 'dart:convert';

import '../utils/api.dart';
import '../utils/utils.dart';
import '../utils/config.dart';

class PaymentSingleActivity extends StatefulWidget {
  final Map<String, String> sale;
  PaymentSingleActivity(this.sale);
  @override
  State<StatefulWidget> createState() {
    return new PaymentSingleActivityState(this.sale);
  }
}

class PaymentSingleActivityState extends State<PaymentSingleActivity> {
  bool loading = false;

  Map<String, String> sale;
  PaymentSingleActivityState(this.sale);

  TextEditingController amount = new TextEditingController();

  String paymentType = "1";

  bool started = false;
  String tempamount;

  @override
  void initState() {
    super.initState();

    tempamount = sale["total"];
    amount.text = sale["total"];
  }

  @override
  Widget build(BuildContext context) {
    return new ModalProgressHUD(
      inAsyncCall: loading,
      child: new Scaffold(
        appBar: new AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          title: new Text(
            "Payment",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 4.0,
        ),
        floatingActionButton: (double.parse(sale["total"]) <=
                (amount.text != null && amount.text.length > 0
                    ? double.parse(amount.text)
                    : 0))
            ? FloatingActionButton.extended(
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
                      sale["store_u_id"] = storeUID;
                      sale[paymentTypes[paymentType][1]] = amount.text;
                      if (double.parse(amount.text) -
                              double.parse(sale["total"]) >
                          0) {
                        sale["change"] = (double.parse(amount.text) -
                                double.parse(sale["total"]))
                            .toStringAsFixed(2);
                      }
                      sale["created_by"] = userUID;
                      sale["modified_by"] = userUID;

                      Future<bool> load = add(
                        API.SALE,
                        sale,
                      );
                      load.then((onValue) {
                        setState(() {
                          loading = false;
                        });
                        print(onValue);
                        if (onValue != null && onValue) {
                          if (sale["pay_later"] != null &&
                              sale["pay_later"].length > 0 &&
                              sale["customer_u_id"] != null &&
                              sale["customer_u_id"].length > 0) {
                            customers[sale["customer_u_id"]].amount =
                                (double.parse(customers[sale["customer_u_id"]]
                                            .amount) -
                                        double.parse(sale["pay_later"]))
                                    .toString();
                          }
                          List<dynamic> items = json.decode(sale["products"]);
                          for (var item in items) {
                            if (products[item["product_u_id"]] != null &&
                                products[item["product_u_id"]].track == "1") {
                              products[item["product_u_id"]].stock = (int.parse(
                                          products[item["product_u_id"]]
                                              .stock) -
                                      int.parse(item["quantity"]))
                                  .toString();
                            }
                          }
                          cart.clear();
                          Navigator.of(context).pushReplacement(
                              new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new CompleteActivity(sale)));
                        } else {
                          oneButtonDialog(context, "Network error",
                              "Please try again", true);
                        }
                      });
                    }
                  });
                },
                label: new Text("Charge ₹ " + sale["total"]),
                backgroundColor: Colors.black,
              )
            : null,
        bottomNavigationBar: new Container(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: new GridView.count(
            shrinkWrap: true,
            primary: false,
            crossAxisCount: 4,
            children: paymentTypes.keys.map((type) {
              return new GestureDetector(
                onTap: () {
                  if (sale["customer_u_id"] == null ||
                      sale["customer_u_id"].length == 0) {
                    if (type != "7") {
                      // pay later
                      setState(() {
                        paymentType = type;
                      });
                    }
                  } else {
                    setState(() {
                      paymentType = type;
                    });
                  }
                },
                child: new Card(
                  child: new Center(
                    child: new Text(paymentTypes[type][0]),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: new Container(
            height: MediaQuery.of(context).size.height,
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.all(15),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          new Container(
                            margin: EdgeInsets.only(left: 20),
                            child: new Text(
                              paymentTypes[paymentType][0],
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          )
                        ],
                      ),
                      new Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: new TextField(
                          cursorColor: Colors.black,
                          onChanged: (text) {
                            setState(() {
                              if (!started) {
                                started = true;
                                amount.text = (double.parse(
                                            text.substring(text.length - 1)) /
                                        100)
                                    .toStringAsFixed(2);
                              } else {
                                if (text.length > 0) {
                                  if (tempamount.length > text.length) {
                                    amount.text = (double.parse(text) / 10)
                                        .toStringAsFixed(2);
                                  } else {
                                    if (tempamount.length > 0) {
                                      amount.text = (double.parse(text) * 10)
                                          .toStringAsFixed(2);
                                    } else {
                                      amount.text = (double.parse(text) / 100)
                                          .toStringAsFixed(2);
                                    }
                                  }
                                } else {
                                  amount.text = "0.00";
                                }
                              }
                              tempamount = amount.text;
                            });
                          },
                          controller: amount,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          textAlign: TextAlign.end,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: '1',
                          ),
                          onSubmitted: (String value) {},
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
