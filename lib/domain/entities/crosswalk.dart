import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:latlong2/latlong.dart';
import 'package:safelight/core/utils/enums.dart';

class Crosswalk extends Equatable {
  final String name;
  final BluetoothDevice post;
  final ECrosswalk type;
  final String? dir;
  final LatLng? pos;

  const Crosswalk({
    required this.name,
    required this.post,
    required this.type,
    required this.dir,
    required this.pos,
  });

  @override
  List<Object?> get props => [name, post, type, dir, pos];

  @override
  String toString() {
    return '{name : $name, post : $post, type : $type, dir : $dir, pos : $pos}';
  }
}
