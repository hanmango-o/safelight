import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:safelight/asset/static/color_theme.dart';
import 'package:safelight/ui/view/blue_off_view.dart';
import 'package:safelight/ui/view/home_view.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(const SafeLight());
}

class SafeLight extends StatelessWidget {
  const SafeLight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            primary: ColorTheme.primary,
            onPrimary: ColorTheme.onPrimary,
            secondary: ColorTheme.secondary,
            onSecondary: ColorTheme.onSecondary,
            background: ColorTheme.background,
            onBackground: ColorTheme.onBackground,
          ),
          scaffoldBackgroundColor: ColorTheme.background,
          appBarTheme: AppBarTheme(
            backgroundColor: ColorTheme.secondary,
            actionsIconTheme: IconThemeData(
              color: ColorTheme.onSecondary,
              size: 36.sp,
            ),
            elevation: 0,
            centerTitle: false,
            titleTextStyle: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: ColorTheme.onSecondary,
            ),
          ),
        ),
        home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return HomeView();
            }
            // return BlueOffView(state: state!);
            return HomeView();
          },
        ),
      ),
    );
  }
}
