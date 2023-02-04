import 'package:dartz/dartz.dart';
import 'package:safelight/core/errors/failures.dart';
import 'package:safelight/domain/entities/weather.dart';

abstract class Validator {}

class WeatherValidator implements Validator {
  Either<Failure, bool> checkFlashEnabled(Weather weather) {
    try {
      int unixTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      if (!(unixTimestamp >= weather.sunrise &&
              unixTimestamp <= weather.sunset) ||
          (weather.visibility < 500)) {
        return const Right(true);
      }
      return const Right(false);
    } catch (e) {
      return Left(ValidateFailure());
    }
  }
}
