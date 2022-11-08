import 'dart:async';
import 'dart:developer';

import 'package:geolocator/geolocator.dart';

import '../../interface/fetch_strategy_interface.dart';

// 사용자의 현재 위도, 경도
class GetLocationImpl implements IFetchStrategy {
  @override
  Future fetch() async {
    try {
      return await getLocation();
    } catch (e) {
      throw (Exception(e));
    }
  }

  Future<List<double>> getLocation() async {
    double lat = -1;
    double lon = -1;
    bool hasPermission = false;
    GeolocatorPlatform geolocator = GeolocatorPlatform.instance;

    final servicestatus = await geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      // print(servicestatus);
      final permission = await geolocator.checkPermission();
      // print(permission);
      if (permission == LocationPermission.denied) {
        final permission = await geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          hasPermission = true;
        }
      } else {
        hasPermission = true;
      }

      if (hasPermission) {
        final position = await geolocator.getCurrentPosition();

        lon = position.longitude;
        lat = position.latitude;

        // LocationSettings locationSettings = const LocationSettings(
        //   accuracy: LocationAccuracy.high,
        //   distanceFilter: 100,
        // );

        // Geolocator.getPositionStream(locationSettings: locationSettings)
        //     .listen((Position position) {
        //   lon = position.longitude;
        //   lat = position.latitude;
        // });
      }
    }
    // log([lat, lon].toString());

    return [lat, lon];
    // LocationSettings locationSettings = LocationSettings(
    //   accuracy: LocationAccuracy.high,
    //   distanceFilter: 100,
    // );
  }
}
