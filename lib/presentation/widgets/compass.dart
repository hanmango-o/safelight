import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:safelight/core/utils/assets.dart';
import 'package:safelight/core/utils/themes.dart';

class Compass extends StatefulWidget {
  final LatLng? latLng;
  final LatLng pos;
  final Widget end;

  const Compass({
    super.key,
    required this.latLng,
    required this.pos,
    required this.end,
  });

  @override
  State<Compass> createState() => _CompassFrameState();
}

class _CompassFrameState extends State<Compass> {
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
            label: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100.w),
              child: const FittedBox(
                child: Text(
                  '안전 나침반',
                  semanticsLabel: '안전 나침반 기능 켜짐, 진동이 울리지 않는 방향으로 보행하세요.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
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
          return const Text('안전 나침판 기능을 사용할 수 없습니다.');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        double? direction = snapshot.data!.heading;

        if (direction == null) {
          return const Center(
            child: Text("감지 센서가 없습니다."),
          );
        }

        double bearing = geolocator.bearingBetween(
          widget.latLng!.latitude,
          widget.latLng!.longitude,
          widget.pos.latitude,
          widget.pos.longitude,
        );

        if ((direction - bearing).abs() > 17) {
          HapticFeedback.vibrate();
        }

        return Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: Container(
            width: 220.w,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Transform.rotate(
              angle: ((direction - bearing) * (math.pi / 180) * -1),
              child: Image.asset(
                Images.CompassArrow,
                semanticLabel: '나침반',
              ),
            ),
          ),
        );
      },
    );
  }
}
