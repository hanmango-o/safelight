import 'package:get/get.dart';
import 'package:safelight/model/vo/weather_vo.dart';
import 'package:safelight/view_model/implement/service/weather_impl.dart';
import 'package:safelight/view_model/interface/service_strategy_interface.dart';

class ServiceController extends GetxController {
  static WeatherVO? weather;
  IServiceStrategy? _strategy;

  IServiceStrategy get strategy => _strategy!;

  set strategy(IServiceStrategy service) {
    _strategy = service;
  }

  Future<void> getWeather() async {
    weather = await WeatherImpl.getWeather();
  }
}
