import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:safelight/asset/static/size_theme.dart';

class SystemTheme {
  static const String themeBox = 'themeBox';
  static const String mode = 'mode';

  static ThemeData systemMode(ColorScheme scheme) {
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: scheme.primary,
        onPrimary: scheme.onPrimary,
        secondary: scheme.secondary,
        onSecondary: scheme.onSecondary,
        background: scheme.background,
        onBackground: scheme.onBackground,
        surface: scheme.surface,
      ),
      cardColor: scheme.background,
      scaffoldBackgroundColor: scheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.secondary,
        actionsIconTheme: IconThemeData(
          color: scheme.onSecondary,
          size: 36.sp,
        ),
        foregroundColor: scheme.onSecondary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          color: scheme.onSecondary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        iconColor: scheme.background,
        hintStyle: const TextStyle(
          color: Colors.grey,
          // fontSize: 14.sp,
          // fontWeight: FontWeight.bold,
        ),
        prefixIconColor: Colors.grey,
        labelStyle: TextStyle(
          color: scheme.onSecondary,
          fontSize: 22.sp,
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: SizeTheme.h_sm,
          horizontal: SizeTheme.w_md,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: scheme.background,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: scheme.background,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: scheme.background,
          ),
        ),
        fillColor: scheme.background,
        filled: true,
        focusColor: scheme.background,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: scheme.background,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: scheme.background,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: Size(double.minPositive, 52.h),
          padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 16.h),
          textStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(14.r),
            ),
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        selectedIconTheme: IconThemeData(size: 32.sp),
        unselectedIconTheme: IconThemeData(size: 32.sp),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.background,
        thickness: 1.5,
      ),
      listTileTheme: ListTileThemeData(
        tileColor: scheme.secondary,
        shape: Border.symmetric(
          horizontal: BorderSide(color: scheme.background, width: 1),
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: scheme.onSecondary,
        ),
        titleLarge: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: scheme.onSecondary,
        ),
        titleMedium: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.normal,
          color: scheme.onSecondary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: scheme.onSecondary,
        ),
        bodyMedium: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: scheme.onSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.normal,
          color: scheme.onSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: scheme.onBackground,
        ),
        labelMedium: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.normal,
          color: scheme.onSecondary,
        ),
      ),
    );
  }
}
