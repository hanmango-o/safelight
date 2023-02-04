import 'package:dartz/dartz.dart';
import 'package:safelight/core/errors/failures.dart';
import 'package:safelight/core/usecases/usecase.dart';
import 'package:safelight/domain/entities/crosswalk.dart';

abstract class CrosswalkRepository {
  Future<Either<Failure, List<Crosswalk>>> getCrosswalkFiniteTimes();
  Future<Either<Failure, Void>> getCrosswalkInfiniteTimes();
  Future<Either<Failure, Void>> sendCommand2Crosswalk(
    Crosswalk crosswalk,
    List<int> command,
  );
}
