import 'package:dartz/dartz.dart';
import 'package:safelight/core/errors/failures.dart';
import 'package:safelight/core/usecases/usecase.dart';

abstract class AuthRepository {
  Future<Either<Failure, Void>> signInAnonymously();
  Future<Either<Failure, Void>> signOutAnonymously();
}
