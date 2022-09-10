import 'package:flutter/material.dart';

enum ColorMode {
  light,
  dark,
}

class ColorTheme {
  static const Color primary = Color(0xff758BFD);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xff2A2C41);
  static const Color background = Color(0xffF1F2F6);
  static const Color onBackground = Color(0xff939AA3);
  static const Color highlight1 = Color(0xffFFBC42);
  static const Color highlight2 = Color(0xff619B8A);
  static const Color highlight3 = Color(0xff0496FF);
  static const Color highlight4 = Color(0xffD81159);

  static const ColorScheme _light = ColorScheme.light(
    primary: Color(0xff758BFD),
    onPrimary: Color(0xFFFFFFFF),
    background: Color(0xffF1F2F6),
    secondary: Colors.amber,
    onBackground: Colors.black,
  );
  static const ColorScheme _dark = ColorScheme.dark();

  static ColorScheme getColorTheme(ColorMode mode) {
    switch (mode) {
      case ColorMode.light:
        return _light;
      case ColorMode.dark:
        return _dark;
    }
  }
}
