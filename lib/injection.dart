// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import 'package:safelight/core/utils/message.dart';

import 'core/utils/tts.dart';
import 'core/utils/validators.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/crosswalk_repository_impl.dart';
import 'data/repositories/flash_repository_impl.dart';
import 'data/repositories/navigator_repository_impl.dart';
import 'data/repositories/permission_repository_impl.dart';
import 'data/sources/auth_remote_data_source.dart';
import 'data/sources/blue_native_data_source.dart';
import 'data/sources/crosswalk_remote_data_source.dart';
import 'data/sources/flash_native_data_source.dart';
import 'data/sources/navigate_remote_data_source.dart';
import 'data/sources/permission_native_data_source.dart';
import 'data/sources/weather_remote_data_source.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/crosswalk_repository.dart';
import 'domain/repositories/flash_repository.dart';
import 'domain/repositories/navigator_repository.dart';
import 'domain/repositories/permission_repository.dart';
import 'domain/usecases/auth_usecase.dart';
import 'domain/usecases/crosswalk_usecase.dart';
import 'domain/usecases/nav_usecase.dart';
import 'domain/usecases/permission_usecase.dart';
import 'domain/usecases/service_usecase.dart';
import 'presentation/bloc/auth_bloc.dart';
import 'presentation/bloc/crosswalk_bloc.dart';
import 'presentation/cubit/bluetooth_permission_cubit.dart';
import 'presentation/cubit/location_permission_cubit.dart';

final DI = GetIt.instance;

const String BLOC_BLUE_SEARCH_FINITE = 'BLOC_BLUE_SEARCH_FINITE';
const String BLOC_BLUE_SEARCH_INFINITE = 'BLOC_BLUE_SEARCH_INFINITE';
const String USECASE_SEARCH_CROSSWALK_FINITE =
    'USECASE_SEARCH_CROSSWALK_FINITE';
const String USECASE_SEARCH_CROSSWALK_INFINITE =
    'USECASE_SEARCH_CROSSWALK_INFINITE';
const String USECASE_CONTROL_FLASH_ON = 'USECASE_CONTROL_FLASH_ON';
const String USECASE_CONTROL_FLASH_OFF = 'USECASE_CONTROL_FLASH_OFF';
const String USECASE_SEND_ACOUSTIC_SIGNAL = 'USECASE_SEND_ACOUSTIC_SIGNAL';
const String USECASE_SEND_VOICE_INDUCTOR = 'USECASE_SEND_VOICE_INDUCTOR';
const String USECASE_SIGN_IN_ANONYMOUSLY = 'USECASE_SIGN_IN_ANONYMOUSLY';
const String USECASE_SIGN_OUT_ANONYMOUSLY = 'USECASE_SIGN_OUT_ANONYMOUSLY';
const String USECASE_CONTROL_FLASH_ON_WITH_WEATHER =
    'USECASE_CONTROL_FLASH_ON_WITH_WEATHER';

Future<void> init() async {
  // bloc injection area
  DI.registerLazySingleton(
    () => LocationPermissionCubit(
      getPermission: DI(),
      setPermission: DI(),
    ),
  );

  DI.registerLazySingleton(
    () => BluetoothPermissionCubit(
      getPermission: DI(),
      setPermission: DI(),
    ),
  );

  DI.registerLazySingleton(
    () => AuthBloc(
      signInAnonymously: DI(instanceName: USECASE_SIGN_IN_ANONYMOUSLY),
      signOutAnonymously: DI(instanceName: USECASE_SIGN_OUT_ANONYMOUSLY),
    ),
  );

  DI.registerFactory(
    () => CrosswalkBloc(
      search2FiniteTimes: DI(instanceName: USECASE_SEARCH_CROSSWALK_FINITE),
      search2InfiniteTimes: DI(instanceName: USECASE_SEARCH_CROSSWALK_INFINITE),
      sendAcousticSignal: DI(instanceName: USECASE_SEND_ACOUSTIC_SIGNAL),
      sendVoiceInductor: DI(instanceName: USECASE_SEND_VOICE_INDUCTOR),
      getCurrentPosition: DI(),
      controlFlashOnWithWeather:
          DI(instanceName: USECASE_CONTROL_FLASH_ON_WITH_WEATHER),
    ),
    instanceName: BLOC_BLUE_SEARCH_FINITE,
  );

  // usecase injection area

  DI.registerLazySingleton<SetPermission>(
    () => SetPermission(
      repository: DI(),
    ),
  );

  DI.registerLazySingleton<SignIn>(
    () => SignInAnonymously(repository: DI()),
    instanceName: USECASE_SIGN_IN_ANONYMOUSLY,
  );

  DI.registerLazySingleton<SignOut>(
    () => SignOutAnonymously(repository: DI()),
    instanceName: USECASE_SIGN_OUT_ANONYMOUSLY,
  );

  DI.registerLazySingleton<ConnectCrosswalk>(
    () => SendAcousticSignal(repository: DI()),
    instanceName: USECASE_SEND_ACOUSTIC_SIGNAL,
  );
  DI.registerLazySingleton<ConnectCrosswalk>(
    () => SendVoiceInductor(repository: DI()),
    instanceName: USECASE_SEND_VOICE_INDUCTOR,
  );
  DI.registerLazySingleton<ControlFlash>(
    () => ControlFlashOn(repository: DI()),
    instanceName: USECASE_CONTROL_FLASH_ON,
  );
  DI.registerLazySingleton<ControlFlash>(
    () => ControlFlashOff(repository: DI()),
    instanceName: USECASE_CONTROL_FLASH_OFF,
  );
  DI.registerLazySingleton<ControlFlash>(
    () => ControlFlashOnWithWeather(repository: DI()),
    instanceName: USECASE_CONTROL_FLASH_ON_WITH_WEATHER,
  );

  DI.registerLazySingleton<SearchCrosswalk>(
    () => Search2FiniteTimes(repository: DI()),
    instanceName: USECASE_SEARCH_CROSSWALK_FINITE,
  );
  DI.registerLazySingleton<SearchCrosswalk>(
    () => Search2InfiniteTimes(repository: DI()),
    instanceName: USECASE_SEARCH_CROSSWALK_INFINITE,
  );
  DI.registerLazySingleton<GetPermission>(
    () => GetPermission(repository: DI()),
  );
  DI.registerLazySingleton<GetCurrentPosition>(
    () => GetCurrentPosition(repository: DI()),
  );

  // repository injection area
  DI.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authDataSource: DI()),
  );
  DI.registerLazySingleton<FlashRepository>(
    () => FlashRepositoryImpl(
      flashDataSource: DI(),
      navDataSource: DI(),
      validator: DI(),
      weatherDataSource: DI(),
    ),
  );
  DI.registerLazySingleton<PermissionRepository>(
    () => PermissionRepositoryImpl(permissionDataSource: DI()),
  );

  DI.registerLazySingleton<CrosswalkRepository>(
    () => CrosswalkRepositoryImpl(
      blueDataSource: DI(),
      navDataSource: DI(),
      crosswalkDataSource: DI(),
    ),
  );
  DI.registerLazySingleton<NavigatorRepository>(
    () => NavigatorRepositoryImpl(navDataSource: DI()),
  );

  // datasource injection area
  DI.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(auth: DI()),
  );
  DI.registerLazySingleton<FlashNativeDataSource>(
    () => FlashNativeDataSourceImpl(),
  );
  DI.registerLazySingleton<BlueNativeDataSource>(
    () => BlueNativeDataSourceImpl(bluetooth: DI()),
  );
  DI.registerLazySingleton<PermissionNativeDataSource>(
    () => PermissionNativeDataSourceImpl(),
  );

  DI.registerLazySingleton<NavigateRemoteDataSource>(
    () => NavigateRemoteDataSourceImpl(geolocator: DI()),
  );
  DI.registerLazySingleton<CrosswalkRemoteDataSource>(
    () => CrosswalkRemoteDataSourceImpl(firestore: DI(), distance: DI()),
  );
  DI.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(),
  );

  // core injection area
  final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
  DI.registerLazySingleton(() => geolocator);

  const Distance distance = Distance();
  DI.registerLazySingleton(() => distance);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DI.registerLazySingleton(() => firestore);

  final FirebaseAuth auth = FirebaseAuth.instance;
  DI.registerLazySingleton(() => auth);

  final FlutterBluePlus bluetooth = FlutterBluePlus.instance;
  DI.registerLazySingleton(() => bluetooth);

  final FlutterTts tts = FlutterTts();
  DI.registerLazySingleton(() => tts);

  DI.registerLazySingleton<WeatherValidator>(() => WeatherValidator());

  DI.registerLazySingleton<TTS>(() => TTS(tts: DI()));

  DI.registerLazySingleton<Message>(() => Message());
}
