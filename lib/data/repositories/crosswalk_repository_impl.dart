import 'package:safelight/core/errors/exceptions.dart';
import 'package:safelight/core/usecases/usecase.dart';
import 'package:safelight/core/utils/validators.dart';
import 'package:safelight/data/sources/blue_native_data_source.dart';
import 'package:safelight/data/sources/crosswalk_remote_data_source.dart';
import 'package:safelight/data/sources/flash_native_data_source.dart';
import 'package:safelight/data/sources/navigate_remote_data_source.dart';
import 'package:safelight/data/sources/weather_remote_data_source.dart';
import 'package:safelight/domain/entities/crosswalk.dart';
import 'package:safelight/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:safelight/domain/repositories/crosswalk_repository.dart';

class CrosswalkRepositoryImpl implements CrosswalkRepository {
  BlueNativeDataSource blueDataSource;
  NavigateRemoteDataSource navDataSource;
  CrosswalkRemoteDataSource crosswalkDataSource;
  FlashNativeDataSource flashDataSource;
  WeatherRemoteDataSource weatherDataSource;
  WeatherValidator validator;

  CrosswalkRepositoryImpl({
    required this.blueDataSource,
    required this.navDataSource,
    required this.crosswalkDataSource,
    required this.flashDataSource,
    required this.weatherDataSource,
    required this.validator,
  });

  @override
  Future<Either<Failure, List<Crosswalk>>> getCrosswalkFiniteTimes() async {
    try {
      final blueResults = await blueDataSource.scan();
      final position = await navDataSource.getCurrentLatLng();
      final results = await crosswalkDataSource.getCrosswalks(
        blueResults,
        position,
      );

      return Right(results);
    } on BlueException {
      return Left(BlueFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Void>> sendCommand2Crosswalk(
    Crosswalk crosswalk,
    List<int> command,
  ) async {
    try {
      await blueDataSource.send(crosswalk, command);
      final position = await navDataSource.getCurrentLatLng();
      final weather = await weatherDataSource.getCurrentWeather(position);
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
    } on BlueException {
      return Left(BlueFailure());
    } on ValidateFailure {
      return Right(Void());
    }
  }
}
