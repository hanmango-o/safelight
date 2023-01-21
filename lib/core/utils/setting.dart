import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'setting.g.dart';

@HiveType(typeId: 0)
class Setting {
  @HiveField(0)
  ThemeMode mode;

  Setting({required this.mode});
}
