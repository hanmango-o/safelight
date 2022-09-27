import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:safelight/asset/static/color_theme.dart';
import 'package:safelight/firebase_options.dart';
import 'package:safelight/ui/view/home_view.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:safelight/ui/view/main_view.dart';
import 'package:safelight/ui/view/sign_in_view.dart';
import 'package:safelight/view_model/controller/blue_controller.dart';
import 'package:safelight/view_model/controller/user_controller.dart';

// v0.3.1 | 한영찬(hanmango-o) | hanmango.o@gmail.com

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(UserController());
  Get.put(BlueController());

  runApp(SafeLight());
}

class SafeLight extends StatelessWidget {
  final UserController _userController = Get.find<UserController>();

  SafeLight({Key? key}) : super(key: key);

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
            surface: ColorTheme.surface,
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
            color: ColorTheme.background,
            thickness: 1.5,
          ),
          listTileTheme: ListTileThemeData(
            tileColor: ColorTheme.secondary,
            shape: Border.symmetric(
              horizontal: BorderSide(color: ColorTheme.background, width: 1),
            ),
          ),
          textTheme: TextTheme(
            headlineLarge: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: ColorTheme.onSecondary,
            ),
            titleLarge: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: ColorTheme.onSecondary,
            ),
            titleMedium: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.normal,
              color: ColorTheme.onSecondary,
            ),
            bodyLarge: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: ColorTheme.onSecondary,
            ),
            bodyMedium: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: ColorTheme.onSecondary,
            ),
            bodySmall: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.normal,
              color: ColorTheme.onSecondary,
            ),
            labelLarge: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: ColorTheme.onBackground,
            ),
            labelMedium: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.normal,
              color: ColorTheme.onSecondary,
            ),
          ),
        ),
        getPages: [
          GetPage(name: '/main', page: () => MainView()),
          GetPage(name: '/sign/in', page: () => SignInView()),
        ],
        home: StreamBuilder(
          stream: _userController.auth.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return SignInView();
            } else {
              log('dddd');
              return MainView();
            }
          },
        ),
        // home: StreamBuilder<BluetoothState>(
        //   stream: FlutterBlue.instance.state,
        //   initialData: BluetoothState.unknown,
        //   builder: (c, snapshot) {
        //     final state = snapshot.data;
        //     if (state == BluetoothState.on) {
        //       return HomeView();
        //     }
        //     // return BlueOffView(state: state!);
        //     return MainView();
        //   },
        // ),
      ),
    );
  }
}
