import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';

abstract class AuthRepository {
  Future<Either<Failure, Void>> signInAnonymously();
  Future<Either<Failure, Void>> signOutAnonymously();
}
