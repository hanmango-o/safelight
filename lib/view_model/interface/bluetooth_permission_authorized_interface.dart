import 'package:safelight/view_model/interface/permission_authorized_interface.dart';

abstract class IBluetoothPermissionAuthorized extends IPermissionAuthorized {
  Stream<bool> checkBluePermission();
  Future blueAuthorized();
}
