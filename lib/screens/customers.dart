import 'package:flutter/material.dart';
import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shopy/screens/customer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shopy/screens/customerDetails.dart';

import '../utils/utils.dart';
import '../utils/config.dart';
import '../utils/models.dart';
import '../utils/api.dart';

class CustomersActivity extends StatefulWidget {
  final bool select;

  CustomersActivity(this.select);
  @override
  State<StatefulWidget> createState() {
    return new CustomersActivityState(this.select);
  }
}

class CustomersActivityState extends State<CustomersActivity> {
  TextEditingController search = new TextEditingController();

  bool loading = false;
  bool end = false;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  bool select;
  CustomersActivityState(this.select);
  @override
  void initState() {
    super.initState();
  }

  void _onRefresh() async {
    getcustomersapi();
  }

  void getcustomersapi() {
    checkInternet().then((internet) {
      if (internet == null || !internet) {
        oneButtonDialog(context, "No Internet connection", "", true);
        setState(() {
          loading = false;
        });
        _refreshController.refreshCompleted();
      } else {
        setState(() {
          loading = true;
        });
        Future<Customers> data = getCustomers({});
        data.then((response) {
          if (response != null) {
            customers.clear();
            _refreshController.refreshCompleted();
            if (response.customers != null && response.customers.length > 0) {
              response.customers.forEach((customer) {
                customers[customer.customerUID] = customer;
              });
            }
            if (response.meta != null && response.meta.messageType == "1") {
              oneButtonDialog(context, "", response.meta.message,
                  !(response.meta.status == STATUS_403));
            }
            setState(() {
              loading = false;
              search.text = "";
            });
          } else {
            new Timer(Duration(milliseconds: random.nextInt(5) * 1000), () {
              setState(() {
                getcustomersapi();
              });
            });
          }
        });
      }
    });
  }

  addPage(BuildContext context, Widget page) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ) as String;
    if (data != null) {
      for (var i = 0; i < 3; i++) {
        new Timer(Duration(seconds: 1), () {
          setState(() {});
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new ModalProgressHUD(
      inAsyncCall: loading,
      child: new DefaultTabController(
        length: 1,
        child: new Scaffold(
          appBar: new AppBar(
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            actions: <Widget>[
              new IconButton(
                onPressed: () {
                  addPage(context, new CustomerActivity(null));
                },
                icon: new Icon(Icons.add),
              ),
            ],
            backgroundColor: Colors.white,
            title: new Text(
              "Customers",
              style: TextStyle(color: Colors.black),
            ),
            elevation: 4.0,
            bottom: new TabBar(
              indicatorColor: Colors.transparent,
              tabs: <Widget>[
                new Row(
                  children: <Widget>[
                    new IconButton(
                      onPressed: () {},
                      icon: new Icon(Icons.search),
                    ),
                    new Expanded(
                      child: new TextField(
                        cursorColor: Colors.black,
                        controller: search,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: 'Search by name, phone or email',
                        ),
                        onChanged: (String value) {
                          setState(() {});
                        },
                      ),
                    ),
                    search.text.length > 1
                        ? new FlatButton(
                            child: new Text(
                              "Clear",
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              setState(() {
                                search.text = "";
                              });
                            },
                          )
                        : new Container()
                  ],
                ),
              ],
            ),
          ),
          body: new TabBarView(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(top: 10),
                child: customers.length == 0 && !loading
                    ? new Center(
                        child: new MaterialButton(
                          child: new Text(
                            "Add Customer",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () {
                            addPage(context, new CustomerActivity(null));
                          },
                        ),
                      )
                    : new SmartRefresher(
                        onRefresh: _onRefresh,
                        controller: _refreshController,
                        child: new ListView(
                          children: customers.values
                              .where((customer) => search.text.length == 0
                                  ? true
                                  : (customer.name.toLowerCase().contains(
                                          search.text.toLowerCase()) ||
                                      customer.phone.toLowerCase().contains(
                                          search.text.toLowerCase()) ||
                                      customer.email
                                          .toLowerCase()
                                          .contains(search.text.toLowerCase())))
                              .map(
                            (customer) {
                              return new ListTile(
                                onTap: () {
                                  if (!select) {
                                    addPage(context,
                                        new CustomerDetailsActivity(customer));
                                  } else {
                                    Navigator.pop(context, customer);
                                  }
                                },
                                title: new Container(
                                  height: 55,
                                  child: new Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      new Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                      ),
                                      new Expanded(
                                        child: new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Text(
                                              customer.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            new Text(
                                              customer.phone +
                                                  " " +
                                                  customer.email,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      new Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                      ),
                                      double.parse(customer.amount) != 0
                                          ? new Container(
                                              child: new Text(
                                                "₹ " + customer.amount,
                                                style: TextStyle(
                                                  color: double.parse(
                                                              customer.amount) <
                                                          0
                                                      ? Colors.red
                                                      : Colors.green,
                                                ),
                                              ),
                                            )
                                          : new Container(),
                                      new Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                      ),
                                      new Icon(
                                        Icons.arrow_forward_ios,
                                        size: 13,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
