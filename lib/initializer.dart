import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safelight/firebase_options.dart';
import 'package:safelight/injection.dart' as injection;

import 'core/caches/color_mode.dart';
import 'core/caches/flash_mode.dart';
import 'core/caches/setting.dart';
import 'core/utils/apis.dart';
import 'core/utils/themes.dart';
import 'injection.dart';

Future<void> init() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await injection.init();
  await Hive.initFlutter();
  Hive.registerAdapter<Setting>(SettingAdapter());
  Hive.registerAdapter<ColorMode>(ColorModeAdapter());
  Hive.registerAdapter<FlashMode>(FlashModeAdapter());
  await Hive.openBox(SystemTheme.themeBox);

  final firestore = DI.get<FirebaseFirestore>();
  CollectionReference collectionRef = firestore.collection('safelight_db');
  QuerySnapshot querySnapshot = await collectionRef.get();
  CrosswalkAPI.map = querySnapshot.docs
      .map((doc) => doc.data() as Map<String, dynamic>)
      .toList();

  FlutterTts flutterTts = DI.get<FlutterTts>();
  await flutterTts.awaitSpeakCompletion(true);
  await flutterTts.setVolume(1.0);
  await flutterTts.setIosAudioCategory(IosTextToSpeechAudioCategory.playback,
      [IosTextToSpeechAudioCategoryOptions.defaultToSpeaker]);

  await [
    Permission.location,
    Permission.locationAlways,
    Permission.locationWhenInUse,
  ].request();

  await [
    Permission.bluetooth,
    Permission.bluetoothAdvertise,
    Permission.bluetoothConnect,
    Permission.bluetoothScan
  ].request();
}
