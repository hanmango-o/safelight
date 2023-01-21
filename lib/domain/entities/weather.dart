import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final int visibility;
  final int clouds;
  final int sunrise;
  final int sunset;

  const Weather({
    required this.visibility,
    required this.clouds,
    required this.sunrise,
    required this.sunset,
  });

  @override
  List<Object?> get props => [];

  @override
  String toString() {
    return '{visibility : $visibility, clouds : $clouds, sunrise : $sunrise, sunset : $sunset}';
  }
}
