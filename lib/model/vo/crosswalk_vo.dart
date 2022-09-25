import 'package:flutter_blue/flutter_blue.dart';
import 'package:safelight/asset/resource/blue_resource.dart';
import 'package:safelight/model/vo/position_vo.dart';

class CrosswalkVO {
  late String name; // ~횡단보도
  late BluetoothDevice device; // 실제 포스트 정보
  late AreaType areaType; // 단일 신호등 지역 or 교차로
  late String? direction;
  late Position? position; // 위도 경도
  // late bool fnctngSgngnrYn; // 보행자 작동 신호기 유무 (황색불 지역 or 기존 교통 신호 지역)

  CrosswalkVO({
    this.name = '횡단보도',
    required this.device,
    this.areaType = AreaType.SINGLE_ROAD,
    this.direction,
    this.position,
  });

  CrosswalkVO.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        device = map['device'],
        areaType = map['areaType'],
        direction = map['direction'],
        position = map['position'];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'device': device,
      'areaType': areaType,
      'direction': direction,
      'position': position,
    };
  }

  @override
  String toString() {
    return '{name : $name, device : $device, areaType : $areaType, direction : $direction, position : $position}';
  }
}