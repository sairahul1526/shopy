import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shopy/screens/category.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:async';

import '../utils/config.dart';
import '../utils/models.dart';
import '../utils/utils.dart';
import '../utils/api.dart';

class CategoriesActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CategoriesActivityState();
  }
}

class CategoriesActivityState extends State<CategoriesActivity> {
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
    getcategoriesapi();
  }

  void getcategoriesapi() {
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
        Future<Categories> data = getCategories({});
        data.then((response) {
          if (response != null) {
            _refreshController.refreshCompleted();
            categories.clear();
            categoriesMap.clear();
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
            setState(() {
              loading = false;
              search.text = "";
            });
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

  addPage(BuildContext context, Widget page) async {
    final data = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    ) as String;
    if (data != null) {
      getcategoriesapi();
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
                  addPage(context, new CategoryActivity(null));
                },
                icon: new Icon(Icons.add),
              ),
            ],
            backgroundColor: Colors.white,
            title: new Text(
              "Categories",
              style: TextStyle(color: Colors.black),
            ),
            elevation: 4.0,
            bottom: TabBar(
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
                          hintText: 'Search categories',
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
                child: categoriesMap.length == 0 && !loading
                    ? new Center(
                        child: new MaterialButton(
                          child: new Text(
                            "Add Category",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () {
                            addPage(context, new CategoryActivity(null));
                          },
                        ),
                      )
                    : new SmartRefresher(
                        onRefresh: _onRefresh,
                        controller: _refreshController,
                        child: new ListView(
                          children: categories
                              .where(
                                  (category) => category.categoryUID.length > 0)
                              .where((category) => search.text.length == 0
                                  ? true
                                  : category.name
                                      .toLowerCase()
                                      .contains(search.text.toLowerCase()))
                              .map(
                            (category) {
                              return new ListTile(
                                onTap: () {
                                  addPage(
                                      context, new CategoryActivity(category));
                                },
                                title: new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    new Expanded(
                                      child: new Container(
                                        padding: EdgeInsets.only(left: 15),
                                        child: new Text(
                                          category.name,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    new IconButton(
                                      onPressed: () {
                                        addPage(context,
                                            new CategoryActivity(category));
                                      },
                                      icon: new Icon(
                                        Icons.reorder,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
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
