class PLocation {
  final double latitude;
  final double longitude;

  const PLocation(this.latitude, this.longitude);
  factory PLocation.fromMap(Map map) {
    return new PLocation(map["latitude"], map["longitude"]);
  }

  Map toMap() {
    return {"latitude": this.latitude, "longitude": this.longitude};
  }

  @override
  String toString() {
    return 'PLocation{latitude: $latitude, longitude: $longitude}';
  }
}
