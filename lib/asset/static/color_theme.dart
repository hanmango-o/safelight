import 'package:flutter/material.dart';

class ColorTheme {
  static const Color highlight1 = Color(0xffFFBC42);
  static const Color highlight2 = Color(0xff619B8A);
  static const Color highlight3 = Color(0xff0496FF);
  static const Color highlight4 = Color(0xffD81159);

  static const ColorScheme light = ColorScheme.light(
    primary: Color(0xff758BFD),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFFFFFFFF),
    onSecondary: Color(0xff2A2C41),
    background: Color(0xffF1F2F6),
    onBackground: Color(0xff939AA3),
    surface: Color(0xffEAEAEA),
  );

  static const ColorScheme dark = ColorScheme.dark(
    primary: Color(0xff758BFD),
    onPrimary: Color.fromARGB(255, 255, 255, 255),
    secondary: Color.fromARGB(255, 40, 40, 40),
    onSecondary: Color(0xffF1F2F6),
    background: Colors.black,
    onBackground: Color(0xffEAEAEA),
    surface: Colors.grey,
  );
}
