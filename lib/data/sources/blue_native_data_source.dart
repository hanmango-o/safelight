import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:safelight/core/errors/exceptions.dart';
import 'package:safelight/domain/entities/crosswalk.dart';

abstract class BlueNativeDataSource {
  Future<List<ScanResult>> scan();
  Future<void> connect(BluetoothDevice post);
  Future<void> send(
    BluetoothDevice post, {
    List<int> command = const [0x31, 0x00, 0x02],
  });
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
            post.current.rssi > -85) {
          results.add(post.current);
        }
      }

      results.sort((a, b) => b.rssi.compareTo(a.rssi));

      return results;
    } catch (e) {
      throw BlueException();
    }
  }

  @override
  Future<void> connect(BluetoothDevice post) async {
    try {
      await post.connect(autoConnect: false);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> send(
    BluetoothDevice post, {
    List<int> command = const [0x31, 0x00, 0x02],
  }) async {
    try {
      await connect(post);
      List<BluetoothService> services = await post.discoverServices();
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
      await post.disconnect();
    } catch (e) {
      await post.disconnect();
      throw BlueException();
    }
  }
}
