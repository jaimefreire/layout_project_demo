import 'plocation.dart';

class CameraPosition {
  final PLocation center;
  final double zoom;

  const CameraPosition(this.center, this.zoom);

  factory CameraPosition.fromMap(Map map) {
    return new CameraPosition(new PLocation.fromMap(map), map["zoom"]);
  }

  Map toMap() {
    Map map = center.toMap();
    map["zoom"] = zoom;
    return map;
  }
}
