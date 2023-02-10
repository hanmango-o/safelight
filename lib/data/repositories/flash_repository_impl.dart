import 'package:dartz/dartz.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../../core/utils/validators.dart';
import '../../domain/repositories/flash_repository.dart';
import '../sources/flash_native_data_source.dart';
import '../sources/navigate_remote_data_source.dart';
import '../sources/weather_remote_data_source.dart';

class FlashRepositoryImpl implements FlashRepository {
  FlashNativeDataSource flashDataSource;
  NavigateRemoteDataSource navDataSource;
  WeatherRemoteDataSource weatherDataSource;
  WeatherValidator validator;

  FlashRepositoryImpl({
    required this.flashDataSource,
    required this.navDataSource,
    required this.weatherDataSource,
    required this.validator,
  });

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

  @override
  Future<Either<Failure, Void>> turnOnWithWeather() async {
    try {
      final position = await navDataSource.getCurrentLatLng();
      final weather = await weatherDataSource.getCurrentWeather(position);
      final enable = validator.checkFlashEnabled(weather);

      enable.fold(
        (failure) {
          throw ValidateFailure();
        },
        (enable) async {
          if (enable) {
            await flashDataSource.on();
          }
        },
      );
      return Right(Void());
    } on FlashException {
      return Left(FlashFailure());
    } on ValidateFailure {
      return Left(ValidateFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
