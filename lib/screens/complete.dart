import 'package:flutter/material.dart';

import './dashboard.dart';

class CompleteActivity extends StatefulWidget {
  final Map<String, String> sale;
  CompleteActivity(this.sale);
  @override
  State<StatefulWidget> createState() {
    return new CompleteActivityState(this.sale);
  }
}

class CompleteActivityState extends State<CompleteActivity> {
  Map<String, String> sale;
  CompleteActivityState(this.sale);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: new Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: new ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            // new Row(
            //   children: <Widget>[
            //     new Expanded(
            //       child: new Container(
            //         child: new MaterialButton(
            //           height: 40,
            //           child: new Text(
            //             "Email",
            //             textAlign: TextAlign.center,
            //           ),
            //           onPressed: () {
            //             Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                     builder: (context) =>
            //                         new DashBoardActivity(false)));
            //           },
            //         ),
            //       ),
            //     ),
            //     new Expanded(
            //       child: new Container(
            //         child: new MaterialButton(
            //           height: 40,
            //           child: new Text(
            //             "Text",
            //             textAlign: TextAlign.center,
            //           ),
            //           onPressed: () {
            //             Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                     builder: (context) =>
            //                         new DashBoardActivity(false)));
            //           },
            //         ),
            //       ),
            //     ),
            //     new Expanded(
            //       child: new Container(
            //         child: new MaterialButton(
            //           height: 40,
            //           child: new Text(
            //             "Print",
            //             textAlign: TextAlign.center,
            //           ),
            //           onPressed: () {
            //             Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                     builder: (context) =>
            //                         new DashBoardActivity(false)));
            //           },
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    new DashBoardActivity(false)));
                      },
                      child: new Text(
                        "New Sale",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: new Container(
        height: MediaQuery.of(context).size.height,
        margin: new EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.1,
            100, MediaQuery.of(context).size.width * 0.1, 0),
        child: new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Center(
                child: new SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.width * 0.4,
                  child: new Icon(
                    Icons.done,
                    size: MediaQuery.of(context).size.width * 0.25,
                  ),
                ),
              ),
              (sale["change"] != null &&
                      sale["change"].length > 0 &&
                      double.parse(sale["change"]) > 0)
                  ? new Container(
                      margin: EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: new Text(
                        "Change Due\n₹ " + sale["change"],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    )
                  : new Container(),
              new Text(
                "Total : ₹ " + sale["total"],
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
