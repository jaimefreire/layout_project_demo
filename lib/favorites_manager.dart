import 'dart:async';
import 'dart:collection';
import 'package:TearsInTheRain/composite_subscription.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:map_view/p_map_view.dart';
import 'favorite.dart';

class MyFavoritesApp extends StatefulWidget {
  //TODO
  FavoritesManager manager;

  @override
  _MyAppState createState() => new _MyAppState();

  MyFavoritesApp(); // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Tears in the Rain',
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: new MyFavoritesApp(),
    );
  }
}


class _MyAppState extends State<MyFavoritesApp> {
  PMapView pMapView = new PMapView();
  var compositeSubscription = new CompositeSubscription();

  Future _updateRestaurantsAroundUser() async {
    //1. Ask the mapView for the center lat,lng of it's viewport.
    var mapCenter = await pMapView.centerPLocation;
    //2. Search for restaurants using the Places API
    var placeApi = new places.GoogleMapsPlaces(apiKey);
    var placeResponse = await placeApi.searchNearbyWithRadius(
        new places.Location(mapCenter.latitude, mapCenter.longitude), 200,
        type: "restaurant");

    if (placeResponse.hasNoResults) {
      print("No results");
      return;
    }
    var results = placeResponse.results;

    //3. Call our _updateMarkersFromResults method update the pins on the map
    _updateMarkersFromResults(results);

    //4. Listen for the onInfoWindowTapped callback so we know when the user picked a favorite.
    var sub = pMapView.onInfoWindowTapped.listen((m) {
      var selectedResult = results.firstWhere((r) => r.id == m.id);
      if (selectedResult != null) {
        _addPlaceToFavorites(selectedResult);
      }
    });
    compositeSubscription.add(sub);
  }

  void _updateMarkersFromResults(List<places.PlacesSearchResult> results) {
    //1. Turn the list of `PlacesSearchResult` into `Markers`
    var markers = results
        .map((r) => new Marker(
        r.id, r.name, r.geometry.location.lat, r.geometry.location.lng))
        .toList();

    //2. Get the list of current markers
    var currentMarkers = pMapView.markers;

    //3. Create a list of markers to remove
    var markersToRemove = currentMarkers.where((m) => !markers.contains(m));

    //4. Create a list of new markers to add
    var markersToAdd = markers.where((m) => !currentMarkers.contains(m));

    //5. Remove the relevant markers from the map
    markersToRemove.forEach((m) => pMapView.removeMarker(m));

    //6. Add the relevant markers to the map
    markersToAdd.forEach((m) => pMapView.addMarker(m));
  }

  _addPlaceToFavorites(places.PlacesSearchResult result) {
    var staticMapProvider = new StaticMapProvider(apiKey);
    var marker = new Marker(result.id, result.name,
        result.geometry.location.lat, result.geometry.location.lng);
    var url = staticMapProvider
        .getStaticUriWithMarkers([marker], width: 340, height: 120);
    var favorite = new Favorite(result.name, result.geometry.location.lat,
        result.geometry.location.lat, result.vicinity, url.toString());
    widget.manager.addFavorite(favorite);
    pMapView.dismiss();
    compositeSubscription.cancel();
  }

  Future _showMap() async {
    dynamic locationMap = await _getCurrentLocation(locationService);
    PLocation currentLocation =
    new PLocation(locationMap["latitude"], locationMap["longitude"]);

    //1. Show the map
    pMapView.show(
        new MapOptions(
            showUserLocation: true,
            title: "Share your thoughts",
            initialCameraPosition: new CameraPosition(currentLocation, 18.0)),
        toolbarActions: <ToolbarAction>[
          new ToolbarAction("Close", 1),
          new ToolbarAction("Save", 2)
        ]);

    //2. Listen for the onMapReady
    var sub = pMapView.onMapReady.listen((_) => _updateRestaurantsAroundUser());
    compositeSubscription.add(sub);

    //3. Listen for camera changed events
    sub = pMapView.onCameraChanged
        .listen((cam) => _updateRestaurantsAroundUser());
    compositeSubscription.add(sub);

    //4. Listen for toolbar actions
    sub = pMapView.onToolbarAction.listen((id) {
      if (id == 1) {
        pMapView.dismiss();
      }
    });
    compositeSubscription.add(sub);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget titleSection = new Container(
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
                        children: <Widget>[buildTextLine()]),
                  )
                ],
              )),
        ],
      ),
    );

    Column buildButtonColumnActionable(IconData icon, String label) {
      Color color = Theme.of(context).primaryColor;
      return new Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new IconButton(
                iconSize: 32.0,
                icon: new Icon(icon, color: color),
                onPressed: () {
                  Navigator.of(context).pushNamed('/map');
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

    Column buildButtonColumn(IconData icon, String label) {
      Color color = Theme.of(context).primaryColor;
      return new Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new IconButton(iconSize: 32.0, icon: new Icon(icon, color: color)),
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

    Column buildEmptyColumn() {
      return new Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: []);
    }

    //TODO Is this needed?
    Widget textSection = new Container(
      padding: const EdgeInsets.all(32.0),
      child: new Text(
        '''
Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese Alps. Situated 1,578 meters above sea level, it is one of the larger Alpine Lakes. A gondola ride from Kandersteg, followed by a half-hour walk through pastures and pine forest, leads you to the lake, which warms to 20 degrees Celsius in the summer. Activities enjoyed here include rowing, and riding the summer toboggan run.
        ''',
        softWrap: true,
      ),
    );

    Widget buttonSection = new Container(
        margin: const EdgeInsets.all(1.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildButtonColumnActionable(Icons.add_location, 'Share'),
            buildButtonColumn(Icons.autorenew, 'Listen'),
            buildEmptyColumn(),
            buildButtonColumn(Icons.question_answer, 'WTF?'),
          ],
        ));
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
            titleSection,
            buttonSection,
          ],
        ),
      ),
      routes: <String, WidgetBuilder>{
        '/share': (BuildContext context) => new ShareScreen(),
        '/listen': (BuildContext context) => new ListenScreen(),
      },
    );
  }
}

class FavoritesManager {
  List<Favorite> _favorites = [];
  StreamController _favStreamController = new StreamController.broadcast();

  Stream<List<Favorite>> get onFavoritesChanged => _favStreamController.stream;

  List<Favorite> get favorites => _favorites;

  void addFavorite(Favorite fav) {
    _favorites.add(fav);
    _favStreamController.add(_favorites);
  }

  void removeFavorite(Favorite fav) {
    _favorites.remove(fav);
    _favStreamController.add(_favorites);
  }
}

void printLocationUpdates(Location locationService) {
  //
  locationService.onLocationChanged.listen((dynamic updatedLocation) {
    print(updatedLocation["latitude"].toString() +
        ':' +
        updatedLocation["longitude"].toString() +
        ':' +
        updatedLocation["accuracy"].toString() +
        ': ' +
        updatedLocation["altitude"].toString());
  });
}

dynamic getCurrentLocation(Location locationService) async {
  dynamic currentLocation = new LinkedHashMap();
  currentLocation = await locationService.getLocation;
  print(currentLocation);
  return currentLocation;
}
