import 'package:safelight/domain/entities/weather.dart';

class WeatherModel extends Weather {
  const WeatherModel({
    required super.visibility,
    required super.clouds,
    required super.sunrise,
    required super.sunset,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      visibility: json['visibility'],
      clouds: json['clouds']['all'],
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
    );
  }
}
