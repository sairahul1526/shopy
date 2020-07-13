import 'package:flutter/material.dart';
import 'package:shopy/screens/product.dart';
import 'package:shopy/screens/sale.dart';
import 'package:shopy/utils/api.dart';
import 'package:shopy/utils/config.dart';
import 'package:shopy/utils/models.dart';
import 'package:shopy/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ProductDetailsActivity extends StatefulWidget {
  final Product product;

  ProductDetailsActivity(this.product);
  @override
  State<StatefulWidget> createState() {
    return new ProductDetailsActivityState(this.product);
  }
}

class ProductDetailsActivityState extends State<ProductDetailsActivity> {
  bool loading = false;
  bool end = false;
  bool ongoing = false;

  String previousDate = "";

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<ListItem> stocks = new List();

  Map<String, String> filter = new Map();

  String offset = defaultOffset;

  ScrollController _controller;

  Product product;

  ProductDetailsActivityState(this.product);
  @override
  void initState() {
    super.initState();

    filter["product_u_id"] = product.productUID;
    filter["limit"] = defaultLimit;
    filter["offset"] = offset;

    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    getproductstocksapi();
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      if (!end && !ongoing) {
        setState(() {
          loading = true;
        });
        getproductstocksapi();
      }
    }
  }

  void _onRefresh() async {
    stocks.clear();
    offset = "0";
    end = false;
    getproductstocksapi();
  }

  void getproductstocksapi() {
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
        Future<ProductStocks> data = getProductStocks(filter);
        data.then((response) {
          if (response != null) {
            _refreshController.refreshCompleted();
            if (response.productStocks != null &&
                response.productStocks.length > 0) {
              offset = (int.parse(response.pagination.offset) +
                      response.productStocks.length)
                  .toString();
              response.productStocks.forEach((stock) {
                if (stock is ProductStock) {
                  if (previousDate
                          .compareTo(stock.createdDateTime.split(" ")[0]) !=
                      0) {
                    previousDate = stock.createdDateTime.split(" ")[0];
                    stocks.add(HeadingItem(previousDate));
                  }
                }
                stocks.add(stock);
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
            });
          } else {
            new Timer(Duration(milliseconds: random.nextInt(5) * 1000), () {
              setState(() {
                getproductstocksapi();
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
            "Stock Movement",
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            new IconButton(
              onPressed: () {
                editPage(context, new ProductActivity(product));
              },
              icon: new Icon(Icons.edit),
            ),
          ],
          elevation: 4.0,
        ),
        body: stocks.length > 0
            ? new SmartRefresher(
                onRefresh: _onRefresh,
                controller: _refreshController,
                child: new ListView(
                  controller: _controller,
                  children: stocks.map(
                    (stock) {
                      if (stock is HeadingItem) {
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
                                .format(DateTime.parse(stock.heading)),
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        );
                      } else if (stock is ProductStock) {
                        return new ListTile(
                          onTap: () {
                            if (stock.saleUID.length > 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        new SaleActivity(null, stock.saleUID)),
                              );
                            }
                          },
                          title: new Container(
                            height: 55,
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                  margin: EdgeInsets.only(right: 15),
                                  child: new Icon(
                                    (stock.type == "2" || stock.type == "3")
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,
                                    size: 25,
                                    color:
                                        (stock.type == "2" || stock.type == "3")
                                            ? Colors.red
                                            : Colors.green,
                                  ),
                                ),
                                new Expanded(
                                  child: new Container(
                                    margin: EdgeInsets.only(right: 15),
                                    child: new Text(
                                      stock.quantity +
                                          " x " +
                                          (stock.type == "2"
                                              ? "Sale "
                                              : (stock.type == "1"
                                                  ? "Added "
                                                  : "Removed")),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: (stock.type == "2" ||
                                                stock.type == "3")
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                  ),
                                ),
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    new Container(
                                      margin: EdgeInsets.only(left: 15),
                                      child: new Text(
                                        timeFormat.format(DateTime.parse(
                                            stock.createdDateTime)),
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    stock.saleUID.length > 0
                                        ? new Container(
                                            margin: EdgeInsets.only(left: 15),
                                            child: new Text(
                                              "#" + stock.saleUID,
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
                  "No  Sales",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
      ),
    );
  }
}
