import 'package:flutter/material.dart';
import 'package:shopy/utils/api.dart';
import 'package:shopy/utils/config.dart';
import 'package:shopy/utils/models.dart';
import 'package:shopy/utils/utils.dart';
import 'dart:async';

class CustomerActivity extends StatefulWidget {
  final Customer customer;

  CustomerActivity(this.customer);
  @override
  State<StatefulWidget> createState() {
    return new CustomerActivityState(this.customer);
  }
}

class CustomerActivityState extends State<CustomerActivity> {
  TextEditingController name = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController address = new TextEditingController();

  bool loading = false;
  Customer customer;

  CustomerActivityState(this.customer);
  @override
  void initState() {
    super.initState();

    if (customer != null) {
      name.text = customer.name;
      phone.text = customer.phone;
      email.text = customer.email;
      address.text = customer.address;
    }
  }

  void customerapi() {
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
            oneButtonDialog(context, "Please enter customer name", "", true);
            loading = false;
          });
          return;
        }

        Future<bool> load;
        if (customer != null) {
          load = update(
            API.CUSTOMER,
            Map.from({
              'name': name.text,
              'phone': phone.text,
              'email': email.text,
              'address': address.text,
              'modified_by': userUID,
            }),
            Map.from({'customer_u_id': customer.customerUID}),
          );
        } else {
          load = add(
            API.CUSTOMER,
            Map.from({
              "store_u_id": storeUID,
              'name': name.text,
              'phone': phone.text,
              'email': email.text,
              'address': address.text,
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
            if (customer != null) {
              customers[customer.customerUID].name = name.text;
              customers[customer.customerUID].phone = phone.text;
              customers[customer.customerUID].email = email.text;
              customers[customer.customerUID].address = address.text;
            }
            Navigator.pop(context, "");
          } else {
            oneButtonDialog(context, "Network error", "Please try again", true);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        title: new Text(
          customer == null ? "New Customer" : customer.name,
          style: TextStyle(color: Colors.black),
        ),
        elevation: 4.0,
      ),
      body: new Container(
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
                          hintText: 'Rahul',
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
                      "PHONE",
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
                        controller: phone,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: '9112332101',
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
                      "EMAIL",
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
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: 'rahul@gmail.com',
                        ),
                        onSubmitted: (String value) {},
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
                        controller: address,
                        maxLines: 5,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: 'Address',
                        ),
                        onSubmitted: (String value) {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                        customerapi();
                      },
                      child: new Text(
                        customer == null ? "ADD" : "SAVE",
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
    );
  }
}
