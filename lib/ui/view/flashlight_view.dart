import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:safelight/asset/static/color_theme.dart';
import 'package:safelight/asset/static/size_theme.dart';
import 'package:safelight/view_model/controller/blue_controller.dart';
import 'package:safelight/view_model/controller/service_controller.dart';
import 'package:safelight/view_model/implement/bluetooth/default_search_impl.dart';
import 'package:safelight/view_model/implement/service/flashlight_impl.dart';
import 'package:torch_light/torch_light.dart';

class FlashlightView extends StatefulWidget {
  const FlashlightView({super.key});

  @override
  State<FlashlightView> createState() => _FlashlightViewState();
}

class _FlashlightViewState extends State<FlashlightView> {
  late final FlashLightImpl _flashlight;
  final BlueController _blueController = Get.find<BlueController>();
  final ServiceController _serviceController = Get.find<ServiceController>();

  @override
  void initState() {
    super.initState();
    _serviceController.strategy = FlashLightImpl();
    _flashlight = _serviceController.strategy as FlashLightImpl;
  }

  @override
  void dispose() {
    super.dispose();
    _flashlight.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('안전 경광등'),
        centerTitle: true,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
      ),
      body: FutureBuilder<bool>(
        future: _flashlight.isTorchAvailable(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _flashlight.turnOn(isInfinite: true);
                    },
                    child: Text('안전 경광등 켜기'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      backgroundColor: ColorTheme.highlight3,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _flashlight.reset();
                    },
                    child: Text('안전 경광등 끄기'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      backgroundColor: ColorTheme.highlight1,
                    ),
                  ),
                ),
              ),
            ],
          );
          if (snapshot.hasData && snapshot.data!) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _flashlight.turnOn(isInfinite: true);
                      },
                      child: Text('안전 경광등 켜기'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        backgroundColor: ColorTheme.highlight3,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _flashlight.reset();
                      },
                      child: Text('안전 경광등 끄기'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        backgroundColor: ColorTheme.highlight1,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasData) {
            return const Center(
              child: Text('안전 경광등 기능을 사용할 수 없습니다.'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
