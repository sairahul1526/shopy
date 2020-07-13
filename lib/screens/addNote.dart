import 'package:flutter/material.dart';

class AddNoteActivity extends StatefulWidget {
  final String note;

  AddNoteActivity(this.note);

  @override
  State<StatefulWidget> createState() {
    return new AddNoteActivityState(this.note);
  }
}

class AddNoteActivityState extends State<AddNoteActivity> {
  TextEditingController notes = new TextEditingController();

  String note;

  AddNoteActivityState(this.note);

  @override
  void initState() {
    super.initState();

    this.notes.text = note;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: new Container(
          child: new FlatButton(
            onPressed: () {
              Navigator.pop(context, notes.text);
            },
            child: new Text("SAVE"),
          ),
        ),
        elevation: 0,
      ),
      appBar: new AppBar(
        backgroundColor: Colors.white,
        title: new Text(
          "Note",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              setState(() {
                notes.text = "";
              });
            },
            child: new Text("Clear"),
          ),
        ],
        elevation: 4.0,
      ),
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: new Container(
          height: MediaQuery.of(context).size.height,
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
                    new Expanded(
                      child: new Container(
                        margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
                        child: new TextField(
                          cursorColor: Colors.black,
                          controller: notes,
                          maxLines: 5,
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: '...',
                          ),
                          onSubmitted: (String value) {},
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
