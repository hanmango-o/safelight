library ui;

import 'dart:math' as math;
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:safelight/framework/core.dart';
import 'package:safelight/framework/object.dart';
import 'package:safelight/framework/usecase.dart';
import 'package:safelight/framework/controller.dart';
import 'package:safelight/injection.dart';
import 'package:shimmer/shimmer.dart';

part '../presentation/views/blue_off_view.dart';
part '../presentation/views/dutorial_view.dart';
part '../presentation/views/flashlight_view.dart';
part '../presentation/views/home_view.dart';
part '../presentation/views/main_view.dart';
part '../presentation/views/setting_view.dart';
part '../presentation/views/sign_in_view.dart';

part '../presentation/widgets/board.dart';
part '../presentation/widgets/compass.dart';
part '../presentation/widgets/flat_card.dart';
part '../presentation/widgets/single_child_rounded_card.dart';
