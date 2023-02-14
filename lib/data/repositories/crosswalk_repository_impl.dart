import 'package:dartz/dartz.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../../domain/entities/crosswalk.dart';
import '../../domain/repositories/crosswalk_repository.dart';
import '../sources/blue_native_data_source.dart';
import '../sources/crosswalk_remote_data_source.dart';
import '../sources/navigate_remote_data_source.dart';

/// [CrosswalkRepositoryImpl]는 [CrosswalkRepository]의 구현부이다.
///
/// `sources` 폴더의 [BlueNativeDataSource]를 사용하여 스마트 압버튼(비콘 포스트) 스캔/연결(데이터 송신)을 수행한다.
/// 또한, [CrosswalkRemoteDataSource]를 사용하여 DB(Firestore)에 접근하여 스캔된 스마트 압버튼의 정보(횡단보도 정보)를 요청한다.
/// 해당 과정에서 현재 사용자의 위치를 사용하므로 [NavigateRemoteDataSource]를 이용하여 현재 사용자 위치를 확인한다.
///
/// ---
/// ## Members
/// [CrosswalkRepositoryImpl]의 member는 아래와 같다.
///
/// ### field
/// * [blueDataSource]
/// * [navDataSource]
/// * [crosswalkDataSource]
///
/// ### method
/// * [getCrosswalkFiniteTimes]
///   * [BlueNativeDataSource.scan]를 호출하여 주변 스마트 압버튼(비콘 포스트) 스캔을 수행한다.
///   * [NavigateRemoteDataSource.getCurrentLatLng]을 호출하여 현재 사용자의 위치를 확인을 수행한다.
///   * [CrosswalkRemoteDataSource.getCrosswalks]을 호출하여 DB에 횡단보도 정보를 요청을 수행한다.
///
/// * [getCrosswalkInfiniteTimes]
///   * [BlueNativeDataSource.scan]과 [BlueNativeDataSource.send]를 호출하여 주변 스마트 압버튼(비콘 포스트) 스캔-연결(데이터 송신)을 수행한다.(이하 자동 스캔)
///
/// * [sendCommand2Crosswalk]
///   * [BlueNativeDataSource.send]를 호출하여 선택된 횡단보도에 연결(데이터 송신)을 수행한다.
///
/// ---
/// ## Example
/// [CrosswalkRepositoryImpl]는 아래와 같이 [CrosswalkRepository] 타입으로 객체를 생성해야 한다.
///
/// ```dart
/// CrosswalkRepository repository = CrosswalkRepositoryImpl(datasource);
/// ```
///
/// 또한 외부에서 의존성을 주입하여 객체를 생성하는 것을 권장한다.
///
/// ```dart
/// // 외부 의존성 주입이 완료된 경우
/// CrosswalkRepository repository = DI.get<CrosswalkRepository>();
/// ```
///
/// 객체의 생성이 끝난 경우 아래와 같이 메소드를 호출한다.
///
/// ```dart
/// repository.getCrosswalkFiniteTimes(); // 횡단보도 찾기
/// repository.getCrosswalkInfiniteTimes(); // 횡단보도 찾기-연결(데이터 송신), 이하 자동 스캔
/// repository.sendCommand2Crosswalk(crosswalk, command); // 횡단보도 연결(데이터 송신)
/// ```
///
/// 아래는 위 과정에 대한 전문이다.
///
/// ```dart
/// CrosswalkRepository repository = CrosswalkRepositoryImpl(datasource1, datasource2, datasource3); // 권장
/// // 외부 의존성 주입이 완료된 경우
/// CrosswalkRepository repository = DI.get<CrosswalkRepository>(); // Best Practice
///
/// repository.getCrosswalkFiniteTimes(); // 횡단보도 찾기
/// repository.getCrosswalkInfiniteTimes(); // 횡단보도 찾기-연결(데이터 송신), 이하 자동 스캔
/// repository.sendCommand2Crosswalk(crosswalk, command); // 횡단보도 연결(데이터 송신)
/// ```
class CrosswalkRepositoryImpl implements CrosswalkRepository {
  /// [BlueNativeDataSource] 객체를 담는 변수로서 외부에서 DI되어 사용된다.
  ///
  /// 변수형을 선언([BlueNativeDataSource])하고 실제 DI하는 값은 [BlueNativeDataSourceImpl] 객체로 주입한다.
  ///
  /// See also:
  ///  * DI에 대한 자세한 설명은 `injection.dart` 파일에서 확인할 수 있다.
  BlueNativeDataSource blueDataSource;

  /// [NavigateRemoteDataSource] 객체를 담는 변수로서 외부에서 DI되어 사용된다.
  ///
  /// 변수형을 선언([NavigateRemoteDataSource])하고 실제 DI하는 값은 [NavigateRemoteDataSourceImpl] 객체로 주입한다.
  ///
  /// See also:
  ///  * DI에 대한 자세한 설명은 `injection.dart` 파일에서 확인할 수 있다.
  NavigateRemoteDataSource navDataSource;

  /// [CrosswalkRemoteDataSource] 객체를 담는 변수로서 외부에서 DI되어 사용된다.
  ///
  /// 변수형을 선언([CrosswalkRemoteDataSource])하고 실제 DI하는 값은 [CrosswalkRemoteDataSourceImpl] 객체로 주입한다.
  ///
  /// See also:
  ///  * DI에 대한 자세한 설명은 `injection.dart` 파일에서 확인할 수 있다.
  CrosswalkRemoteDataSource crosswalkDataSource;

  /// Default constructor로서 의존성 주입을 위해 [blueDataSource], [navDataSource], [crosswalkDataSource]를 Argument로 반드시 받아야 한다.
  ///
  /// 아래와 같이 사용할 수 있다.
  ///
  /// ```dart
  /// CrosswalkRepository repository = CrosswalkRepositoryImpl(datasource1, datasource2, datasource3); // 권장
  /// // 외부 의존성 주입이 완료된 경우
  /// CrosswalkRepository repository = DI.get<CrosswalkRepository>(); // Best Practice
  /// ```
  CrosswalkRepositoryImpl({
    required this.blueDataSource,
    required this.navDataSource,
    required this.crosswalkDataSource,
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
  Future<Either<Failure, List<Crosswalk>?>> getCrosswalkInfiniteTimes() async {
    try {
      final blueResults = await blueDataSource.scan();
      for (DiscoveredDevice result in blueResults) {
        await blueDataSource.send(result);
      }
    } on BlueException {
      return Left(BlueFailure());
    }
    return const Right(null);
  }

  @override
  Future<Either<Failure, Void>> sendCommand2Crosswalk(
    Crosswalk crosswalk,
    List<int> command,
  ) async {
    try {
      await blueDataSource.send(crosswalk.post, command: command);
      return Right(Void());
    } on BlueException {
      return Left(BlueFailure());
    }
  }
}
