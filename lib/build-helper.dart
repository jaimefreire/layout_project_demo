import 'dart:core';

import 'package:flutter/material.dart';

class BuildHelper {
  static Widget buildTitleSection() {
    return new Container(
      padding: const EdgeInsets.all(32.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: new Text(
                  "An inmersive travel through the world's infinite collective mind",
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              new Container(
                margin: const EdgeInsets.only(top: 6.0),
                child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[BuildHelper.buildThoughtsSharedLine()]),
              )
            ],
          )),
        ],
      ),
    );
  }

  static Widget buildThoughtsSharedLine() {
    return new Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          new Text("Current thoughts shared",
              style: new TextStyle(color: Colors.grey[500])),
          new Container(
            margin: const EdgeInsets.only(top: 1.0),
            child: new Icon(
              Icons.star,
              color: Colors.red[500],
            ),
          )
        ]);
  }

  static Column buildButtonColumnActionable(
      BuildContext context, IconData icon, String label, String route) {
    Color color = Theme.of(context).primaryColor;
    return new Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new IconButton(
              iconSize: 32.0,
              icon: new Icon(icon, color: color),
              onPressed: () {
                Navigator.of(context).pushNamed(route);
              }),
          new Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: new Text(label,
                  style: new TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: color,
                  ))),
        ]);
  }

  static Column buildEmptyColumn() {
    return new Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: []);
  }

  static Column buildTextLine() {
    return new Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          new Text("Current thoughts shared",
              style: new TextStyle(color: Colors.grey[500])),
          new Container(
            margin: const EdgeInsets.only(top: 1.0),
            child: new Icon(
              Icons.star,
              color: Colors.red[500],
            ),
          )
        ]);
  }

  static Widget buildbuttonSection(BuildContext context) {
    return new Container(
        margin: const EdgeInsets.all(1.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildButtonColumnActionable(
                context, Icons.add_location, 'Share', "/share"),
            buildButtonColumnActionable(
                context, Icons.autorenew, 'Listen', '/listen'),
            buildEmptyColumn(),
            buildButtonColumnActionable(
                context, Icons.question_answer, 'WTF?', '/faq'),
          ],
        ));
  }
}
