import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/crosswalk.dart';

abstract class CrosswalkRepository {
  Future<Either<Failure, List<Crosswalk>>> getCrosswalkFiniteTimes();
  Future<Either<Failure, List<Crosswalk>?>> getCrosswalkInfiniteTimes();
  Future<Either<Failure, Void>> sendCommand2Crosswalk(
    Crosswalk crosswalk,
    List<int> command,
  );
}
