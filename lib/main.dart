import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:safelight/core/utils/themes.dart';
import 'package:safelight/injection.dart';
import 'package:safelight/presentation/bloc/auth_bloc.dart';
import 'package:safelight/presentation/bloc/crosswalk_bloc.dart';
import 'package:safelight/presentation/cubit/bluetooth_permission_cubit.dart';
import 'package:safelight/presentation/cubit/location_permission_cubit.dart';
import 'package:safelight/presentation/views/main_view.dart';
import 'package:safelight/presentation/views/sign_in_view.dart';
import 'package:safelight/initializer.dart' as initializer;
// v1.2.0 | 한영찬(hanmango-o) | hanmango.o@gmail.com

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
