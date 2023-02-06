import 'package:hive/hive.dart';

import 'color_mode.dart';
import 'flash_mode.dart';

part 'setting.g.dart';

@HiveType(typeId: 0)
class Setting {
  static const String db = 'setting';

  @HiveField(0)
  ColorMode colorMode;

  @HiveField(1)
  bool tts;

  @HiveField(2)
  FlashMode flashMode;

  Setting({
    this.colorMode = ColorMode.SYSTEM,
    this.tts = true,
    this.flashMode = FlashMode.WITH_WEATHER,
  });

  @override
  String toString() {
    return '{colorMode : $colorMode, tts : $tts, flashMode : $flashMode}';
  }
}
