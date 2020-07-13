import 'package:flutter/material.dart';
import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shopy/screens/sale.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../utils/utils.dart';
import '../utils/config.dart';
import '../utils/models.dart';
import '../utils/api.dart';

class SalesActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SalesActivityState();
  }
}

class SalesActivityState extends State<SalesActivity> {
  TextEditingController search = new TextEditingController();

  bool loading = false;
  bool end = false;
  bool ongoing = false;

  String previousDate = "";

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<ListItem> sales = new List();

  Map<String, String> filter = new Map();

  String offset = defaultOffset;

  ScrollController _controller;

  @override
  void initState() {
    super.initState();

    filter["limit"] = defaultLimit;
    filter["offset"] = offset;

    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    getsalesapi();
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      if (!end && !ongoing) {
        setState(() {
          loading = true;
        });
        getsalesapi();
      }
    }
  }

  void _onRefresh() async {
    sales.clear();
    offset = "0";
    end = false;
    getsalesapi();
  }

  void getsalesapi() {
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
          ongoing = true;
        });
        filter["offset"] = offset;
        Future<Sales> data = getSales(filter);
        data.then((response) {
          if (response != null) {
            _refreshController.refreshCompleted();
            if (response.sales != null && response.sales.length > 0) {
              offset = (int.parse(response.pagination.offset) +
                      response.sales.length)
                  .toString();
              response.sales.forEach((sale) {
                if (sale is Sale) {
                  if (previousDate
                          .compareTo(sale.createdDateTime.split(" ")[0]) !=
                      0) {
                    previousDate = sale.createdDateTime.split(" ")[0];
                    sales.add(HeadingItem(previousDate));
                  }
                }
                sales.add(sale);
              });
            } else {
              end = true;
            }
            if (response.meta != null && response.meta.messageType == "1") {
              oneButtonDialog(context, "", response.meta.message,
                  !(response.meta.status == STATUS_403));
            }
            setState(() {
              loading = false;
              ongoing = false;
              search.text = "";
            });
          } else {
            new Timer(Duration(milliseconds: random.nextInt(5) * 1000), () {
              setState(() {
                getsalesapi();
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
      getsalesapi();
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
            backgroundColor: Colors.white,
            title: new Text(
              "Sales",
              style: TextStyle(color: Colors.black),
            ),
            elevation: 4.0,
            // bottom: new TabBar(
            //   indicatorColor: Colors.transparent,
            //   tabs: <Widget>[
            //     new Row(
            //       children: <Widget>[
            //         new IconButton(
            //           onPressed: () {},
            //           icon: new Icon(Icons.search),
            //         ),
            //         new Expanded(
            //           child: new TextField(
            //             cursorColor: Colors.black,
            //             controller: search,
            //             textInputAction: TextInputAction.done,
            //             decoration: InputDecoration(
            //               isDense: true,
            //               border: InputBorder.none,
            //               hintText: 'Search sales',
            //             ),
            //             onChanged: (String value) {
            //               setState(() {});
            //             },
            //           ),
            //         ),
            //         search.text.length > 1
            //             ? new FlatButton(
            //                 child: new Text(
            //                   "Clear",
            //                   style: TextStyle(color: Colors.black),
            //                 ),
            //                 onPressed: () {
            //                   setState(() {
            //                     search.text = "";
            //                   });
            //                 },
            //               )
            //             : new Container()
            //       ],
            //     ),
            //   ],
            // ),
          ),
          body: new TabBarView(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(top: 10),
                child: sales.length == 0 && !loading
                    ? new Center(
                        child: new MaterialButton(
                          child: new Text(
                            "Add Sale",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      )
                    : new SmartRefresher(
                        onRefresh: _onRefresh,
                        controller: _refreshController,
                        child: new ListView.builder(
                          controller: _controller,
                          itemCount: sales.length,
                          itemBuilder: (context, i) {
                            final sale = sales[i];
                            if (sale is HeadingItem) {
                              return new Container(
                                decoration: new BoxDecoration(
                                    border: new Border(
                                  top: BorderSide(
                                    color: HexColor("#dedfe0"),
                                  ),
                                )),
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(top: 10),
                                child: new Text(
                                  headingDateFormat
                                      .format(DateTime.parse(sale.heading)),
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey),
                                ),
                              );
                            } else if (sale is Sale) {
                              return new ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            new SaleActivity(sale, null)),
                                  );
                                },
                                title: new Container(
                                  height: 55,
                                  child: new Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      new Container(
                                        margin: EdgeInsets.only(right: 15),
                                        child: new Text(
                                          "Paid via\n" + getPaymentType(sale),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      new Container(
                                        margin: EdgeInsets.only(right: 15),
                                        child: new Text(
                                          "₹" + sale.total,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 25,
                                          ),
                                        ),
                                      ),
                                      new Expanded(
                                        child: new SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: new Row(
                                            children: <Widget>[
                                              (sale.discount != null &&
                                                      sale.discount.length >
                                                          0 &&
                                                      double.parse(
                                                              sale.discount) >
                                                          0)
                                                  ? new Container(
                                                      margin: EdgeInsets.only(
                                                          right: 3),
                                                      child: new Icon(
                                                        Icons.local_offer,
                                                        color: Colors.red,
                                                        size: 18,
                                                      ),
                                                    )
                                                  : new Container(),
                                              (sale.discount != null &&
                                                      sale.discount.length >
                                                          0 &&
                                                      double.parse(
                                                              sale.discount) >
                                                          0)
                                                  ? new Container(
                                                      margin: EdgeInsets.only(
                                                          right: 10),
                                                      child: new Text(
                                                        "₹ " + sale.discount,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    )
                                                  : new Container(),
                                              (sale.note != null &&
                                                      sale.note.length > 0)
                                                  ? new Container(
                                                      margin: EdgeInsets.only(
                                                          right: 10),
                                                      child: new Icon(
                                                        Icons.description,
                                                        color: Colors.blue,
                                                        size: 18,
                                                      ),
                                                    )
                                                  : new Container(),
                                              (sale.name != null &&
                                                      sale.name.length > 0)
                                                  ? new Container(
                                                      margin: EdgeInsets.only(
                                                          right: 3),
                                                      child: new Icon(
                                                        Icons.person_outline,
                                                        color: Colors.green,
                                                        size: 18,
                                                      ),
                                                    )
                                                  : new Container(),
                                              (sale.name != null &&
                                                      sale.name.length > 0)
                                                  ? new Container(
                                                      child: new Text(
                                                        sale.name,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                    )
                                                  : new Container(),
                                            ],
                                          ),
                                        ),
                                      ),
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          new Container(
                                            margin: EdgeInsets.only(left: 15),
                                            child: new Text(
                                              timeFormat.format(DateTime.parse(
                                                  sale.createdDateTime)),
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                          new Container(
                                            margin: EdgeInsets.only(left: 15),
                                            child: new Text(
                                              "#" + sale.saleUID,
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                            return Container();
                          },
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
