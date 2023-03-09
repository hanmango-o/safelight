library safelight;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safelight/framework/controller.dart';
import 'package:safelight/framework/core.dart';
import 'package:safelight/framework/ui.dart';
import 'package:safelight/firebase_options.dart';
import 'package:safelight/injection.dart' as injection;
import 'package:safelight/injection.dart';

part '../main.dart';
part '../initializer.dart';
