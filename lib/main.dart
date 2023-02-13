import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:safelight/core/utils/tts.dart';
import 'package:safelight/injection.dart';
import 'package:safelight/initializer.dart' as initializer;

import 'core/utils/themes.dart';
import 'presentation/bloc/auth_bloc.dart';
import 'presentation/bloc/crosswalk_bloc.dart';
import 'presentation/cubit/bluetooth_permission_cubit.dart';
import 'presentation/cubit/location_permission_cubit.dart';
import 'presentation/views/main_view.dart';
import 'presentation/views/sign_in_view.dart';

// v1.3.1(ios), v1.1.2(android) | 한영찬(hanmango-o) | hanmango.o@gmail.com

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializer.init();
  FlutterNativeSplash.remove();
  runApp(SafeLight(auth: DI.get<FirebaseAuth>()));
}

class SafeLight extends StatelessWidget {
  final FirebaseAuth auth;

  const SafeLight({Key? key, required this.auth}) : super(key: key);

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
          TTS.enable = box.get('tts', defaultValue: false);
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => DI.get<CrosswalkBloc>(
                  instanceName: BLOC_BLUE_SEARCH_FINITE,
                ),
              ),
              BlocProvider(
                create: (_) => DI.get<AuthBloc>(),
              ),
              BlocProvider(
                create: (_) => DI.get<BluetoothPermissionCubit>(),
              ),
              BlocProvider(
                create: (_) => DI.get<LocationPermissionCubit>(),
              ),
            ],
            child: MaterialApp(
              // showSemanticsDebugger: true, // 접근성 테스트할 때 사용
              debugShowCheckedModeBanner: false,
              darkTheme: SystemTheme.systemMode(ColorTheme.dark),
              themeMode: ThemeMode.values.byName(mode ?? ThemeMode.system.name),
              theme: SystemTheme.systemMode(ColorTheme.light),
              home: StreamBuilder(
                stream: DI.get<FirebaseAuth>().authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return const SignInView();
                  } else {
                    return const MainView();
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
