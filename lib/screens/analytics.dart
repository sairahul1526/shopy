import 'package:flutter/material.dart';
import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:charts_flutter/flutter.dart' as charty;
import 'package:intl/intl.dart';

import '../utils/api.dart';
import '../utils/utils.dart';
import '../utils/config.dart';
import '../utils/models.dart';

class AnalyticsActivity extends StatefulWidget {
  AnalyticsActivity();
  @override
  State<StatefulWidget> createState() {
    return new AnalyticsActivityState();
  }
}

class AnalyticsActivityState extends State<AnalyticsActivity> {
  Analytics charts = new Analytics();

  List<Widget> timeline = new List();

  bool loading = true;

  DateTime fromDate = new DateTime.now().add(new Duration(days: -6 * 30));
  DateTime toDate = DateTime.now();

  List<DateTime> billDates = new List();

  String billDatesRange = "Pick date range";

  @override
  void initState() {
    super.initState();

    getanalyticsdata();
  }

  void getanalyticsdata() {
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
        Map<String, String> filter = new Map();
        filter["from"] = dateFormat.format(fromDate);
        filter["to"] = dateFormat.format(toDate);
        Future<Analytics> data = getAnalytics(filter);
        data.then((response) {
          if (response != null) {
            if (response.meta != null && response.meta.messageType == "1") {
              oneButtonDialog(context, "", response.meta.message,
                  !(response.meta.status == STATUS_403));
            }
            setState(() {
              charts = response;
            });
            updateCharts();
          } else {
            setState(() {
              loading = false;
            });
          }
        });
      }
    });
  }

  void updateCharts() {
    timeline.clear();
    if (charts.graphs != null) {
      charts.graphs.forEach(
        (graph) {
          timeline.add(
            new Container(
              margin: EdgeInsets.only(top: 50),
              child: new Text(
                graph.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );

          timeline.add(
            new Container(
              child: new Container(
                height: 20,
              ),
            ),
          );

          if (graph.type == "3") {
            List<charty.Series<TimeSeriesSales, DateTime>> seriesList = [];
            graph.data.forEach(
              (d2) {
                List<TimeSeriesSales> data = [];

                print(d2.data.length);
                d2.data.forEach(
                  (f) {
                    print(f.value);
                    if (f.value != "") {
                      data.add(new TimeSeriesSales(DateTime.parse(f.title),
                          double.parse(f.value).ceil(), f.color));
                    }
                  },
                );

                if (data.length == 0) {
                  data.add(new TimeSeriesSales(DateTime.now(), 0, ""));
                }

                seriesList.add(
                  new charty.Series<TimeSeriesSales, DateTime>(
                    id: 'Sales',
                    domainFn: (TimeSeriesSales sales, _) => sales.time,
                    measureFn: (TimeSeriesSales sales, _) => sales.sales,
                    colorFn: (TimeSeriesSales sales, __) =>
                        charty.ColorUtil.fromDartColor(HexColor(sales.color)),
                    data: data,
                  ),
                );
              },
            );

            if (seriesList.length > 0) {
              timeline.add(
                new Container(
                  height: 300,
                  child: new charty.TimeSeriesChart(
                    seriesList,
                    animate: true,
                    behaviors: [
                      new charty.LinePointHighlighter(
                          showHorizontalFollowLine:
                              charty.LinePointHighlighterFollowLineType.none,
                          showVerticalFollowLine: charty
                              .LinePointHighlighterFollowLineType.nearest),
                      new charty.SelectNearest(
                          eventTrigger: charty.SelectionTrigger.tapAndDrag)
                    ],
                    primaryMeasureAxis: new charty.NumericAxisSpec(
                      // dash lines
                      renderSpec: charty.GridlineRendererSpec(
                          lineStyle: charty.LineStyleSpec(
                        dashPattern: [4, 4],
                      )),
                      // number format
                      tickFormatterSpec: new charty
                          .BasicNumericTickFormatterSpec.fromNumberFormat(
                        new NumberFormat.compactSimpleCurrency(),
                      ),
                      tickProviderSpec: new charty.BasicNumericTickProviderSpec(
                          zeroBound: false,
                          dataIsInWholeNumbers: true,
                          desiredTickCount: 5),
                    ),
                    dateTimeFactory: const charty.LocalDateTimeFactory(),
                  ),
                ),
              );
            }
          } else {
            List<charty.Series<OrdinalSales, String>> seriesList = [];
            graph.data.forEach(
              (d2) {
                List<OrdinalSales> data = [];

                print(d2.data.length);
                d2.data.forEach(
                  (f) {
                    print(f.value);
                    if (f.value != "") {
                      data.add(new OrdinalSales(
                          f.title, int.parse(f.value), f.color));
                    }
                  },
                );

                if (data.length == 0) {
                  data.add(new OrdinalSales("", 0, ""));
                }

                seriesList.add(
                  new charty.Series<OrdinalSales, String>(
                    id: d2.title,
                    colorFn: (OrdinalSales sales, __) =>
                        charty.ColorUtil.fromDartColor(HexColor(sales.color)),
                    domainFn: (OrdinalSales sales, _) => sales.year,
                    measureFn: (OrdinalSales sales, _) => sales.sales,
                    data: data,
                    labelAccessorFn: (OrdinalSales row, _) => '${row.sales}',
                  ),
                );
              },
            );

            if (seriesList.length > 0) {
              if (graph.type == "1") {
                // pie
                timeline.add(
                  new Container(
                    height: 250,
                    child: new charty.PieChart(
                      seriesList,
                      animate: true,
                      behaviors: [
                        new charty.DatumLegend(
                          entryTextStyle: charty.TextStyleSpec(fontSize: 11),
                          position: charty.BehaviorPosition.end,
                        ),
                      ],
                      defaultRenderer: new charty.ArcRendererConfig(
                        arcWidth: 60,
                        arcRendererDecorators: [new charty.ArcLabelDecorator()],
                      ),
                    ),
                  ),
                );
              } else if (graph.type == "2") {
                // stacked
                if (graph.horizontal != null && graph.horizontal == "1") {
                  timeline.add(
                    new Container(
                      height: 300,
                      child: new charty.BarChart(
                        seriesList,
                        animate: true,
                        vertical: false,
                        barGroupingType: charty.BarGroupingType.grouped,
                        behaviors: [new charty.SeriesLegend()],
                      ),
                    ),
                  );
                } else {
                  timeline.add(
                    new Container(
                      height: 300,
                      child: new charty.BarChart(
                        seriesList,
                        animate: true,
                        barGroupingType: charty.BarGroupingType.grouped,
                        behaviors: [new charty.SeriesLegend()],
                      ),
                    ),
                  );
                }
              } else if (graph.type == "4") {
                timeline.add(
                  new GridView.count(
                    shrinkWrap: true,
                    primary: false,
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 15.0,
                    crossAxisCount: 2,
                    children: graph.data[0].data.map(
                      (list) {
                        return new Card(
                          child: new Container(
                            padding: EdgeInsets.all(10),
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: new Text(
                                    list.value,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: HexColor(list.color),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                new Container(
                                  height: 10,
                                ),
                                new Row(
                                  children: <Widget>[
                                    new Expanded(
                                      child: new Text(
                                        list.title,
                                        textAlign: TextAlign.center,
                                        style: new TextStyle(
                                          fontSize: 17,
                                          color: HexColor(list.color),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                );
              } else if (graph.type == "5") {
                timeline.add(new ListView(
                  shrinkWrap: true,
                  primary: false,
                  children: graph.data[0].data.map((list) {
                    return new Container(
                      // height: 45,
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Expanded(
                            child: new Container(
                              child: new Text(
                                list.title,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: HexColor(list.color),
                                ),
                              ),
                            ),
                          ),
                          new Container(
                            margin: EdgeInsets.only(left: 5),
                            child: new Text(
                              list.value,
                              style: TextStyle(
                                fontSize: 20,
                                color: HexColor(list.color),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ));
              }
            }
          }
        },
      );
    }
    setState(() {
      loading = false;
    });
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
            "Analytics",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 4.0,
        ),
        body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: new Container(
            height: MediaQuery.of(context).size.height,
            child: new Container(
              margin: new EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.1,
                  0,
                  MediaQuery.of(context).size.width * 0.1,
                  0),
              child: loading
                  ? new Container()
                  : new Column(
                      children: <Widget>[
                        new Container(
                          height: 50,
                          margin: new EdgeInsets.fromLTRB(15, 15, 0, 0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: new Text("Bill Date"),
                              ),
                              new Flexible(
                                child: new Container(
                                  margin: new EdgeInsets.fromLTRB(15, 0, 0, 0),
                                  child: new FlatButton(
                                      onPressed: () async {
                                        final List<DateTime> picked =
                                            await DateRagePicker.showDatePicker(
                                                context: context,
                                                initialFirstDate:
                                                    (new DateTime.now()).add(
                                                        new Duration(
                                                            days: -6 * 30)),
                                                initialLastDate:
                                                    (new DateTime.now()).add(
                                                        new Duration(days: 1)),
                                                firstDate: new DateTime.now()
                                                    .subtract(new Duration(
                                                        days: 10 * 365)),
                                                lastDate: new DateTime.now()
                                                    .add(new Duration(days: 10 * 365)));
                                        if (picked != null &&
                                            picked.length == 2) {
                                          billDates = picked;
                                          setState(() {
                                            fromDate = billDates[0];
                                            toDate = billDates[1];
                                            billDatesRange = headingDateFormat
                                                    .format(billDates[0]) +
                                                " to " +
                                                headingDateFormat
                                                    .format(billDates[1]);
                                          });
                                          getanalyticsdata();
                                        }
                                      },
                                      child: new Text(billDatesRange)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        new Expanded(
                          child: new ListView(
                            shrinkWrap: true,
                            children: timeline,
                          ),
                        )
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
