// ignore_for_file: constant_identifier_names

import 'package:hive/hive.dart';

part 'color_mode.g.dart';

@HiveType(typeId: 1)
enum ColorMode {
  @HiveField(0)
  SYSTEM,

  @HiveField(1)
  LIGHT,

  @HiveField(2)
  DARK,
}
