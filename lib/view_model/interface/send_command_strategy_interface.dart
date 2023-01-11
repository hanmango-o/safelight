import 'dart:developer';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:safelight/asset/resource/blue_resource.dart';
import 'package:safelight/model/vo/crosswalk_vo.dart';
import 'package:safelight/view_model/controller/blue_controller.dart';

abstract class ISendCommandStrategy {
  final List<CrosswalkVO> _crosswalks;

  ISendCommandStrategy(this._crosswalks);

  Future<void> send();

  Future<void> connect(List<int> command) async {
    for (int i = 0; i < _crosswalks.length; i++) {
      if (Platform.isIOS) {
        await Future.delayed(const Duration(seconds: 1));
      }
      try {
        await _crosswalks[i].post.connect(autoConnect: false);
        List<BluetoothService> services =
            await _crosswalks[i].post.discoverServices();
        await services
            .firstWhere(
              (service) =>
                  service.uuid == Guid('0003cdd0-0000-1000-8000-00805f9b0131'),
            )
            .characteristics
            .firstWhere(
              (characteristic) =>
                  characteristic.uuid ==
                  Guid('0003cdd2-0000-1000-8000-00805f9b0131'),
            )
            .write(command, withoutResponse: true);
      } catch (e) {
        BlueController.status.value = StatusType.ERROR;
        throw Exception(e);
      } finally {
        await Future.delayed(const Duration(seconds: 2));
        await _crosswalks[i].post.disconnect();
      }
    }
  }
}
