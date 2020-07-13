import 'package:flutter/material.dart';
import 'package:shopy/screens/customerDetails.dart';
import 'package:shopy/utils/models.dart';
import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../utils/api.dart';
import '../utils/utils.dart';
import '../utils/config.dart';

class SaleActivity extends StatefulWidget {
  final Sale sale;
  final String saleUID;
  SaleActivity(this.sale, this.saleUID);
  @override
  State<StatefulWidget> createState() {
    return new SaleActivityState(this.sale, this.saleUID);
  }
}

class SaleActivityState extends State<SaleActivity> {
  bool loading = true;

  List<SaleProduct> saleProducts = new List();

  Sale sale;
  String saleUID;
  SaleActivityState(this.sale, this.saleUID);
  @override
  void initState() {
    super.initState();

    if (saleUID != null && sale == null) {
      getsalesapi();
    } else {
      getsaleproductsapi();
    }
  }

  void getsalesapi() {
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
        Future<Sales> data = getSales({"sale_u_id": saleUID});
        data.then((response) {
          if (response != null) {
            if (response.sales != null && response.sales.length > 0) {
              setState(() {
                sale = response.sales[0];
              });
            } else {
              oneButtonDialog(
                  context, "Sale Not Found", response.meta.message, false);
            }
            if (response.meta != null && response.meta.messageType == "1") {
              oneButtonDialog(context, "", response.meta.message,
                  !(response.meta.status == STATUS_403));
            }
            getsaleproductsapi();
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

  void getsaleproductsapi() {
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
        Future<SaleProducts> data =
            getSaleProducts({"sale_u_id": sale.saleUID});
        data.then((response) {
          if (response != null) {
            if (response.saleProducts != null &&
                response.saleProducts.length > 0) {
              response.saleProducts.forEach((product) {
                saleProducts.add(product);
              });
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
                getsaleproductsapi();
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
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          title: new Text(
            "Sale",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 4.0,
        ),
        body: new Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
          child: sale != null
              ? new Column(
                  children: <Widget>[
                    new Text(
                      "#" + sale.saleUID,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    new Text(
                      timeAndDateFormat
                          .format(DateTime.parse(sale.createdDateTime)),
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    new Divider(),
                    new Expanded(
                      child: new ListView(
                        children: saleProducts.map(
                          (product) {
                            return new ListTile(
                              onTap: () {},
                              title: new Container(
                                height: 55,
                                child: new Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new Text(
                                      product.quantity,
                                    ),
                                    new Text(
                                      " X ",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    new Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.01,
                                    ),
                                    new Expanded(
                                      child: new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Text(
                                            product.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          new Row(
                                            children: <Widget>[
                                              (product.price.length > 0 &&
                                                      product.price != "-1" &&
                                                      double.parse(
                                                              product.price) >
                                                          double.parse(
                                                              product.sale))
                                                  ? new Text(
                                                      "₹ " + product.price,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.grey,
                                                      ),
                                                    )
                                                  : new Container(),
                                              new Text(
                                                "₹ " + product.sale,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.grey,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    new Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.01,
                                    ),
                                    new Text(
                                      "₹ " +
                                          (double.parse(product.quantity) *
                                                  double.parse(product.sale))
                                              .toString(),
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                    new Container(
                      margin: EdgeInsets.only(right: 20),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          new Text(
                            "Subtotal: ₹ " + sale.subtotal,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    double.parse(sale.discount) > 0
                        ? new Container(
                            margin: EdgeInsets.all(10),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new FlatButton(
                                  child: new Center(
                                    child: new Text(
                                      "Discount: (" +
                                          sale.percentage +
                                          "%) ₹ " +
                                          sale.discount,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.red),
                                    ),
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          )
                        : new Container(),
                    new Container(
                      margin: EdgeInsets.only(right: 20),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          new Text(
                            "TOTAL: ₹ " + sale.total,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    sale.change.length > 0
                        ? new Container(
                            margin: EdgeInsets.only(right: 20),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                new Text(
                                  getPaymentType(sale) +
                                      ": ₹ " +
                                      getPaidAmount(sale),
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : new Container(),
                    sale.change.length > 0
                        ? new Container(
                            margin: EdgeInsets.only(right: 20),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                new Text(
                                  "CHANGE: ₹ " + sale.change,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : new Container(),
                    sale.note.length > 0
                        ? new Container(
                            margin: EdgeInsets.all(10),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new Expanded(
                                  child: new FlatButton(
                                    child: new Align(
                                      alignment: Alignment.centerRight,
                                      child: new Text(
                                        sale.note,
                                        textAlign: TextAlign.right,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      oneButtonDialog(
                                          context, "", sale.note, true);
                                    },
                                  ),
                                )
                              ],
                            ),
                          )
                        : new Container(),
                    sale.name.length > 0
                        ? new Container(
                            margin: EdgeInsets.all(10),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                sale.phone.length > 0
                                    ? new IconButton(
                                        icon: Icon(Icons.phone),
                                        color: Colors.green,
                                        onPressed: () {
                                          makePhone(sale.phone);
                                        },
                                      )
                                    : new Container(),
                                sale.phone.length > 0
                                    ? new IconButton(
                                        icon: Icon(Icons.message),
                                        color: Colors.green,
                                        onPressed: () {
                                          launchURL(
                                              "https://api.whatsapp.com/send?phone=" +
                                                  sale.phone +
                                                  "&text=");
                                        },
                                      )
                                    : new Container(),
                                new FlatButton(
                                  child: new Center(
                                    child: new Text(
                                      sale.name,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.green),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              new CustomerDetailsActivity(
                                                  customers[sale.customerUID])),
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        : new Container(),
                  ],
                )
              : new Container(),
        ),
      ),
    );
  }
}
