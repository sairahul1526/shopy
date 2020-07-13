import 'package:flutter/material.dart';
import 'package:shopy/screens/addDiscount.dart';
import 'package:shopy/screens/addNote.dart';
import 'package:shopy/screens/keyboard.dart';
import 'package:shopy/screens/customers.dart';
import 'package:shopy/screens/paymentSingle.dart';
import 'package:shopy/utils/models.dart';
import 'dart:convert';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../utils/utils.dart';
import '../utils/config.dart';

class CartActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CartActivityState();
  }
}

class CartActivityState extends State<CartActivity> {
  bool loading = false;

  bool type = true;
  String amount = "";

  double percentage = 0;
  double discount = 0;

  String note = "";

  Customer customer;

  String editProductUID = "";

  @override
  void initState() {
    super.initState();
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

  addDiscount(BuildContext context, Widget page) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ) as List<dynamic>;
    if (data != null && data.length > 0) {
      type = data[0];
      amount = data[1];

      if (type) {
        discount = double.parse(
            (double.parse(amount) * calculatetotal() / 100).toStringAsFixed(2));
        percentage = double.parse(double.parse(amount).toStringAsFixed(2));
      } else {
        discount = double.parse(double.parse(amount).toStringAsFixed(2));
        percentage = double.parse(
            (double.parse(amount) * 100 / calculatetotal()).toStringAsFixed(2));
      }
    } else {
      type = true;
      amount = "";
      percentage = 0;
      discount = 0;
    }
  }

  addNote(BuildContext context, Widget page) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ) as String;
    if (data != null && data.length > 0) {
      note = data;
    } else {
      note = "";
    }
  }

  addCustomer(BuildContext context, Widget page) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ) as Customer;
    if (data != null) {
      customer = data;
    } else {
      customer = null;
    }
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

          if (amount.length > 0) {
            if (type) {
              discount = double.parse(
                  (double.parse(amount) * calculatetotal() / 100)
                      .toStringAsFixed(2));
              percentage =
                  double.parse(double.parse(amount).toStringAsFixed(2));
            } else {
              discount = double.parse(double.parse(amount).toStringAsFixed(2));
              percentage = double.parse(
                  (double.parse(amount) * 100 / calculatetotal())
                      .toStringAsFixed(2));
            }
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actions: <Widget>[
          new IconButton(
            onPressed: () {
              Future<bool> dialog = twoButtonDialog(context, "Empty cart",
                  "Do you want to empty the shopping cart?");

              dialog.then((onValue) {
                if (onValue) {
                  cart.clear();
                  Navigator.pop(context, "");
                }
              });
            },
            icon: new Icon(Icons.delete),
          ),
        ],
        backgroundColor: Colors.white,
        title: new Text(
          "Cart",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 4.0,
      ),
      bottomNavigationBar: new Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 30),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Container(
                decoration: new BoxDecoration(
                  color: Colors.black,
                  // borderRadius: new BorderRadius.all(Radius.circular(5)),
                ),
                child: new FlatButton(
                  onPressed: () {
                    List<Map<String, String>> sale =
                        new List<Map<String, String>>();
                    cart.forEach((productUID, quantity) {
                      sale.add({
                        "store_u_id": storeUID,
                        "product_u_id": productUID,
                        "category_u_id": products[productUID].categoryUID,
                        "name": products[productUID].name,
                        "quantity": quantity.toString(),
                        "cost": products[productUID].cost,
                        "price": products[productUID].price,
                        "sale": products[productUID].sale,
                        "code": products[productUID].code,
                        "track": products[productUID].track,
                      });
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            new PaymentSingleActivity(Map.from({
                          "subtotal": calculatetotal().toString(),
                          "discount": discount.toString(),
                          "percentage": percentage.toString(),
                          "total": (calculatetotal() - discount > 0
                              ? (calculatetotal() - discount).toStringAsFixed(2)
                              : "0"),
                          "products": json.encode(sale),
                          "note": note,
                          "customer_u_id":
                              customer != null ? customer.customerUID : "",
                          "name": customer != null ? customer.name : "",
                          "phone": customer != null ? customer.phone : "",
                        })),
                      ),
                    );
                  },
                  child: new Text(
                    cart.length == 0
                        ? "No items = ₹ 0.00"
                        : cart.length.toString() +
                            " items = ₹ " +
                            (calculatetotal() - discount).toStringAsFixed(2),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: new Container(
        padding: EdgeInsets.only(top: 10),
        child: cart.length == 0
            ? new Center(
                child: new MaterialButton(
                  child: new Text(
                    "Add Product",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, "");
                  },
                ),
              )
            : new Column(
                children: <Widget>[
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              (products[productUID]
                                                              .price
                                                              .length >
                                                          0 &&
                                                      products[productUID]
                                                              .price !=
                                                          "-1" &&
                                                      double.parse(products[
                                                                  productUID]
                                                              .price) >
                                                          double.parse(products[
                                                                  productUID]
                                                              .sale))
                                                  ? new Text(
                                                      "₹ " +
                                                          products[productUID]
                                                              .price,
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
                                                "₹ " +
                                                    products[productUID].sale,
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
                                                      products[productUID]
                                                          .sale))
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
                  new Container(
                    margin: EdgeInsets.only(right: 20),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new Text(
                          "Subtotal: ₹ " + calculatetotal().toString(),
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.all(10),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        amount.length > 0 && double.parse(amount) > 0
                            ? new Container(
                                child: new IconButton(
                                  icon: new Icon(
                                    Icons.clear,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      type = true;
                                      amount = "";
                                      percentage = 0;
                                      discount = 0;
                                    });
                                  },
                                ),
                              )
                            : new Container(),
                        new Expanded(
                          child: new FlatButton(
                            child: new Align(
                              alignment: Alignment.centerRight,
                              child: new Text(
                                amount.length > 0 && double.parse(amount) > 0
                                    ? "Discount: (" +
                                        percentage.toString() +
                                        "%) ₹ " +
                                        discount.toString()
                                    : "Add Discount",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            onPressed: () {
                              addDiscount(context,
                                  new AddDiscountActivity(type, amount));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.only(right: 20),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new Text(
                          "TOTAL: ₹ " +
                              (calculatetotal() - discount > 0
                                  ? (calculatetotal() - discount)
                                      .toStringAsFixed(2)
                                  : "FREE"),
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.all(10),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        note.length > 0
                            ? new Container(
                                child: new IconButton(
                                  icon: new Icon(
                                    Icons.clear,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      note = "";
                                    });
                                  },
                                ),
                              )
                            : new Container(),
                        new Expanded(
                          child: new FlatButton(
                            child: new Align(
                              alignment: Alignment.centerRight,
                              child: new Text(
                                note.length > 0 ? note : "Add Note",
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
                              addNote(context, new AddNoteActivity(note));
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.all(10),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        customer != null
                            ? new Container(
                                child: new IconButton(
                                  icon: new Icon(
                                    Icons.clear,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      customer = null;
                                    });
                                  },
                                ),
                              )
                            : new Container(),
                        new Expanded(
                          child: new FlatButton(
                            child: new Align(
                              alignment: Alignment.centerRight,
                              child: new Text(
                                customer != null
                                    ? customer.name
                                    : "Add Customer",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            onPressed: () {
                              addCustomer(context, new CustomersActivity(true));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
