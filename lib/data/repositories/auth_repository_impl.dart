import 'package:safelight/core/errors/exceptions.dart';
import 'package:safelight/core/usecases/usecase.dart';
import 'package:safelight/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:safelight/data/sources/auth_remote_data_source.dart';
import 'package:safelight/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRemoteDataSource authDataSource;

  AuthRepositoryImpl({required this.authDataSource});

  @override
  Future<Either<Failure, Void>> signInAnonymously() async {
    try {
      await authDataSource.signInAnonymously();
      return Right(Void());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Void>> signOutAnonymously() async {
    try {
      await authDataSource.signOutAnonymously();
      return Right(Void());
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
