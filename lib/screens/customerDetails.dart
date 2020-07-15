import 'package:flutter/material.dart';
import 'package:shopy/screens/customer.dart';
import 'package:shopy/screens/keyboard.dart';
import 'package:shopy/screens/sale.dart';
import 'package:shopy/utils/api.dart';
import 'package:shopy/utils/config.dart';
import 'package:shopy/utils/models.dart';
import 'package:shopy/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CustomerDetailsActivity extends StatefulWidget {
  final Customer customer;

  CustomerDetailsActivity(this.customer);
  @override
  State<StatefulWidget> createState() {
    return new CustomerDetailsActivityState(this.customer);
  }
}

class CustomerDetailsActivityState extends State<CustomerDetailsActivity>
    with SingleTickerProviderStateMixin {
  bool loading = false;

  String salespreviousDate = "";
  String amountsPreviousDate = "";

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<ListItem> sales = new List();
  List<ListItem> amounts = new List();

  bool salesongoing = false;
  bool amountsongoing = false;

  bool salesend = false;
  bool amountsend = false;

  Map<String, String> salesfilter = new Map();
  Map<String, String> amountsfilter = new Map();

  String salesoffset = defaultOffset;
  String amountsoffset = defaultOffset;

  ScrollController salescontroller;
  ScrollController amountscontroller;

  Customer customer;

  TabController _tabController;
  int _activeTabIndex = 0;

  CustomerDetailsActivityState(this.customer);
  @override
  void initState() {
    super.initState();

    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(_setActiveTabIndex);

    salesfilter["limit"] = defaultLimit;
    salesfilter["offset"] = salesoffset;
    salescontroller = ScrollController();
    salescontroller.addListener(salesscrollListener);

    amountsfilter["limit"] = defaultLimit;
    amountsfilter["offset"] = amountsoffset;
    amountscontroller = ScrollController();
    amountscontroller.addListener(amountsscrollListener);

    getsalesapi();
    getamountapi();
  }

  void _setActiveTabIndex() {
    setState(() {
      _activeTabIndex = _tabController.index;
    });
  }

  salesscrollListener() {
    if (salescontroller.offset >= salescontroller.position.maxScrollExtent &&
        !salescontroller.position.outOfRange) {
      if (!salesend && !salesongoing) {
        getsalesapi();
      }
    }
  }

  amountsscrollListener() {
    if (amountscontroller.offset >=
            amountscontroller.position.maxScrollExtent &&
        !amountscontroller.position.outOfRange) {
      if (!amountsend && !amountsongoing) {
        setState(() {
          loading = true;
        });
        getamountapi();
      }
    }
  }

  void _onRefresh() async {
    sales.clear();
    amounts.clear();
    salesoffset = "0";
    amountsoffset = "0";
    salesend = false;
    amountsend = false;
    getsalesapi();
    getamountapi();
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
          salesongoing = true;
        });
        salesfilter["offset"] = salesoffset;
        salesfilter["customer_u_id"] = customer.customerUID;
        Future<Sales> data = getSales(salesfilter);
        data.then((response) {
          if (response != null) {
            _refreshController.refreshCompleted();
            if (response.sales != null && response.sales.length > 0) {
              salesoffset = (int.parse(response.pagination.offset) +
                      response.sales.length)
                  .toString();
              response.sales.forEach((sale) {
                if (sale is Sale) {
                  if (salespreviousDate
                          .compareTo(sale.createdDateTime.split(" ")[0]) !=
                      0) {
                    salespreviousDate = sale.createdDateTime.split(" ")[0];
                    sales.add(HeadingItem(salespreviousDate));
                  }
                }
                sales.add(sale);
              });
            } else {
              salesend = true;
            }
            if (response.meta != null && response.meta.messageType == "1") {
              oneButtonDialog(context, "", response.meta.message,
                  !(response.meta.status == STATUS_403));
            }
            setState(() {
              loading = false;
              salesongoing = false;
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

  void getamountapi() {
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
          amountsongoing = true;
        });
        amountsfilter["offset"] = amountsoffset;
        amountsfilter["customer_u_id"] = customer.customerUID;
        Future<CustomerAmounts> data = getCustomerAmounts(amountsfilter);
        data.then((response) {
          if (response != null) {
            _refreshController.refreshCompleted();
            if (response.customerAmounts != null &&
                response.customerAmounts.length > 0) {
              amountsoffset = (int.parse(response.pagination.offset) +
                      response.customerAmounts.length)
                  .toString();
              response.customerAmounts.forEach((amount) {
                if (amount is CustomerAmount) {
                  if (amountsPreviousDate
                          .compareTo(amount.createdDateTime.split(" ")[0]) !=
                      0) {
                    amountsPreviousDate = amount.createdDateTime.split(" ")[0];
                    amounts.add(HeadingItem(amountsPreviousDate));
                  }
                }
                amounts.add(amount);
              });
            } else {
              amountsend = true;
            }
            if (response.meta != null && response.meta.messageType == "1") {
              oneButtonDialog(context, "", response.meta.message,
                  !(response.meta.status == STATUS_403));
            }
            setState(() {
              loading = false;
              amountsongoing = false;
            });
          } else {
            new Timer(Duration(milliseconds: random.nextInt(5) * 1000), () {
              setState(() {
                getamountapi();
              });
            });
          }
        });
      }
    });
  }

  editPage(BuildContext context, Widget page) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ) as String;
    if (data != null) {
      Navigator.pop(context, "");
    }
  }

  takeAmount(BuildContext context, Widget page) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ) as String;
    if (data != null && data.length > 0 && double.parse(data) > 0) {
      Future<bool> load = add(
        API.CUSTOMERAMOUNT,
        Map.from({
          'store_u_id': storeUID,
          'customer_u_id': customer.customerUID,
          'amount': data,
          'type': '2',
          'created_by': userUID,
          'modified_by': userUID,
        }),
      );
      load.then((onValue) {
        setState(() {
          loading = false;
        });
        if (onValue != null) {
          amountsoffset = "0";
          amountsend = false;
          amounts.clear();
          getamountapi();
        } else {
          oneButtonDialog(context, "Network error", "Please try again", true);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 2,
      child: new ModalProgressHUD(
        inAsyncCall: loading,
        child: new Scaffold(
          appBar: new AppBar(
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            title: new Text(
              customer.name,
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              new IconButton(
                onPressed: () {
                  editPage(context, new CustomerActivity(customer));
                },
                icon: new Icon(Icons.edit),
              ),
            ],
            elevation: 4.0,
            bottom: new PreferredSize(
              child: new Column(
                children: <Widget>[
                  new TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.black,
                    isScrollable: true,
                    tabs: [
                      new Tab(
                        child: new Text("        SALES        "),
                      ),
                      new Tab(
                        child: new Text("        CREDIT        "),
                      )
                    ],
                  ),
                  customer.phone.length > 0 || customer.email.length > 0
                      ? new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Expanded(
                              child: new FlatButton(
                                child: new AutoSizeText(
                                  customer.email,
                                  maxLines: 1,
                                  minFontSize: 10,
                                  maxFontSize: 18,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.blue,
                                  ),
                                ),
                                onPressed: () {
                                  sendMail(customer.email, "", "");
                                },
                              ),
                            ),
                            new Expanded(
                              child: new FlatButton(
                                child: new Text(
                                  customer.phone,
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,
                                  ),
                                ),
                                onPressed: () {
                                  makePhone(customer.phone);
                                },
                              ),
                            )
                          ],
                        )
                      : new Container(),
                ],
              ),
              preferredSize: Size.fromHeight(
                  customer.phone.length > 0 || customer.email.length > 0
                      ? 100
                      : 50),
            ),
          ),
          floatingActionButton: _activeTabIndex == 1
              ? new FloatingActionButton(
                  onPressed: () {
                    takeAmount(
                        context,
                        new KeyboardActivity(
                            "Take Amount", "Amount", "0.00", true));
                  },
                  backgroundColor: Colors.black,
                  child: Icon(Icons.add),
                )
              : new Container(),
          body: new TabBarView(
            controller: _tabController,
            children: [
              sales.length > 0
                  ? new SmartRefresher(
                      onRefresh: _onRefresh,
                      controller: _refreshController,
                      child: new ListView(
                        controller: salescontroller,
                        children: sales.map(
                          (sale) {
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
                        ).toList(),
                      ),
                    )
                  : new Center(
                      child: new Text(
                        "No  Sales",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
              amounts.length > 0
                  ? new SmartRefresher(
                      onRefresh: _onRefresh,
                      controller: _refreshController,
                      child: new ListView(
                        controller: amountscontroller,
                        children: amounts.map(
                          (amount) {
                            if (amount is HeadingItem) {
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
                                      .format(DateTime.parse(amount.heading)),
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey),
                                ),
                              );
                            } else if (amount is CustomerAmount) {
                              return new ListTile(
                                onTap: () {
                                  if (amount.saleUID.length > 0) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              new SaleActivity(
                                                  null, amount.saleUID)),
                                    );
                                  }
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
                                          amount.type == "1"
                                              ? "You Gave"
                                              : "You Got",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      new Expanded(
                                        child: new Container(
                                          margin: EdgeInsets.only(right: 15),
                                          child: new Text(
                                            "₹" + amount.amount,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: amount.type == "1"
                                                  ? Colors.red
                                                  : Colors.green,
                                            ),
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
                                                  amount.createdDateTime)),
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                          amount.saleUID.length > 0
                                              ? new Container(
                                                  margin:
                                                      EdgeInsets.only(left: 15),
                                                  child: new Text(
                                                    "#" + amount.saleUID,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                )
                                              : new Container(),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                            return Container();
                          },
                        ).toList(),
                      ),
                    )
                  : new Center(
                      child: new Text(
                        "No Credit",
                        style: TextStyle(
                          color: Colors.black,
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
