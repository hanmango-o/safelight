import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:safelight/core/errors/exceptions.dart';
import 'package:safelight/domain/entities/crosswalk.dart';

abstract class BlueNativeDataSource {
  Future<List<ScanResult>> scan();
  Future<void> connect(Crosswalk crosswalk);
  Future<void> send(Crosswalk crosswalk, List<int> command);
}

class BlueNativeDataSourceImpl implements BlueNativeDataSource {
  static const Duration duration = Duration(seconds: 1);
  final FlutterBluePlus bluetooth;

  BlueNativeDataSourceImpl({required this.bluetooth});

  @override
  Future<List<ScanResult>> scan() async {
    List<ScanResult> results = [];
    try {
      await FlutterBluePlus.instance.startScan(
        timeout: duration,
      );
      List<ScanResult> posts = await FlutterBluePlus.instance.scanResults.first;
      Iterator<ScanResult> post = posts.iterator;

      while (post.moveNext()) {
        if (post.current.device.name.startsWith('AHG001+') &&
            post.current.rssi > -65) {
          results.add(post.current);
        }
      }
      return results;
    } catch (e) {
      throw BlueException();
    }
  }

  @override
  Future<void> connect(Crosswalk crosswalk) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      await crosswalk.post.connect(autoConnect: false);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> send(Crosswalk crosswalk, List<int> command) async {
    try {
      await connect(crosswalk);
      List<BluetoothService> services = await crosswalk.post.discoverServices();
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
      await crosswalk.post.disconnect();
    } catch (e) {
      await crosswalk.post.disconnect();
      throw BlueException();
    }
  }
}
