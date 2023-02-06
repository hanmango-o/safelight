// ignore_for_file: constant_identifier_names

import 'package:hive/hive.dart';

part 'flash_mode.g.dart';

@HiveType(typeId: 2)
enum FlashMode {
  @HiveField(0)
  WITH_WEATHER,

  @HiveField(1)
  ALWAYS,

  @HiveField(2)
  NEVER_IN_USE,
}
