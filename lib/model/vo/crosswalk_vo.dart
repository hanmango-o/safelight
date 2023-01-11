import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:safelight/asset/resource/blue_resource.dart';
import 'package:safelight/model/vo/position_vo.dart';

class CrosswalkVO {
  late final String name;
  late final BluetoothDevice post;
  late final AreaType type;
  late final String? dir;
  late final LatLng? pos;

  CrosswalkVO({
    this.name = '횡단보도',
    required this.post,
    this.type = AreaType.SINGLE_ROAD,
    this.dir,
    this.pos,
  });

  CrosswalkVO.fromDB(
      Map<String, dynamic> map, this.post, List<double>? position) {
    const Distance distance = Distance();

    Map<String, dynamic> pos1 = map['pos'][0];
    Map<String, dynamic> pos2 = map['pos'][1];

    LatLng geo1 = LatLng(pos1['geo'].latitude, pos1['geo'].longitude);
    LatLng geo2 = LatLng(pos2['geo'].latitude, pos2['geo'].longitude);

    if (position != null) {
      LatLng geo = LatLng(position[0], position[1]);

      double meter1 = distance(geo, geo1);
      double meter2 = distance(geo, geo2);
      if (meter1 > meter2) {
        pos = geo1;
        dir = pos1['dir'];
      } else if (meter1 < meter2) {
        pos = geo2;
        dir = pos2['dir'];
      }
    }
    name = map['name'];
    type = AreaType.values[map['type']];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'post': post,
      'type': type,
      'dir': dir,
      'pos': pos,
    };
  }

  @override
  String toString() {
    return '{name : $name, post : $post, type : $type, dir : $dir, pos : $pos}';
  }
}
