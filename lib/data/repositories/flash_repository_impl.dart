import 'package:safelight/core/errors/exceptions.dart';
import 'package:safelight/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:safelight/core/usecases/usecase.dart';
import 'package:safelight/core/utils/validators.dart';
import 'package:safelight/data/sources/flash_native_data_source.dart';
import 'package:safelight/data/sources/navigate_remote_data_source.dart';
import 'package:safelight/data/sources/weather_remote_data_source.dart';
import 'package:safelight/domain/repositories/flash_repository.dart';

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
      await flashDataSource.on();
      final enable = validator.checkFlashEnabled(weather);
      enable.fold(
        (failure) {
          throw ValidateFailure();
        },
        (enable) {
          if (enable) {
            flashDataSource.on();
          }
        },
      );
      return Right(Void());
    } on FlashException {
      return Left(FlashFailure());
    } on ValidateFailure {
      return Left(ValidateFailure());
    }
  }
}
