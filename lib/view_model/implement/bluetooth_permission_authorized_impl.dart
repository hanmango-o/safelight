import 'package:permission_handler/permission_handler.dart';
import 'package:safelight/view_model/interface/bluetooth_permission_authorized_interface.dart';

class BluetoothPermissionAuthorizedImpl
    implements IBluetoothPermissionAuthorized {
  @override
  Future blueAuthorized() async {
    await openAppSettings();
  }

  @override
  Stream<bool> checkBluePermission() async* {
    if (await Permission.bluetooth.isGranted) {
      yield true;
    } else if (await Permission.bluetoothAdvertise.isDenied &&
        await Permission.bluetoothConnect.isGranted &&
        await Permission.bluetoothScan.isGranted) {
      yield true;
    } else {
      yield false;
    }
  }
}
