class LocationVO {
  String name;
  String address;
  double lat;
  double lon;

  LocationVO({
    required this.name,
    required this.address,
    required this.lat,
    required this.lon,
  });

  LocationVO.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        address = map['fullAddressRoad'],
        lat = map['noorLat'],
        lon = map['noorLon'];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'lat': lat,
      'lon': lon,
    };
  }

  @override
  String toString() {
    return '{name : $name, address : $address, lat : $lat, lon : $lon}';
  }
}
