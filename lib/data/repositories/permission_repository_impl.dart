import 'package:dartz/dartz.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../../domain/repositories/permission_repository.dart';
import '../sources/permission_native_data_source.dart';

/// [PermissionRepositoryImpl]는 [PermissionRepository]의 구현부이다.
///
/// `sources` 폴더의 [PermissionNativeDataSource]를 사용하여 권한 요청/확인을 수행한다.
///
/// ---
/// ## Members
/// [PermissionRepositoryImpl]의 member는 아래와 같다.
///
/// ### field
/// * [permissionDataSource]
///
/// ### method
/// * [getBluetoothPermission]
///   * [PermissionNativeDataSource.getBluetoothPermissionStatus]를 호출하여 현재 블루투스 권한 부여 상태 확인을 수행한다.
///
/// * [getLocationPermission]
///   * [PermissionNativeDataSource.getLocationPermissionStatus]를 호출하여 현재 사용자 위치 권한 부여 상태 확인을 수행한다.
///
/// * [setBluetoothPermission]
///   * [PermissionNativeDataSource.setBluetoothPermission]를 호출하여 블루투스 권한 요청을 수행한다.
///
/// * [setLocationPermission]
///   * [PermissionNativeDataSource.setLocationPermission]를 호출하여 사용자 위치 권한 요청을 수행한다.
///
/// ---
/// ## Example
/// [PermissionRepositoryImpl]는 아래와 같이 [PermissionRepository] 타입으로 객체를 생성해야 한다.
///
/// ```dart
/// PermissionRepository repository = PermissionRepositoryImpl(datasource);
/// ```
///
/// 또한 외부에서 의존성을 주입하여 객체를 생성하는 것을 권장한다.
///
/// ```dart
/// // 외부 의존성 주입이 완료된 경우
/// PermissionRepository repository = DI.get<PermissionRepository>();
/// ```
///
/// 객체의 생성이 끝난 경우 아래와 같이 메소드를 호출한다.
///
/// ```dart
/// repository.getBluetoothPermissionStatus(); // 블루투스 권한 상태 확인
/// repository.getLocationPermissionStatus(); // 사용자 위치 권한 상태 확인
/// repository.setBluetoothPermission(); // 블루투스 권한 요청
/// repository.setLocationPermission(); // 사용자 위치 권한 요청
/// ```
///
/// 아래는 위 과정에 대한 전문이다.
///
/// ```dart
/// PermissionRepository repository = PermissionRepositoryImpl(datasource); // 권장
/// // 외부 의존성 주입이 완료된 경우
/// PermissionRepository repository = DI.get<PermissionRepository>(); // Best Practice
///
/// repository.getBluetoothPermissionStatus(); // 블루투스 권한 상태 확인
/// repository.getLocationPermissionStatus(); // 사용자 위치 권한 상태 확인
/// repository.setBluetoothPermission(); // 블루투스 권한 요청
/// repository.setLocationPermission(); // 사용자 위치 권한 요청
/// ```
class PermissionRepositoryImpl implements PermissionRepository {
  /// [PermissionNativeDataSource] 객체를 담는 변수로서 외부에서 DI되어 사용된다.
  ///
  /// 변수형을 선언([PermissionNativeDataSource])하고 실제 DI하는 값은 [PermissionNativeDataSourceImpl] 객체로 주입한다.
  ///
  /// See also:
  ///  * DI에 대한 자세한 설명은 `injection.dart` 파일에서 확인할 수 있다.
  PermissionNativeDataSource permissionDataSource;

  /// Default constructor로서 의존성 주입을 위해 [permissionDataSource]를 Argument로 반드시 받아야 한다.
  ///
  /// 아래와 같이 사용할 수 있다.
  ///
  /// ```dart
  /// PermissionRepository repository = PermissionRepositoryImpl(datasource); // 권장
  /// // 외부 의존성 주입이 완료된 경우
  /// PermissionRepository repository = DI.get<PermissionRepository>(); // Best Practice
  /// ```
  PermissionRepositoryImpl({required this.permissionDataSource});

  @override
  Future<Either<Failure, bool>> getBluetoothPermission() async {
    try {
      final status = await permissionDataSource.getBluetoothPermissionStatus();
      return Right(status);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> getLocationPermission() async {
    try {
      final status = await permissionDataSource.getLocationPermissionStatus();
      return Right(status);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Void>> setBluetoothPermission() async {
    try {
      await permissionDataSource.setBluetoothPermission();
      return Right(Void());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Void>> setLocationPermission() async {
    try {
      await permissionDataSource.setLocationPermission();
      return Right(Void());
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
