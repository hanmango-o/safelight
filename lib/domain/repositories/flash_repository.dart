import 'package:dartz/dartz.dart';
import 'package:safelight/core/errors/failures.dart';
import 'package:safelight/core/usecases/usecase.dart';

abstract class FlashRepository {
  Future<Either<Failure, Void>> turnOn();
  Future<Either<Failure, Void>> turnOff();
}
