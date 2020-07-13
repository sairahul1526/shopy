import 'package:flutter/material.dart';
import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shopy/screens/product.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shopy/screens/productDetails.dart';

import '../utils/utils.dart';
import '../utils/config.dart';
import '../utils/models.dart';
import '../utils/api.dart';

class ProductsActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ProductsActivityState();
  }
}

class ProductsActivityState extends State<ProductsActivity> {
  TextEditingController search = new TextEditingController();

  bool loading = false;
  bool end = false;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
  }

  void _onRefresh() async {
    getproductsapi();
  }

  void getproductsapi() {
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
        Future<Products> data = getProducts({});
        data.then((response) {
          if (response != null) {
            products.clear();
            _refreshController.refreshCompleted();
            if (response.products != null && response.products.length > 0) {
              response.products.forEach((product) {
                products[product.productUID] = product;
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
                getproductsapi();
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
                  addPage(context, new ProductActivity(null));
                },
                icon: new Icon(Icons.add),
              ),
            ],
            backgroundColor: Colors.white,
            title: new Text(
              "Products",
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
                          hintText: 'Search products',
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
                child: products.length == 0 && !loading
                    ? new Center(
                        child: new MaterialButton(
                          child: new Text(
                            "Add Product",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () {
                            addPage(context, new ProductActivity(null));
                          },
                        ),
                      )
                    : new SmartRefresher(
                        onRefresh: _onRefresh,
                        controller: _refreshController,
                        child: new ListView(
                          children: products.values
                              .where((product) => search.text.length == 0
                                  ? true
                                  : product.name
                                      .toLowerCase()
                                      .contains(search.text.toLowerCase()))
                              .map(
                            (product) {
                              return new ListTile(
                                onTap: () {
                                  if (product.track == "1") {
                                    addPage(context,
                                        new ProductDetailsActivity(product));
                                  } else {
                                    addPage(
                                        context, new ProductActivity(product));
                                  }
                                },
                                title: new Container(
                                  height: 55,
                                  child: new Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      new Text(
                                        product.track == "1"
                                            ? product.stock
                                            : "",
                                        style: TextStyle(
                                          color:
                                              int.parse(product.minimumStock) <
                                                      int.parse(product.stock)
                                                  ? Colors.grey
                                                  : Colors.red,
                                        ),
                                      ),
                                      new Text(
                                        product.track == "1" ? " X " : "",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      new Container(
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                            categoriesMap[
                                                        product.categoryUID] !=
                                                    null
                                                ? new Text(
                                                    categoriesMap[
                                                            product.categoryUID]
                                                        .name,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.grey,
                                                    ),
                                                  )
                                                : new Container(),
                                          ],
                                        ),
                                      ),
                                      new Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                      ),
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          product.sale.length > 0 &&
                                                  product.sale != "-1"
                                              ? new Text(
                                                  "₹" + product.sale,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                )
                                              : new Container(),
                                          product.price.length > 0 &&
                                                  product.price != "-1"
                                              ? new Text(
                                                  (product.sale.length > 0 &&
                                                          product.sale !=
                                                              "-1" &&
                                                          product.sale !=
                                                              product.price)
                                                      ? "₹" + product.price
                                                      : "",
                                                  style: TextStyle(
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.grey,
                                                  ),
                                                )
                                              : new Container(),
                                        ],
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
