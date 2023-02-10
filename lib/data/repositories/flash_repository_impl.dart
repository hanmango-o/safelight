import 'package:dartz/dartz.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../../core/utils/validators.dart';
import '../../domain/repositories/flash_repository.dart';
import '../sources/flash_native_data_source.dart';
import '../sources/navigate_remote_data_source.dart';
import '../sources/weather_remote_data_source.dart';

/// [FlashRepositoryImpl]는 [FlashRepository]의 구현부이다.
///
/// `sources` 폴더의 [FlashNativeDataSource]를 사용하여 안전 경광등 켜기/끄기를 수행한다.
/// 또한, [WeatherRemoteDataSource]를 사용하여 현재 날씨 정보를 요청한다.
/// 해당 과정에서 현재 사용자의 위치를 사용하므로 [NavigateRemoteDataSource]를 이용하여 현재 사용자 위치를 확인한다.
/// 요청된 날씨 정보를 기반으로 [WeatherValidator]를 사용하여 안전 경광등을 켜야 하는 날씨인지를 판단한다.
///
/// ---
/// ## Members
/// [FlashRepositoryImpl]의 member는 아래와 같다.
///
/// ### field
/// * [flashDataSource]
/// * [weatherDataSource]
/// * [navDataSource]
/// * [validator]
///
/// ### method
/// * [turnOn]
///   * [FlashNativeDataSource.on]를 호출하여 안전 경광등 켜기를 수행한다.
///
/// * [turnOnWithWeather]
///   * [NavigateRemoteDataSource.getCurrentLatLng]을 호출하여 현재 사용자의 위치 정보 요청을 수행한다.
///   * [WeatherRemoteDataSource.getCurrentWeather]을 호출하여 현재 날씨 정보 요청을 수행한다.
///   * [WeatherValidator.checkFlashEnabled]을 호출하여 안전 경광등을 켜야하는 날씨인지를 판단한다.
///
/// * [turnOff]
///   * [FlashNativeDataSource.off]를 호출하여 안전 경광등 끄기를 수행한다.
///
/// ---
/// ## Example
/// [FlashRepositoryImpl]는 아래와 같이 [FlashRepository] 타입으로 객체를 생성해야 한다.
///
/// ```dart
/// FlashRepository repository = FlashRepositoryImpl(datasource1, datasource2, datasource3, validator);
/// ```
///
/// 또한 외부에서 의존성을 주입하여 객체를 생성하는 것을 권장한다.
///
/// ```dart
/// // 외부 의존성 주입이 완료된 경우
/// FlashRepository repository = DI.get<FlashRepository>();
/// ```
///
/// 객체의 생성이 끝난 경우 아래와 같이 메소드를 호출한다.
///
/// ```dart
/// repository.turnOn(); // 안전 경광등 켜기
/// repository.turnOnWithWeather(); // 날씨에 따른 안전 경광등 켜기
/// repository.turnOff(); // 안전 경광등 끄기
/// ```
///
/// 아래는 위 과정에 대한 전문이다.
///
/// ```dart
/// FlashRepository repository = FlashRepositoryImpl(datasource1, datasource2, datasource3, validator); // 권장
/// // 외부 의존성 주입이 완료된 경우
/// FlashRepository repository = DI.get<FlashRepository>(); // Best Practice
///
/// repository.turnOn(); // 안전 경광등 켜기
/// repository.turnOnWithWeather(); // 날씨에 따른 안전 경광등 켜기
/// repository.turnOff(); // 안전 경광등 끄기
/// ```
class FlashRepositoryImpl implements FlashRepository {
  /// [FlashNativeDataSource] 객체를 담는 변수로서 외부에서 DI되어 사용된다.
  ///
  /// 변수형을 선언([FlashNativeDataSource])하고 실제 DI하는 값은 [FlashNativeDataSourceImpl] 객체로 주입한다.
  ///
  /// See also:
  ///  * DI에 대한 자세한 설명은 `injection.dart` 파일에서 확인할 수 있다.
  FlashNativeDataSource flashDataSource;

  /// [WeatherRemoteDataSource] 객체를 담는 변수로서 외부에서 DI되어 사용된다.
  ///
  /// 변수형을 선언([WeatherRemoteDataSource])하고 실제 DI하는 값은 [WeatherRemoteDataSourceImpl] 객체로 주입한다.
  ///
  /// See also:
  ///  * DI에 대한 자세한 설명은 `injection.dart` 파일에서 확인할 수 있다.
  WeatherRemoteDataSource weatherDataSource;

  /// [NavigateRemoteDataSource] 객체를 담는 변수로서 외부에서 DI되어 사용된다.
  ///
  /// 변수형을 선언([NavigateRemoteDataSource])하고 실제 DI하는 값은 [NavigateRemoteDataSourceImpl] 객체로 주입한다.
  ///
  /// See also:
  ///  * DI에 대한 자세한 설명은 `injection.dart` 파일에서 확인할 수 있다.
  NavigateRemoteDataSource navDataSource;

  /// [WeatherValidator] 객체를 담는 변수로서 외부에서 DI되어 사용된다.
  WeatherValidator validator;

  /// Default constructor로서 의존성 주입을 위해 [flashDataSource], [navDataSource], [weatherDataSource], [validator]를 Argument로 반드시 받아야 한다.
  ///
  /// 아래와 같이 사용할 수 있다.
  ///
  /// ```dart
  /// FlashRepository repository = FlashRepositoryImpl(datasource1, datasource2, datasource3, validator); // 권장
  /// // 외부 의존성 주입이 완료된 경우
  /// FlashRepository repository = DI.get<FlashRepository>(); // Best Practice
  /// ```
  FlashRepositoryImpl({
    required this.flashDataSource,
    required this.navDataSource,
    required this.weatherDataSource,
    required this.validator,
  });

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

  @override
  Future<Either<Failure, Void>> turnOff() async {
    try {
      await flashDataSource.off();
      return Right(Void());
    } on FlashException {
      return Left(FlashFailure());
    }
  }
}
