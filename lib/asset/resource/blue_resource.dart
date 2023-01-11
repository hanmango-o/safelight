// ignore_for_file: constant_identifier_names

enum AreaType {
  SINGLE_ROAD, // 단일 신호등 지역 : 0
  INTERSECTION, // 교차로 지역 : 1
  FLASH_CROSSING, // 점멸 신호등 지역 : 2
}

enum StatusType {
  IS_SCANNING,
  STAND_BY,
  COMPLETE,
  IS_CONNECTING,
  CONNECTED_COMPLETE,
  ERROR,
}
