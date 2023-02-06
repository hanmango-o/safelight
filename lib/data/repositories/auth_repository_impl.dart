import 'package:dartz/dartz.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import '../sources/auth_remote_data_source.dart';

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
