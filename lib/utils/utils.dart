import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopy/utils/models.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import 'package:intl/intl.dart';
import "dart:math";

import './config.dart';

DateFormat dateFormat = new DateFormat('yyyy-MM-dd');
DateFormat headingDateFormat = new DateFormat("EEE, MMM d, ''yy");
DateFormat timeAndDateFormat = new DateFormat("h:mm a, EEE, MMM d, ''yy");
DateFormat timeFormat = new DateFormat("h:mm a");

final random = new Random();

SharedPreferences prefs;
Future<bool> initSharedPreference() async {
  prefs = await SharedPreferences.getInstance();
  if (prefs != null) {
    return true;
  }
  return false;
}

void checkVibration() async {
  bool vibrate = await Vibrate.canVibrate;
  canVibrate = vibrate;
}

void launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
}

void makePhone(String phone) async {
  var url = 'tel:' + phone;
  if (await canLaunch(url)) {
    await launch(url);
  }
}

void sendMail(String mail, String subject, String body) async {
  var url = 'mailto:' +
      mail +
      "?subject=" +
      subject +
      "&body=" +
      Uri.encodeComponent(body);
  print(url);
  if (await canLaunch(url)) {
    await launch(url);
  }
}

Future<bool> checkInternet() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
  return false;
}

Widget showProgress(String title) {
  return AlertDialog(
    title: new Container(
      padding: EdgeInsets.all(10),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Text(
              title,
            ),
          ),
          new Container(
            padding: new EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: new CircularProgressIndicator(),
          )
        ],
      ),
    ),
  );
}

Future<bool> twoButtonDialog(
    BuildContext context, String title, String content) async {
  bool returned = false;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text(title),
        content: new Text(content),
        actions: <Widget>[
          new FlatButton(
            child: new Text("No"),
            onPressed: () {
              Navigator.of(context).pop();
              returned = false;
            },
          ),
          new FlatButton(
            child: new Text(
              "Yes",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              returned = true;
            },
          ),
        ],
      );
    },
  );
  return returned;
}

void oneButtonDialog(
    BuildContext context, String title, String content, bool dismiss) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text(title),
        content: content != "" ? new Text(content) : null,
        actions: <Widget>[
          new FlatButton(
            child: new Text("ok"),
            onPressed: () {
              if (dismiss) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final String onString;
  final String offString;

  const CustomSwitch(
      {Key key,
      this.value,
      this.onChanged,
      this.activeColor,
      this.onString,
      this.offString})
      : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  Animation _circleAnimation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 60));
    _circleAnimation = AlignmentTween(
            begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
            end: widget.value ? Alignment.centerLeft : Alignment.centerRight)
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController.isCompleted) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
            widget.value == false
                ? widget.onChanged(true)
                : widget.onChanged(false);
          },
          child: Container(
            width: 70.0,
            height: 35.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: _circleAnimation.value == Alignment.centerLeft
                    ? Colors.grey
                    : widget.activeColor),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 4.0, bottom: 4.0, right: 4.0, left: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _circleAnimation.value == Alignment.centerRight
                      ? Padding(
                          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                          child: Text(
                            widget.onString,
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w900,
                                fontSize: 16.0),
                          ),
                        )
                      : Container(),
                  Align(
                    alignment: _circleAnimation.value,
                    child: Container(
                      width: 25.0,
                      height: 25.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                    ),
                  ),
                  _circleAnimation.value == Alignment.centerLeft
                      ? Padding(
                          padding: const EdgeInsets.only(left: 4.0, right: 5.0),
                          child: Text(
                            widget.offString,
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w900,
                                fontSize: 16.0),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

String getPaymentType(Sale sale) {
  if (sale.cash.length > 0) {
    return "Cash";
  }
  if (sale.card.length > 0) {
    return "Card";
  }
  if (sale.check.length > 0) {
    return "Check";
  }
  if (sale.voucher.length > 0) {
    return "Voucher";
  }
  if (sale.storeCredit.length > 0) {
    return "Store Credit";
  }
  if (sale.paytm.length > 0) {
    return "Paytm";
  }
  if (sale.payLater.length > 0) {
    return "Pay Later";
  }
  return "Other";
}

String getPaidAmount(Sale sale) {
  if (sale.cash.length > 0) {
    return sale.cash;
  }
  if (sale.card.length > 0) {
    return sale.card;
  }
  if (sale.check.length > 0) {
    return sale.check;
  }
  if (sale.voucher.length > 0) {
    return sale.voucher;
  }
  if (sale.storeCredit.length > 0) {
    return sale.storeCredit;
  }
  if (sale.paytm.length > 0) {
    return sale.paytm;
  }
  if (sale.payLater.length > 0) {
    return sale.payLater;
  }
  return sale.other;
}
