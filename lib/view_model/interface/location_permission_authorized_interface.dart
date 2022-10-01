abstract class ILocationPermissionAuthorized {
  Stream<bool> checkLocationPermission();
  Future locationAuthorized();
}
