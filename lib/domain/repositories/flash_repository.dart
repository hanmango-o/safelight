import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';

abstract class FlashRepository {
  Future<Either<Failure, Void>> turnOn();
  Future<Either<Failure, Void>> turnOnWithWeather();
  Future<Either<Failure, Void>> turnOff();
}
