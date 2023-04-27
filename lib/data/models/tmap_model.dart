part of object;

class TmapModel extends Tmap {
  const TmapModel({
    required super.version,
    required super.startX,
    required super.startY,
    required super.endX,
    required super.endY,
    required super.startName,
    required super.endName,
    required super.type,
  });

  factory TmapModel.fromJson(Map<String, dynamic> json) {
    return TmapModel(
      version: json['version'],
      startX: json['startX'],
      startY: json['startY'],
      startName: json['startName'],
      endX: json['endX'],
      endY: json['endY'],
      endName: json['endName'],
      type: json['type'],
    );
  }
}
