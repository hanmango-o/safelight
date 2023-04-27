part of object;

class Tmap extends Equatable {
  final String version;
  final LatLng startX;
  final LatLng startY;
  final LatLng endX;
  final LatLng endY;
  final String startName;
  final String endName;
  final String type;

  const Tmap({
    required this.version,
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
    required this.startName,
    required this.endName,
    required this.type,
  });

  @override
  List<Object?> get props => [];

  @override
  String toString() {
    return '{version : $version, startX : $startX, startY : $startY, endX : $endX, endY : $endY, startName : $startName, endName : $endName, type : $type}';
  }
}
