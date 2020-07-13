import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopy/screens/analytics.dart';
import 'package:shopy/screens/business.dart';
import 'package:shopy/screens/cart.dart';
import 'package:shopy/screens/categories.dart';
import 'package:shopy/screens/continousScan.dart';
import 'package:shopy/screens/customers.dart';
import 'package:shopy/screens/login.dart';
import 'package:shopy/screens/products.dart';
import 'package:shopy/screens/sales.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';

import '../utils/utils.dart';
import '../utils/config.dart';
import '../utils/models.dart';
import '../utils/api.dart';

class DashBoardActivity extends StatefulWidget {
  final bool reload;
  DashBoardActivity(this.reload);
  @override
  State<StatefulWidget> createState() {
    return new DashBoardActivityState(this.reload);
  }
}

class DashBoardActivityState extends State<DashBoardActivity> {
  TextEditingController search = new TextEditingController();

  bool loading = true;
  bool end = false;

  bool reload = false;

  int quantity = 1;

  IOWebSocketChannel channel;

  RealTime response;

  String grid = "1";

  DashBoardActivityState(this.reload);
  @override
  void initState() {
    super.initState();

    if (prefs.getString("grid") != null && prefs.getString("grid") == "0") {
      grid = "0";
    } else {
      grid = "1";
    }

    if (reload) {
      getproductsapi();
    } else {
      setState(() {
        loading = false;
      });
    }

    // getrealtimeapi();
  }

  void getrealtimeapi() {
    channel = IOWebSocketChannel.connect(
        "ws://" + API.URL + "/realtime?store_u_id=" + storeUID);
    channel.stream.listen(
      (message) {
        if (message != null && message != "1") {
          response = RealTime.fromJson(json.decode(message));
          if (response.product != null) {
            setState(() {
              if (response.product.status == "1") {
                products[response.product.productUID] = response.product;
              } else {
                products.remove(response.product.productUID);
              }
            });
          }
          if (response.customer != null) {
            setState(() {
              customers[response.customer.customerUID] = response.customer;
            });
          }
        }
      },
      onDone: () {
        new Timer(Duration(seconds: random.nextInt(3)), () {
          getrealtimeapi();
        });
      },
      onError: (error) {
        new Timer(Duration(seconds: random.nextInt(3)), () {
          getrealtimeapi();
        });
      },
    );
  }

  void getproductsapi() {
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
        Future<Products> data = getProducts({});
        data.then((response) {
          if (response != null) {
            if (response.products != null && response.products.length > 0) {
              response.products.forEach((product) {
                products[product.productUID] = product;
              });
            }
            if (response.meta != null && response.meta.messageType == "1") {
              oneButtonDialog(context, "", response.meta.message,
                  !(response.meta.status == STATUS_403));
            }
            getcategoriesapi();
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

  void getcategoriesapi() {
    checkInternet().then((internet) {
      if (internet == null || !internet) {
        oneButtonDialog(context, "No Internet connection", "", true);
      } else {
        Future<Categories> data = getCategories({});
        data.then((response) {
          if (response != null) {
            categories.add(
              new Category(
                  id: "",
                  categoryUID: "",
                  name: "All",
                  storeUID: storeUID,
                  status: "",
                  createdBy: "",
                  createdDateTime: "",
                  modifiedBy: "",
                  modifiedDateTime: ""),
            );
            if (response.categories != null && response.categories.length > 0) {
              response.categories.forEach((cat) {
                categoriesMap[cat.categoryUID] = cat;
              });
              categories.addAll(response.categories);
            }
            if (response.meta != null && response.meta.messageType == "1") {
              oneButtonDialog(context, "", response.meta.message,
                  !(response.meta.status == STATUS_403));
            }
            getcustomersapi();
          } else {
            new Timer(Duration(milliseconds: random.nextInt(5) * 1000), () {
              setState(() {
                getcategoriesapi();
              });
            });
          }
        });
      }
    });
  }

  void getcustomersapi() {
    checkInternet().then((internet) {
      if (internet == null || !internet) {
        oneButtonDialog(context, "No Internet connection", "", true);
      } else {
        Future<Customers> data = getCustomers({});
        data.then((response) {
          if (response != null) {
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

  void logout() {
    prefs.clear();
    categories.clear();
    categoriesMap.clear();
    products.clear();
    customers.clear();
    cart.clear();
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (BuildContext context) => new Login()));
  }

  Widget navigationbar(BuildContext context) {
    return new Drawer(
      child: new ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          new Container(
            height: 50,
          ),
          new ListTile(
            title: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Container(
                      child: new Flexible(
                        child: new Text(
                          storeName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    new Icon(
                      Icons.arrow_forward_ios,
                    ),
                  ],
                ),
                new Text(
                  username[0].toUpperCase() + username.substring(1),
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          new Divider(),
          new ListTile(
            title: new Row(
              children: <Widget>[
                new Flexible(
                  child: new Text(
                    'Checkout',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          new ListTile(
            title: new Row(
              children: <Widget>[
                new Flexible(
                  child: new Text(
                    'Products',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => new ProductsActivity()),
              );
            },
          ),
          new ListTile(
            title: new Row(
              children: <Widget>[
                new Flexible(
                  child: new Text(
                    'Categories',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new CategoriesActivity()),
              );
            },
          ),
          new ListTile(
            title: new Row(
              children: <Widget>[
                new Flexible(
                  child: new Text(
                    'Customers',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new CustomersActivity(false)),
              );
            },
          ),
          new ListTile(
            title: new Row(
              children: <Widget>[
                new Flexible(
                  child: new Text(
                    'Sales',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => new SalesActivity()),
              );
            },
          ),
          new ListTile(
            title: new Row(
              children: <Widget>[
                new Flexible(
                  child: new Text(
                    'Analytics',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new AnalyticsActivity()),
              );
            },
          ),
          // new ListTile(
          //   title: new Row(
          //     children: <Widget>[
          //       new Flexible(
          //         child: new Text(
          //           'Help',
          //           style: TextStyle(
          //             fontWeight: FontWeight.bold,
          //             fontSize: 18,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          // ),
          new Divider(),
          new ListTile(
            enabled: false,
            title: new Row(
              children: <Widget>[
                new Flexible(
                  child: new Text(
                    "SETTINGS",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {},
          ),
          new ListTile(
            title: new Row(
              children: <Widget>[
                new Flexible(
                  child: new Text(
                    "Business Information",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => new BusinessActivity()),
              );
            },
          ),
          // new ListTile(
          //   title: new Row(
          //     children: <Widget>[
          //       new Flexible(
          //         child: new Text(
          //           "Sales Tax",
          //           style: TextStyle(
          //             fontWeight: FontWeight.bold,
          //             fontSize: 18,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          // ),
          // new ListTile(
          //   title: new Row(
          //     children: <Widget>[
          //       new Flexible(
          //         child: new Text(
          //           "Printer",
          //           style: TextStyle(
          //             fontWeight: FontWeight.bold,
          //             fontSize: 18,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          // ),
          new ListTile(
            title: new Row(
              children: <Widget>[
                new Flexible(
                  child: new Text(
                    "Logout",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              logout();
            },
          ),
        ],
      ),
    );
  }

  double calculatetotal() {
    double total = 0;
    cart.forEach(
      (productUID, no) {
        if (products[productUID] != null) {
          total += double.parse(products[productUID].sale) * no.toDouble();
        } else {
          cart.remove(productUID);
        }
      },
    );
    return double.parse(total.toStringAsFixed(2));
  }

  sellQuantity(BuildContext context, Widget page) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ) as String;
    if (data != null) {
      quantity = int.parse(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new ModalProgressHUD(
      inAsyncCall: loading,
      child: new DefaultTabController(
        length: categories.length,
        child: new Scaffold(
          appBar: new AppBar(
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            title: new Text(
              "Checkout",
              style: TextStyle(color: Colors.black),
            ),
            elevation: 4.0,
            bottom: new PreferredSize(
              child: new Column(
                children: <Widget>[
                  search.text.length == 0
                      ? new TabBar(
                          indicatorColor: Colors.black,
                          isScrollable: true,
                          tabs: categories.map((cat) {
                            return new Tab(
                              text: "    " + cat.name + "    ",
                            );
                          }).toList(),
                        )
                      : new Container(),
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
                          onChanged: (value) {
                            setState(() {
                              products = products;
                            });
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
                          : new Container(),
                      new IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    new ContinousScanActivity()),
                          );
                        },
                        icon: new Icon(Icons.camera_alt),
                      ),
                      new IconButton(
                        onPressed: () {
                          setState(() {
                            if (grid == "1") {
                              grid = "0";
                              prefs.setString("grid", "0");
                            } else {
                              grid = "1";
                              prefs.setString("grid", "1");
                            }
                          });
                        },
                        icon: new Icon(
                            grid == "0" ? Icons.view_module : Icons.view_list),
                      ),
                    ],
                  ),
                ],
              ),
              preferredSize: Size.fromHeight(100.0),
            ),
          ),
          drawer: navigationbar(context),
          bottomNavigationBar: new Container(
            decoration: new BoxDecoration(
              color: Colors.black,
            ),
            margin: EdgeInsets.fromLTRB(10, 0, 10, 30),
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new FlatButton(
                    onPressed: () {
                      if (cart.length > 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => new CartActivity(),
                          ),
                        );
                      } else {
                        oneButtonDialog(context, "Cart is empty",
                            "Add some items to cart.", true);
                      }
                    },
                    child: new Text(
                      cart.length == 0
                          ? "No items = ₹ 0.00"
                          : cart.length.toString() +
                              " items = ₹ " +
                              calculatetotal().toString(),
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
          body: new TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: categories.map(
              (cat) {
                return new Container(
                  padding: EdgeInsets.all(3),
                  child: grid == "0"
                      ? new ListView(
                          children: products.values
                              .where((product) => search.text.length == 0
                                  ? (cat.categoryUID.length > 0
                                      ? product.categoryUID == cat.categoryUID
                                      : true)
                                  : product.name
                                      .toLowerCase()
                                      .contains(search.text.toLowerCase()))
                              .map(
                            (product) {
                              return new ListTile(
                                onTap: () {
                                  setState(() {
                                    cart[product.productUID] == null
                                        ? cart[product.productUID] = quantity
                                        : cart[product.productUID] += quantity;
                                    quantity = 1;
                                  });
                                },
                                title: new Container(
                                  child: new Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      cart[product.productUID] != null
                                          ? new Text(
                                              cart[product.productUID]
                                                  .toString(),
                                            )
                                          : new Container(),
                                      cart[product.productUID] != null
                                          ? new Text(
                                              " X ",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            )
                                          : new Container(),
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
                                            new AutoSizeText(
                                              product.name,
                                              maxLines: 2,
                                              minFontSize: 16,
                                              maxFontSize: 18,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            product.track == "1"
                                                ? new Text(
                                                    product.stock + " In Stock",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: int.parse(product
                                                                    .minimumStock) <
                                                                int.parse(
                                                                    product
                                                                        .stock)
                                                            ? Colors.grey
                                                            : Colors.red),
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
                        )
                      : new GridView.count(
                          padding: const EdgeInsets.all(10),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 3,
                          children: products.values
                              .where((product) => search.text.length == 0
                                  ? (cat.categoryUID.length > 0
                                      ? product.categoryUID == cat.categoryUID
                                      : true)
                                  : product.name
                                      .toLowerCase()
                                      .contains(search.text.toLowerCase()))
                              .map(
                            (product) {
                              return new GestureDetector(
                                onTap: () {
                                  setState(() {
                                    cart[product.productUID] == null
                                        ? cart[product.productUID] = quantity
                                        : cart[product.productUID] += quantity;
                                    quantity = 1;
                                  });
                                },
                                child: new Container(
                                  padding: EdgeInsets.all(5),
                                  color: HexColor("#e1e1e1"),
                                  child: new Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      new AutoSizeText(
                                        product.name,
                                        maxLines: 3,
                                        minFontSize: 16,
                                        maxFontSize: 18,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      new Expanded(
                                        child: new Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            product.sale.length > 0 &&
                                                    product.sale != "-1"
                                                ? new Container(
                                                    margin: EdgeInsets.only(
                                                      right: 10,
                                                    ),
                                                    child: new Text(
                                                      "₹" + product.sale,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                      ),
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
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.grey,
                                                    ),
                                                  )
                                                : new Container(),
                                          ],
                                        ),
                                      ),
                                      product.track == "1"
                                          ? new Text(
                                              product.stock + " In Stock",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w300,
                                                  color: int.parse(product
                                                              .minimumStock) <
                                                          int.parse(
                                                              product.stock)
                                                      ? Colors.grey
                                                      : Colors.red),
                                            )
                                          : new Container(),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}
