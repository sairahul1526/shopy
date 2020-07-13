import 'package:flutter/material.dart';
import 'package:shopy/screens/complete.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:async';
import 'dart:convert';

import '../utils/api.dart';
import '../utils/utils.dart';
import '../utils/config.dart';

class PaymentActivity extends StatefulWidget {
  final Map<String, String> sale;
  PaymentActivity(this.sale);
  @override
  State<StatefulWidget> createState() {
    return new PaymentActivityState(this.sale);
  }
}

class PaymentActivityState extends State<PaymentActivity> {
  bool loading = false;

  Map<String, String> sale;
  PaymentActivityState(this.sale);

  TextEditingController cash = new TextEditingController();
  TextEditingController card = new TextEditingController();
  TextEditingController check = new TextEditingController();
  TextEditingController voucher = new TextEditingController();
  TextEditingController storeCredit = new TextEditingController();
  TextEditingController paytm = new TextEditingController();
  TextEditingController payLater = new TextEditingController();
  TextEditingController other = new TextEditingController();

  bool enableCash = true;
  bool enableCard = false;
  bool enableCheck = false;
  bool enableVoucher = false;
  bool enableStoreCredit = false;
  bool enablePaytm = false;
  bool enablePayLater = false;
  bool enableOther = false;

  @override
  void initState() {
    super.initState();

    cash.text = sale["total"];
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
        floatingActionButton: double.parse(sale["total"]) ==
                ((enableCash && cash.text != null && cash.text.length > 0
                        ? double.parse(cash.text)
                        : 0) +
                    (enableCard && card.text != null && card.text.length > 0
                        ? double.parse(card.text)
                        : 0) +
                    (enableCheck && check.text != null && check.text.length > 0
                        ? double.parse(check.text)
                        : 0) +
                    (enableVoucher &&
                            voucher.text != null &&
                            voucher.text.length > 0
                        ? double.parse(voucher.text)
                        : 0) +
                    (enableStoreCredit &&
                            storeCredit.text != null &&
                            storeCredit.text.length > 0
                        ? double.parse(storeCredit.text)
                        : 0) +
                    (enablePaytm && paytm.text != null && paytm.text.length > 0
                        ? double.parse(paytm.text)
                        : 0) +
                    (enablePayLater &&
                            payLater.text != null &&
                            payLater.text.length > 0
                        ? double.parse(payLater.text)
                        : 0) +
                    (enableOther && other.text != null && other.text.length > 0
                        ? double.parse(other.text)
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
                      sale["cash"] = cash.text != null ? cash.text : "";
                      sale["card"] = card.text != null ? card.text : "";
                      sale["check"] = check.text != null ? check.text : "";
                      sale["voucher"] =
                          voucher.text != null ? voucher.text : "";
                      sale["store_credit"] =
                          storeCredit.text != null ? storeCredit.text : "";
                      sale["paytm"] = paytm.text != null ? paytm.text : "";
                      sale["pay_later"] =
                          payLater.text != null ? payLater.text : "";
                      sale["other"] = other.text != null ? other.text : "";
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
                          if (sale["pay_later"].length > 0 &&
                              sale["customer_u_id"].length > 0) {
                            customers[sale["customer_u_id"]].amount =
                                (double.parse(customers[sale["customer_u_id"]]
                                            .amount) -
                                        double.parse(sale["pay_later"]))
                                    .toString();
                          }
                          List<dynamic> items = json.decode(sale["products"]);
                          for (var item in items) {
                            if (products[item["product_u_id"]].track == "1") {
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
              )
            : null,
        bottomNavigationBar: new Container(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: new GridView.count(
            shrinkWrap: true,
            primary: false,
            crossAxisCount: 4,
            children: <Widget>[
              new GestureDetector(
                onTap: () {
                  setState(() {
                    enableCash = true;
                  });
                },
                child: new Card(
                  child: new Center(
                    child: new Text("Cash"),
                  ),
                ),
              ),
              new GestureDetector(
                onTap: () {
                  setState(() {
                    enableCard = true;
                  });
                },
                child: new Card(
                  child: new Center(
                    child: new Text("Card"),
                  ),
                ),
              ),
              new GestureDetector(
                onTap: () {
                  setState(() {
                    enableCheck = true;
                  });
                },
                child: new Card(
                  child: new Center(
                    child: new Text("Check"),
                  ),
                ),
              ),
              new GestureDetector(
                onTap: () {
                  setState(() {
                    enableVoucher = true;
                  });
                },
                child: new Card(
                  child: new Center(
                    child: new Text("Voucher"),
                  ),
                ),
              ),
              new GestureDetector(
                onTap: () {
                  setState(() {
                    enableStoreCredit = true;
                  });
                },
                child: new Card(
                  child: new Center(
                    child: new Text("Store\nCredit"),
                  ),
                ),
              ),
              new GestureDetector(
                onTap: () {
                  setState(() {
                    enablePaytm = true;
                  });
                },
                child: new Card(
                  child: new Center(
                    child: new Text("PayTM"),
                  ),
                ),
              ),
              new GestureDetector(
                onTap: () {
                  setState(() {
                    enablePayLater = true;
                  });
                },
                child: new Card(
                  child: new Center(
                    child: new Text("Pay Later"),
                  ),
                ),
              ),
              new GestureDetector(
                onTap: () {
                  setState(() {
                    enableOther = true;
                  });
                },
                child: new Card(
                  child: new Center(
                    child: new Text("Other"),
                  ),
                ),
              ),
            ],
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
                enableCash
                    ? new Container(
                        padding: EdgeInsets.all(15),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        enableCash = false;
                                      });
                                    }),
                                new Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: new Text(
                                    "Cash",
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
                                  setState(() {});
                                },
                                controller: cash,
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
                    : new Container(),
                enableCard
                    ? new Container(
                        padding: EdgeInsets.all(15),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        enableCard = false;
                                      });
                                    }),
                                new Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: new Text(
                                    "Card",
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
                                  setState(() {});
                                },
                                controller: card,
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
                    : new Container(),
                enableCheck
                    ? new Container(
                        padding: EdgeInsets.all(15),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        enableCheck = false;
                                      });
                                    }),
                                new Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: new Text(
                                    "Check",
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
                                  setState(() {});
                                },
                                controller: check,
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
                    : new Container(),
                enableVoucher
                    ? new Container(
                        padding: EdgeInsets.all(15),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        enableVoucher = false;
                                      });
                                    }),
                                new Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: new Text(
                                    "Voucher",
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
                                  setState(() {});
                                },
                                controller: voucher,
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
                    : new Container(),
                enableStoreCredit
                    ? new Container(
                        padding: EdgeInsets.all(15),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        enableStoreCredit = false;
                                      });
                                    }),
                                new Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: new Text(
                                    "Store Credit",
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
                                  setState(() {});
                                },
                                controller: storeCredit,
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
                    : new Container(),
                enablePaytm
                    ? new Container(
                        padding: EdgeInsets.all(15),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        enablePaytm = false;
                                      });
                                    }),
                                new Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: new Text(
                                    "PayTM",
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
                                  setState(() {});
                                },
                                controller: paytm,
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
                    : new Container(),
                enablePayLater && sale["customer_u_id"].length > 0
                    ? new Container(
                        padding: EdgeInsets.all(15),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        enablePayLater = false;
                                      });
                                    }),
                                new Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: new Text(
                                    "Pay Later",
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
                                  setState(() {});
                                },
                                controller: payLater,
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
                    : new Container(),
                enableOther
                    ? new Container(
                        padding: EdgeInsets.all(15),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        enableOther = false;
                                      });
                                    }),
                                new Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: new Text(
                                    "Other",
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
                                  setState(() {});
                                },
                                controller: other,
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
                    : new Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
