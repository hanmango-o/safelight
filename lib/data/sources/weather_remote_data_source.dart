import 'dart:convert';

import 'package:latlong2/latlong.dart';
import 'package:safelight/core/errors/exceptions.dart';
import 'package:safelight/core/utils/apis.dart';
import 'package:safelight/data/models/weather_model.dart';
import 'package:http/http.dart' as http;

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getCurrentWeather(LatLng position);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  @override
  Future<WeatherModel> getCurrentWeather(LatLng position) async {
    try {
      final url = Uri.parse(
        WeatherAPI.postionURL(position.latitude, position.longitude),
      );
      var response = await http.get(url);
      Map<String, dynamic> json =
          jsonDecode(response.body) as Map<String, dynamic>;
      return WeatherModel.fromJson(json);
    } catch (e) {
      throw ServerException();
    }
  }
}
