import 'dart:convert';
import 'dart:developer';

import 'package:safelight/asset/resource/api_resource.dart';
import 'package:safelight/model/repository/http_repository.dart';
import 'package:safelight/model/vo/weather_vo.dart';
import 'package:safelight/view_model/controller/nav_controller.dart';
import 'package:safelight/view_model/interface/service_strategy_interface.dart';

class WeatherImpl extends IServiceStrategy {
  static Future<WeatherVO?> getWeather() async {
    if (NavController.location != null) {
      var response = await HttpRepository.fetchGet(
        ApiResource.API_weather(
            NavController.location![0], NavController.location![1]),
      );
      var body = jsonDecode(response.body) as Map<String, dynamic>;
      return WeatherVO(
        visibility: body['visibility'],
        clouds: body['clouds']['all'],
        sunrise: body['sys']['sunrise'],
        sunset: body['sys']['sunset'],
      );
    }
  }
}
