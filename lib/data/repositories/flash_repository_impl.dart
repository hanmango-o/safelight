import 'package:safelight/core/errors/exceptions.dart';
import 'package:safelight/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:safelight/core/usecases/usecase.dart';
import 'package:safelight/data/sources/flash_native_data_source.dart';
import 'package:safelight/domain/repositories/flash_repository.dart';

class FlashRepositoryImpl implements FlashRepository {
  FlashNativeDataSource flashDataSource;

  FlashRepositoryImpl({required this.flashDataSource});

  @override
  Future<Either<Failure, Void>> turnOff() async {
    try {
      await flashDataSource.off();
      return Right(Void());
    } on FlashException {
      return Left(FlashFailure());
    }
  }

  @override
  Future<Either<Failure, Void>> turnOn() async {
    try {
      await flashDataSource.on(infinite: true);
      return Right(Void());
    } on FlashException {
      return Left(FlashFailure());
    }
  }
}
