class WeatherVO {
  int visibility;
  int clouds;
  int sunrise;
  int sunset;

  WeatherVO({
    required this.visibility,
    required this.clouds,
    required this.sunrise,
    required this.sunset,
  });

  @override
  String toString() {
    return '{visibility : $visibility, clouds : $clouds, sunrise : $sunrise, sunset : $sunset}';
  }
}
