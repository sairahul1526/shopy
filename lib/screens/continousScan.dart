import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';
import 'package:shopy/screens/cart.dart';
import 'package:shopy/screens/keyboard.dart';
import 'package:shopy/utils/config.dart';
import 'package:shopy/utils/models.dart';
import 'package:shopy/utils/utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'dart:async';

class ContinousScanActivity extends StatefulWidget {
  ContinousScanActivity();
  @override
  State<StatefulWidget> createState() {
    return new ContinousScanActivityState();
  }
}

class ContinousScanActivityState extends State<ContinousScanActivity> {
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  String editProductUID = "";
  bool scanned = false;

  Map<String, Product> barcodes = new Map();

  @override
  void initState() {
    super.initState();

    products.forEach((productUID, product) {
      if (product.code != null && product.code.length > 0) {
        barcodes[product.code] = product;
      }
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData != null && scanData.length > 0 && !scanned) {
        scanned = true;
        if (scanned && barcodes[scanData] != null) {
          if (canVibrate) {
            Vibrate.vibrate();
          }
          new Timer(Duration(milliseconds: 1500), () {
            scanned = false;
          });
          setState(() {
            cart[barcodes[scanData].productUID] == null
                ? cart[barcodes[scanData].productUID] = 1
                : cart[barcodes[scanData].productUID] += 1;
          });
        } else {
          scanned = false;
        }
      }
    }, onError: (error) {
      print("onError");
      print(error);
    });
  }

  editQuantity(BuildContext context, Widget page) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ) as String;
    if (data != null) {
      if (cart[editProductUID] != null) {
        setState(() {
          cart[editProductUID] = int.parse(data);
        });
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        title: new Text(
          "",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          new IconButton(
            onPressed: () {
              Future<bool> dialog = twoButtonDialog(context, "Empty cart",
                  "Do you want to empty the shopping cart?");

              dialog.then((onValue) {
                if (onValue) {
                  setState(() {
                    cart.clear();
                  });
                }
              });
            },
            icon: new Icon(Icons.delete),
          ),
        ],
        elevation: 4.0,
      ),
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
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Container(
              height: 200,
              child: new QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay:
                    new QrScannerOverlayShape(overlayColor: Colors.transparent),
              ),
            ),
            new Expanded(
              child: new ListView(
                children: cart.keys.map(
                  (productUID) {
                    return new ListTile(
                      onTap: () {
                        editProductUID = productUID;
                        editQuantity(
                            context,
                            new KeyboardActivity(
                                products[productUID].name,
                                "Quantity",
                                cart[productUID].toString(),
                                false));
                      },
                      title: new Container(
                        height: 55,
                        child: new Slidable(
                          actionPane: new SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          secondaryActions: <Widget>[
                            new IconSlideAction(
                              caption: 'DELETE',
                              icon: Icons.delete,
                              color: Colors.red,
                              onTap: () {
                                setState(() {
                                  cart.remove(productUID);
                                });
                              },
                            ),
                          ],
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                cart[productUID].toString(),
                              ),
                              new Text(
                                " X ",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              new Container(
                                width: MediaQuery.of(context).size.width * 0.01,
                              ),
                              new Expanded(
                                child: new Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Text(
                                      products[productUID].name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    new Row(
                                      children: <Widget>[
                                        (products[productUID].price.length >
                                                    0 &&
                                                products[productUID].price !=
                                                    "-1" &&
                                                double.parse(
                                                        products[productUID]
                                                            .price) >
                                                    double.parse(
                                                        products[productUID]
                                                            .sale))
                                            ? new Text(
                                                "₹ " +
                                                    products[productUID].price,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.grey,
                                                ),
                                              )
                                            : new Container(),
                                        new Text(
                                          "₹ " + products[productUID].sale,
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
                                width: MediaQuery.of(context).size.width * 0.01,
                              ),
                              new Text(
                                "₹ " +
                                    (cart[productUID].toDouble() *
                                            double.parse(
                                                products[productUID].sale))
                                        .toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
