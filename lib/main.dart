import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:safelight/asset/static/color_theme.dart';
import 'package:safelight/asset/static/system_theme.dart';
import 'package:safelight/firebase_options.dart';
import 'package:safelight/ui/view/main_view.dart';
import 'package:safelight/ui/view/sign_in_view.dart';
import 'package:safelight/view_model/controller/blue_controller.dart';
import 'package:safelight/view_model/controller/nav_controller.dart';
import 'package:safelight/view_model/controller/service_controller.dart';
import 'package:safelight/view_model/controller/user_controller.dart';
import 'package:safelight/view_model/implement/service/weather_impl.dart';

// v0.9.0 | 한영찬(hanmango-o) | hanmango.o@gmail.com

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  log('1');

  await Hive.initFlutter();
  await Hive.openBox(SystemTheme.themeBox);
  log('2');

  Get.put(UserController());
  Get.put(BlueController());
  final NavController _navController = Get.put(NavController());
  final ServiceController _serviceController = Get.put(ServiceController());
  log('3');

  try {
    await _navController.setLocation();
    await _serviceController.getWeather();
  } catch (e) {}

  log('4');
  FlutterNativeSplash.remove();

  runApp(SafeLight());
}

class SafeLight extends StatelessWidget {
  final UserController _userController = Get.find<UserController>();

  SafeLight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) => ValueListenableBuilder(
        valueListenable: Hive.box(SystemTheme.themeBox).listenable(),
        builder: (context, Box box, widget) {
          String? mode = box.get(
            SystemTheme.mode,
            defaultValue: ThemeMode.system.name,
          );
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            darkTheme: SystemTheme.systemMode(ColorTheme.dark),
            themeMode: ThemeMode.values.byName(mode ?? ThemeMode.system.name),
            theme: SystemTheme.systemMode(ColorTheme.light),
            getPages: [
              GetPage(name: '/main', page: () => const MainView()),
              GetPage(name: '/sign/in', page: () => const SignInView()),
            ],
            home: StreamBuilder(
              stream: _userController.auth.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const SignInView();
                } else {
                  return const MainView();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
