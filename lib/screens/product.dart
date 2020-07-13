import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shopy/screens/singleScan.dart';

import 'package:shopy/utils/api.dart';
import 'package:shopy/utils/config.dart';
import 'package:shopy/utils/models.dart';
import 'package:shopy/utils/utils.dart';

class ProductActivity extends StatefulWidget {
  final Product product;

  ProductActivity(this.product);
  @override
  State<StatefulWidget> createState() {
    return new ProductActivityState(this.product);
  }
}

class ProductActivityState extends State<ProductActivity> {
  TextEditingController name = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController sale = new TextEditingController();
  TextEditingController price = new TextEditingController();
  TextEditingController cost = new TextEditingController();
  TextEditingController code = new TextEditingController();
  TextEditingController stock = new TextEditingController();
  TextEditingController minimumStock = new TextEditingController();

  bool track = false;

  String categoryname = "";
  String categoryuid = "";

  bool loading = false;
  bool nameCheck = false;
  Product product;

  String tempsale = "", tempprice = "", tempcost = "";

  ProductActivityState(this.product);
  @override
  void initState() {
    super.initState();

    if (product != null) {
      name.text = product.name;
      categoryuid = product.categoryUID;
      categoryname = categoriesMap[categoryuid] != null
          ? categoriesMap[categoryuid].name
          : "Select Category";
      description.text = product.description;
      cost.text = product.cost == "-1" ? "" : product.cost;
      price.text = product.price == "-1" ? "" : product.price;
      sale.text = product.sale == "-1" ? "" : product.sale;
      code.text = product.code;
      stock.text = product.stock;
      track = product.track == "1";
      minimumStock.text = product.minimumStock;

      // for decimal typing
      tempsale = sale.text;
      tempprice = price.text;
      tempcost = cost.text;
    } else {
      categoryname = "Select Category";
    }
  }

  Future<String> selectCategory(BuildContext context) async {
    String returned = "";

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Select Category"),
          content: new Container(
            width: MediaQuery.of(context).size.width,
            child: new ListView(
              shrinkWrap: true,
              children: categories
                  .where((category) => category.categoryUID.length > 0)
                  .map((category) {
                return new FlatButton(
                  child: new Text(category.name),
                  onPressed: () {
                    returned = category.categoryUID;
                    setState(() {
                      categoryname = category.name;
                      categoryuid = category.categoryUID;
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
    return returned;
  }

  void productapi() {
    setState(() {
      loading = true;
    });

    checkInternet().then((internet) {
      if (internet == null || !internet) {
        oneButtonDialog(context, "No Internet connection", "", true);
        setState(() {
          loading = false;
        });
      } else {
        if (name.text.length == 0) {
          setState(() {
            oneButtonDialog(context, "Please enter product name", "", true);
            loading = false;
          });
          return;
        }
        if (sale.text.length == 0) {
          setState(() {
            oneButtonDialog(context, "Please enter sale amount", "", true);
            loading = false;
          });
          return;
        }

        Future<bool> load;
        if (product != null) {
          load = update(
            API.PRODUCT,
            Map.from({
              "store_u_id": storeUID,
              'name': name.text,
              'category_u_id': categoryuid,
              'description': description.text,
              'sale': sale.text.length > 0 ? sale.text : "-1",
              'price': price.text.length > 0 ? price.text : "-1",
              'cost': cost.text.length > 0 ? cost.text : "-1",
              'code': code.text,
              'stock': stock.text,
              'minimum_stock':
                  minimumStock.text.length > 0 ? minimumStock.text : "0",
              'track': track ? "1" : "0",
              'added': (int.parse(stock.text.length > 0 ? stock.text : "0") -
                      int.parse(product.stock))
                  .toString(),
              'modified_by': userUID,
            }),
            Map.from({'product_u_id': product.productUID}),
          );
        } else {
          load = add(
            API.PRODUCT,
            Map.from({
              "store_u_id": storeUID,
              'name': name.text,
              'category_u_id': categoryuid,
              'description': description.text,
              'sale': sale.text.length > 0 ? sale.text : "-1",
              'price': price.text.length > 0 ? price.text : "-1",
              'cost': cost.text.length > 0 ? cost.text : "-1",
              'code': code.text,
              'stock': stock.text,
              'minimum_stock':
                  minimumStock.text.length > 0 ? minimumStock.text : "0",
              'track': track ? "1" : "0",
              'created_by': userUID,
              'modified_by': userUID,
            }),
          );
        }
        load.then((onValue) {
          setState(() {
            loading = false;
          });
          if (onValue != null) {
            if (product != null) {
              products[product.productUID].name = name.text;
              products[product.productUID].categoryUID = categoryuid;
              products[product.productUID].description = description.text;
              products[product.productUID].stock =
                  stock.text.length > 0 ? stock.text : "0";
              products[product.productUID].track = track ? "1" : "0";
              products[product.productUID].cost = cost.text;
              products[product.productUID].price = price.text;
              products[product.productUID].sale = sale.text;
              products[product.productUID].code = code.text;
              products[product.productUID].minimumStock =
                  minimumStock.text.length > 0 ? minimumStock.text : "0";
              Navigator.pop(context, "");
            } else {
              Navigator.pop(context, "");
            }
          } else {
            oneButtonDialog(context, "Network error", "Please try again", true);
          }
        });
      }
    });
  }

  getBarcode(BuildContext context, Widget page) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ) as String;
    if (data != null && data.length > 0) {
      code.text = data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new ModalProgressHUD(
      inAsyncCall: loading,
      child: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white,
          title: new Text(
            product == null ? "New Product" : product.name,
            style: TextStyle(color: Colors.black),
          ),
          elevation: 4.0,
          actions: <Widget>[
            product != null
                ? new IconButton(
                    onPressed: () {
                      Future<bool> dialog = twoButtonDialog(
                          context,
                          "Delete product",
                          "Are you sure you want to delete this product? This action cannot be undone.");

                      dialog.then((onValue) {
                        if (onValue) {
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
                              Future<bool> load = update(
                                API.PRODUCT,
                                Map.from({
                                  'status': '0',
                                  'modified_by': userUID,
                                }),
                                Map.from({'product_u_id': product.productUID}),
                              );
                              load.then((value) {
                                setState(() {
                                  loading = false;
                                });
                                if (onValue != null) {
                                  // products.remove(product.productUID);
                                  Navigator.pop(context, "");
                                } else {
                                  oneButtonDialog(context, "Network error",
                                      "Please try again", true);
                                }
                              });
                            }
                          });
                        }
                      });
                    },
                    icon: new Icon(Icons.delete),
                  )
                : new Container(),
          ],
        ),
        body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: new Container(
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
                  height: 15,
                ),
                new Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                      top: BorderSide(color: Colors.black),
                    ),
                  ),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        margin: EdgeInsets.only(left: 15),
                        child: new Text(
                          "NAME",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      new Expanded(
                        child: new Container(
                          child: new TextField(
                            cursorColor: Colors.black,
                            controller: name,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: 'Sugar',
                            ),
                            onSubmitted: (String value) {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                      top: BorderSide(color: Colors.black),
                    ),
                  ),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        margin: EdgeInsets.only(left: 15),
                        child: new Text(
                          "CATEGORY",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      new Expanded(
                        child: new Container(
                          child: new FlatButton(
                            child: new Align(
                              alignment: Alignment.centerLeft,
                              child: new Text(
                                categoryname,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            onPressed: () {
                              selectCategory(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                      bottom: BorderSide(color: Colors.black),
                      top: BorderSide(color: Colors.black),
                    ),
                  ),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Expanded(
                        child: new Container(
                          margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
                          child: new TextField(
                            cursorColor: Colors.black,
                            controller: description,
                            maxLines: 5,
                            textInputAction: TextInputAction.newline,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: 'Description',
                            ),
                            onSubmitted: (String value) {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  height: 40,
                ),
                new Container(
                  child: new Text(
                    "PRICE AND INVENTORY",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                new Container(
                  height: 15,
                ),
                new Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                      top: BorderSide(color: Colors.black),
                    ),
                  ),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        margin: EdgeInsets.only(left: 15),
                        child: new Text(
                          "SALE",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      new Expanded(
                        child: new Container(
                          child: new TextField(
                            onChanged: (String text) {
                              setState(() {
                                if (text.length > 0) {
                                  if (double.parse(text) > 0) {
                                    if (tempsale.length > text.length) {
                                      sale.text = (double.parse(text) / 10)
                                          .toStringAsFixed(2);
                                    } else {
                                      if (tempsale.length > 0) {
                                        sale.text = (double.parse(text) * 10)
                                            .toStringAsFixed(2);
                                      } else {
                                        sale.text = (double.parse(text) / 100)
                                            .toStringAsFixed(2);
                                      }
                                    }
                                  } else {
                                    sale.text = "";
                                  }
                                }
                                tempsale = sale.text;
                              });
                            },
                            cursorColor: Colors.black,
                            controller: sale,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: '₹ 0.00',
                            ),
                            onSubmitted: (String value) {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                      top: BorderSide(color: Colors.black),
                    ),
                  ),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        margin: EdgeInsets.only(left: 15),
                        child: new Text(
                          "PRICE",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      new Expanded(
                        child: new Container(
                          child: new TextField(
                            onChanged: (String text) {
                              setState(() {
                                if (text.length > 0) {
                                  if (double.parse(text) > 0) {
                                    if (tempprice.length > text.length) {
                                      price.text = (double.parse(text) / 10)
                                          .toStringAsFixed(2);
                                    } else {
                                      if (tempprice.length > 0) {
                                        price.text = (double.parse(text) * 10)
                                            .toStringAsFixed(2);
                                      } else {
                                        price.text = (double.parse(text) / 100)
                                            .toStringAsFixed(2);
                                      }
                                    }
                                  } else {
                                    price.text = "";
                                  }
                                }
                                tempprice = price.text;
                              });
                            },
                            cursorColor: Colors.black,
                            controller: price,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: '₹ 0.00',
                            ),
                            onSubmitted: (String value) {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                      top: BorderSide(color: Colors.black),
                    ),
                  ),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        margin: EdgeInsets.only(left: 15),
                        child: new Text(
                          "COST",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      new Expanded(
                        child: new Container(
                          child: new TextField(
                            onChanged: (String text) {
                              setState(() {
                                if (text.length > 0) {
                                  if (double.parse(text) > 0) {
                                    if (tempcost.length > text.length) {
                                      cost.text = (double.parse(text) / 10)
                                          .toStringAsFixed(2);
                                    } else {
                                      if (tempcost.length > 0) {
                                        cost.text = (double.parse(text) * 10)
                                            .toStringAsFixed(2);
                                      } else {
                                        cost.text = (double.parse(text) / 100)
                                            .toStringAsFixed(2);
                                      }
                                    }
                                  } else {
                                    cost.text = "";
                                  }
                                }
                                tempcost = cost.text;
                              });
                            },
                            cursorColor: Colors.black,
                            controller: cost,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: '₹ 0.00',
                            ),
                            onSubmitted: (String value) {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                      new Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        margin: EdgeInsets.only(left: 15),
                        child: new Text(
                          "CODE",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      new Expanded(
                        child: new Container(
                          child: new TextField(
                            cursorColor: Colors.black,
                            controller: code,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: 'None',
                            ),
                            onSubmitted: (String value) {},
                          ),
                        ),
                      ),
                      new Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: new IconButton(
                          onPressed: () {
                            getBarcode(context, new SingleScanActivity());
                          },
                          icon: new Icon(Icons.camera_alt),
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  height: 40,
                ),
                new Container(
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Text(
                          "STOCK MANAGEMENT",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      new Container(
                        width: 80,
                        child: new CustomSwitch(
                          activeColor: Colors.black,
                          value: track,
                          offString: "OFF",
                          onString: "ON",
                          onChanged: (value) {
                            setState(() {
                              track = value;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
                new Container(
                  height: 15,
                ),
                track
                    ? new Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Colors.black),
                            right: BorderSide(color: Colors.black),
                            top: BorderSide(color: Colors.black),
                            bottom: BorderSide(
                                color:
                                    track ? Colors.transparent : Colors.black),
                          ),
                        ),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              margin: EdgeInsets.only(left: 15),
                              child: new Text(
                                "CURRENT",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            new Expanded(
                              child: new Container(
                                child: new TextField(
                                  enabled: track,
                                  cursorColor: Colors.black,
                                  controller: stock,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    hintText: '100',
                                  ),
                                  onSubmitted: (String value) {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : new Container(),
                track
                    ? new Container(
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
                            new Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              margin: EdgeInsets.only(left: 15),
                              child: new Text(
                                "MINIMUM",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            new Expanded(
                              child: new Container(
                                child: new TextField(
                                  cursorColor: Colors.black,
                                  controller: minimumStock,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    hintText: '10',
                                  ),
                                  onSubmitted: (String value) {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : new Container(),
                new Container(
                  decoration: new BoxDecoration(
                    color: Colors.black,
                  ),
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new FlatButton(
                          onPressed: () {
                            productapi();
                          },
                          child: new Text(
                            product == null ? "ADD" : "SAVE",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
