import 'dart:developer';
import 'dart:io' show Platform;

import 'package:permission_handler/permission_handler.dart';
import 'package:safelight/view_model/interface/bluetooth_permission_authorized_interface.dart';

class BluetoothPermissionAuthorizedImpl
    implements IBluetoothPermissionAuthorized {
  @override
  Future blueAuthorized() async {
    checkBluePermission().listen((isOn) async {
      if (isOn) {
        await openAppSettings();
      } else {
        await [
          Permission.bluetooth,
          Permission.bluetoothAdvertise,
          Permission.bluetoothConnect,
          Permission.bluetoothScan
        ].request();
      }
    });
  }

  @override
  Stream<bool> checkBluePermission() async* {
    if (Platform.isIOS) {
      if (await Permission.bluetooth.isGranted) {
        yield true;
      } else {
        yield false;
      }
    } else {
      var a = await Permission.bluetoothAdvertise.isGranted;
      var b = await Permission.bluetoothConnect.isGranted;
      var c = await Permission.bluetoothScan.isGranted;
      log(a.toString());
      log(b.toString());
      log(c.toString());
      if (await Permission.bluetoothAdvertise.isGranted &&
          await Permission.bluetoothConnect.isGranted &&
          await Permission.bluetoothScan.isGranted) {
        yield true;
      } else {
        yield false;
      }
    }
  }
}
