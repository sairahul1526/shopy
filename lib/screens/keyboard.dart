import 'package:flutter/material.dart';

class KeyboardActivity extends StatefulWidget {
  final bool decimal;
  final String title;
  final String hint;
  final String value;
  KeyboardActivity(this.title, this.hint, this.value, this.decimal);
  @override
  State<StatefulWidget> createState() {
    return new KeyboardActivityState(
        this.title, this.hint, this.value, this.decimal);
  }
}

class KeyboardActivityState extends State<KeyboardActivity> {
  bool decimal = true;
  String title;
  String hint;
  KeyboardActivityState(this.title, this.hint, this.value, this.decimal);

  bool started = false;
  String value = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        title: new Text(
          title,
          style: TextStyle(color: Colors.black),
        ),
        elevation: 4.0,
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Expanded(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(""),
                ],
              ),
            ),
            new Expanded(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    value,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
            new Text(
              hint,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            new Expanded(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(""),
                ],
              ),
            ),
            new Expanded(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(""),
                ],
              ),
            ),
            new Expanded(
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Container(
                      height: double.infinity,
                      child: new FlatButton(
                        onPressed: () {
                          if (decimal) {
                            if (!started) {
                              started = true;
                              value = "0.00";
                            }
                            value += "1";
                            setState(() {
                              value =
                                  (double.parse(value) * 10).toStringAsFixed(2);
                            });
                          } else {
                            if (!started) {
                              started = true;
                              value = "";
                            }
                            setState(() {
                              value += "1";
                            });
                          }
                        },
                        child: new Text(
                          "1",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                  new Expanded(
                    child: new Container(
                      height: double.infinity,
                      child: new FlatButton(
                        onPressed: () {
                          if (decimal) {
                            if (!started) {
                              started = true;
                              value = "0.00";
                            }
                            value += "2";
                            setState(() {
                              value =
                                  (double.parse(value) * 10).toStringAsFixed(2);
                            });
                          } else {
                            if (!started) {
                              started = true;
                              value = "";
                            }
                            setState(() {
                              value += "2";
                            });
                          }
                        },
                        child: new Text(
                          "2",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                  new Expanded(
                    child: new Container(
                      height: double.infinity,
                      child: new FlatButton(
                        onPressed: () {
                          if (decimal) {
                            if (!started) {
                              started = true;
                              value = "0.00";
                            }
                            value += "3";
                            setState(() {
                              value =
                                  (double.parse(value) * 10).toStringAsFixed(2);
                            });
                          } else {
                            if (!started) {
                              started = true;
                              value = "";
                            }
                            setState(() {
                              value += "3";
                            });
                          }
                        },
                        child: new Text(
                          "3",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            new Expanded(
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Container(
                      height: double.infinity,
                      child: new FlatButton(
                        onPressed: () {
                          if (decimal) {
                            if (!started) {
                              started = true;
                              value = "0.00";
                            }
                            value += "4";
                            setState(() {
                              value =
                                  (double.parse(value) * 10).toStringAsFixed(2);
                            });
                          } else {
                            if (!started) {
                              started = true;
                              value = "";
                            }
                            setState(() {
                              value += "4";
                            });
                          }
                        },
                        child: new Text(
                          "4",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                  new Expanded(
                    child: new Container(
                      height: double.infinity,
                      child: new FlatButton(
                        onPressed: () {
                          if (decimal) {
                            if (!started) {
                              started = true;
                              value = "0.00";
                            }
                            value += "5";
                            setState(() {
                              value =
                                  (double.parse(value) * 10).toStringAsFixed(2);
                            });
                          } else {
                            if (!started) {
                              started = true;
                              value = "";
                            }
                            setState(() {
                              value += "5";
                            });
                          }
                        },
                        child: new Text(
                          "5",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                  new Expanded(
                    child: new Container(
                      height: double.infinity,
                      child: new FlatButton(
                        onPressed: () {
                          if (decimal) {
                            if (!started) {
                              started = true;
                              value = "0.00";
                            }
                            value += "6";
                            setState(() {
                              value =
                                  (double.parse(value) * 10).toStringAsFixed(2);
                            });
                          } else {
                            if (!started) {
                              started = true;
                              value = "";
                            }
                            setState(() {
                              value += "6";
                            });
                          }
                        },
                        child: new Text(
                          "6",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            new Expanded(
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Container(
                      height: double.infinity,
                      child: new FlatButton(
                        onPressed: () {
                          if (decimal) {
                            if (!started) {
                              started = true;
                              value = "0.00";
                            }
                            value += "7";
                            setState(() {
                              value =
                                  (double.parse(value) * 10).toStringAsFixed(2);
                            });
                          } else {
                            if (!started) {
                              started = true;
                              value = "";
                            }
                            setState(() {
                              value += "7";
                            });
                          }
                        },
                        child: new Text(
                          "7",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                  new Expanded(
                    child: new Container(
                      height: double.infinity,
                      child: new FlatButton(
                        onPressed: () {
                          if (decimal) {
                            if (!started) {
                              started = true;
                              value = "0.00";
                            }
                            value += "8";
                            setState(() {
                              value =
                                  (double.parse(value) * 10).toStringAsFixed(2);
                            });
                          } else {
                            if (!started) {
                              started = true;
                              value = "";
                            }
                            setState(() {
                              value += "8";
                            });
                          }
                        },
                        child: new Text(
                          "8",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                  new Expanded(
                    child: new Container(
                      height: double.infinity,
                      child: new FlatButton(
                        onPressed: () {
                          if (decimal) {
                            if (!started) {
                              started = true;
                              value = "0.00";
                            }
                            value += "9";
                            setState(() {
                              value =
                                  (double.parse(value) * 10).toStringAsFixed(2);
                            });
                          } else {
                            if (!started) {
                              started = true;
                              value = "";
                            }
                            setState(() {
                              value += "9";
                            });
                          }
                        },
                        child: new Text(
                          "9",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            new Expanded(
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Container(
                      height: double.infinity,
                      child: new FlatButton(
                        onPressed: () {
                          if (decimal) {
                            if (!started) {
                              started = true;
                              value = "0.00";
                            }
                          } else {
                            if (!started) {
                              started = true;
                              value = "";
                            }
                          }
                          setState(() {
                            if (value.length > 0) {
                              value = value.substring(0, value.length - 1);
                            }
                            if (decimal) {
                              value =
                                  (double.parse(value) / 10).toStringAsFixed(2);
                            }
                          });
                        },
                        child: new Icon(
                          Icons.backspace,
                        ),
                      ),
                    ),
                  ),
                  new Expanded(
                    child: new Container(
                      height: double.infinity,
                      child: new FlatButton(
                        onPressed: () {
                          if (decimal) {
                            if (!started) {
                              started = true;
                              value = "0.00";
                            }
                            value += "0";
                            setState(() {
                              value =
                                  (double.parse(value) * 10).toStringAsFixed(2);
                            });
                          } else {
                            if (!started) {
                              started = true;
                              value = "";
                            }
                            setState(() {
                              if (value.length > 0) {
                                value += "0";
                              }
                            });
                          }
                        },
                        child: new Text(
                          "0",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                  new Expanded(
                    child: new Container(
                      height: double.infinity,
                      child: new FlatButton(
                        onPressed: () {
                          if (value.length > 0) {
                            Navigator.pop(context, value);
                          }
                        },
                        child: new Icon(
                          Icons.done,
                          color: value.length > 0 ? Colors.black : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
