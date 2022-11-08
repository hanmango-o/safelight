import 'package:permission_handler/permission_handler.dart';
import 'package:safelight/view_model/interface/location_permission_authorized_interface.dart';

class LocationPermissionAuthorizedImpl
    implements ILocationPermissionAuthorized {
  @override
  Stream<bool> checkLocationPermission() async* {
    var status = await Permission.location.status;

    switch (status) {
      case PermissionStatus.granted:
        yield true;
        break;
      case PermissionStatus.limited:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.denied:
        yield false;
        break;
    }
  }

  @override
  Future locationAuthorized() async {
    var status = await Permission.location.status;

    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.permanentlyDenied:
        await openAppSettings();
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
        await Permission.location.request();
        break;
    }
  }
}
