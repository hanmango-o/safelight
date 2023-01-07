import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:safelight/view_model/interface/service_strategy_interface.dart';
import 'package:torch_light/torch_light.dart';

class FlashLightImpl implements IServiceStrategy {
  static final FlashLightImpl _instance = FlashLightImpl._internal();

  late Timer _timer = Timer(Duration.zero, () {});

  factory FlashLightImpl() => _instance;

  FlashLightImpl._internal() {
    reset();
  }

  void turnOn({
    bool isInfinite = false,
    int count = 10,
  }) async {
    await reset();
    _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
      print(timer.tick);
      if (!isInfinite && timer.tick == count) {
        timer.cancel();
      }
      await _enableTorch();
      await _disableTorch();
    });
  }

  Future<void> reset() async {
    _timer.cancel();
    await TorchLight.disableTorch();
  }

  Future<void> _enableTorch() async {
    try {
      await TorchLight.enableTorch();
      await Future.delayed(const Duration(seconds: 1));
    } on Exception catch (_) {
      print(_);
    }
  }

  Future<void> _disableTorch() async {
    try {
      await TorchLight.disableTorch();
    } on Exception catch (_) {
      print(_);
    }
  }

  Future<bool> isTorchAvailable() async {
    try {
      return await TorchLight.isTorchAvailable();
    } on Exception catch (_) {
      rethrow;
    }
  }
}
