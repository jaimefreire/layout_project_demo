import 'dart:async';

import 'plocation.dart';
import 'package:uri/uri.dart';
import 'p_map_view.dart';
import 'locations.dart';

class StaticMapProvider {
  final String googleMapsApiKey;
  static const int defaultZoomLevel = 4;
  static const int defaultWidth = 600;
  static const int defaultHeight = 400;

  StaticMapProvider(this.googleMapsApiKey);

  ///
  /// Creates a Uri for the Google Static Maps API
  /// Centers the map on [center] using a zoom of [zoomLevel]
  /// Specify a [width] and [height] that you would like the resulting image to be. The default is 600w x 400h
  ///

  Uri getStaticUri(PLocation center, int zoomLevel, {int width, int height}) {
    return _buildUrl(null, center, zoomLevel ?? defaultZoomLevel,
        width ?? defaultWidth, height ?? defaultHeight);
  }

  ///
  /// Creates a Uri for the Google Static Maps API using a list of locations to create pins on the map
  /// [locations] must have at least 1 location
  /// Specify a [width] and [height] that you would like the resulting image to be. The default is 600w x 400h
  ///

  Uri getStaticUriWithMarkers(List<Marker> markers, {int width, int height}) {
    return _buildUrl(
        markers, null, null, width ?? defaultWidth, height ?? defaultHeight);
  }

  ///
  /// Creates a Uri for the Google Static Maps API using an active MapView
  /// This method is useful for generating a static image
  /// [mapView] must currently be visible when you call this.
  /// Specify a [width] and [height] that you would like the resulting image to be. The default is 600w x 400h
  ///
  Future<Uri> getImageUriFromMap(PMapView mapView,
      {int width, int height}) async {
    List markers = await mapView.visibleAnnotations;
    var center = await mapView.centerPLocation;
    var zoom = await mapView.zoomLevel;
    return _buildUrl(markers, center, zoom.toInt(), width ?? defaultWidth,
        height ?? defaultHeight);
  }

  Uri _buildUrl(List<Marker> locations, PLocation center, int zoomLevel,
      int width, int height) {
    var finalUri = new UriBuilder()
      ..scheme = 'https'
      ..host = 'maps.googleapis.com'
      ..port = 443
      ..path = '/maps/api/staticmap';

    if (center == null && (locations == null || locations.length == 0)) {
      center = Locations.centerOfUSA;
    }

    if (locations == null || locations.length == 0) {
      if (center == null) center = Locations.centerOfUSA;
      finalUri.queryParameters = {
        'center': '${center.latitude},${center.longitude}',
        'zoom': zoomLevel.toString(),
        'size': '${width ?? defaultWidth}x${height ?? defaultHeight}',
        'key': googleMapsApiKey,
      };
    } else {
      List<String> markers = new List();
      locations.forEach((location) {
        num lat = location.latitude;
        num lng = location.longitude;
        String marker = '$lat,$lng';
        markers.add(marker);
      });
      String markersString = markers.join('|');
      finalUri.queryParameters = {
        'markers': markersString,
        'size': '${width ?? defaultWidth}x${height ?? defaultHeight}',
        'key': googleMapsApiKey,
      };
    }

    var uri = finalUri.build();
    return uri;
  }
}
