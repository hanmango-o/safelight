import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safelight/view_model/controller/service_controller.dart';
import 'package:safelight/view_model/implement/service/flashlight_impl.dart';
import 'package:torch_light/torch_light.dart';

class FlashlightView extends StatefulWidget {
  const FlashlightView({super.key});

  @override
  State<FlashlightView> createState() => _FlashlightViewState();
}

class _FlashlightViewState extends State<FlashlightView> {
  late final FlashLightImpl _flashlight;
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
          if (snapshot.hasData && snapshot.data!) {
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: ElevatedButton(
                      child: const Text('경광등 test 켜기'),
                      onPressed: () {
                        _flashlight.turnOn(count: 3);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ElevatedButton(
                      child: const Text('경광등 끄기'),
                      onPressed: () {
                        _flashlight.reset();
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasData) {
            return const Center(
              child: Text('No torch available.'),
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
