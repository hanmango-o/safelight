// ignore_for_file: constant_identifier_names

enum AreaType {
  SINGLE_ROAD, // 단일 신호등 지역
  INTERSECTION, // 교차로 지역
  FLASH_CROSSING, // 점멸 신호등 지역
}

enum StatusType {
  IS_SCANNING,
  STAND_BY,
  COMPLETE,
}
