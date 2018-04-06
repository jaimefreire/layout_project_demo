import 'dart:core';

import 'package:TearsInTheRain/listen-share-pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
import 'package:location/location.dart';
import 'package:map_view/p_map_view.dart';

import 'build-helper.dart' as BuildHelper;
import 'favorites_manager.dart' as FavManager;

//
var apiKey = "AIzaSyB5dkM5TMvwMYz1HPdYQpc7GAdG3CypXsc";
var locationService;

void main() {
  debugPaintSizeEnabled = false;
  //Inits location tracking
  locationService = new Location();
  PMapView.setApiKey(apiKey);

  FavManager.getCurrentLocation(locationService);
  FavManager.printLocationUpdates(locationService);
  runApp(new HomePage());
}

class HomePage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Tears in the Rain'),
        ),
        body: new ListView(
          children: <Widget>[
            new Image.asset(
              'images/tears_logo.jpg',
              width: 450.0,
              height: 450.0,
              fit: BoxFit.cover,
            ),
            BuildHelper.BuildHelper.buildTitleSection(),
            BuildHelper.BuildHelper.buildbuttonSection(context)
          ],
        ),
      ),
      routes: <String, WidgetBuilder>{
        '/share': (BuildContext context) => new ShareScreen(),
        '/listen': (BuildContext context) => new ListenScreen(),
        '/faq': (BuildContext context) => new FAQScreen(),
      },
    );
  }
}
