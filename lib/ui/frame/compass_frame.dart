import 'dart:developer';
import 'dart:math' as math;

import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:safelight/asset/resource/image_resource.dart';
import 'package:safelight/asset/static/color_theme.dart';
import 'package:safelight/asset/static/size_theme.dart';
import 'package:safelight/ui/widget/flat_card.dart';
import 'package:safelight/view_model/controller/nav_controller.dart';

class CompassFrame extends StatefulWidget {
  LatLng? pos;
  Widget end;

  CompassFrame({super.key, required this.pos, required this.end});

  @override
  State<CompassFrame> createState() => _CompassFrameState();
}

class _CompassFrameState extends State<CompassFrame> {
  GeolocatorPlatform geolocator = GeolocatorPlatform.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.h),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Chip(
            backgroundColor: ColorTheme.highlight3,
            label: Text(
              '안전 나침반',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCompass(),
          widget.end,
        ],
      )),
    );
  }

  Widget _buildCompass() {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('안전 나침판 기능을 사용할 수 없습니다.');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        double? direction = snapshot.data!.heading;

        if (direction == null)
          return Center(
            child: Text("감지 센서가 없습니다."),
          );

        double bearing = geolocator.bearingBetween(
          NavController.location![0],
          NavController.location![1],
          widget.pos!.latitude,
          widget.pos!.longitude,
        );

        if ((direction - bearing).abs() > 10) {
          HapticFeedback.vibrate();
        }

        return Material(
          shape: CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: Container(
            width: 220.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Transform.rotate(
              angle: ((direction - bearing) * (math.pi / 180) * -1),
              child: Image.asset(ImageResource.IMG_CompassArrow),
            ),
          ),
        );
      },
    );
  }
}
