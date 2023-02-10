import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';

/// [PermissionRepository]는 디바이스 권한 확인/요청과 관련된 Repository이다.
///
/// `PermissionUseCase`의 비즈니스 로직들의 요청을 처리하고 요청에 따른 결과를 반환한다.
///
/// [PermissionRepository]는 Repository의 interface로서 캡슐화의 역할을 수행한다.
/// 이에 따라 [PermissionRepository]는 `lib/data/repositories/permission_repository_impl.dart`의
/// `PermissionRepositoryImpl` 클래스를 통해 구현된다.
///
/// 이후, 객체 생성 시 [PermissionRepository] 타입으로 객체를 생성하여 Domain Layer 와 Data Layer를 연결한다.
///
/// ---
/// ## Functions
/// [PermissionRepository]는 요청에 따라 아래의 메소드를 호출하여 기능을 수행할 수 있다.
///
/// |기능||설명|
/// |:-------|-|:--------|
/// |[getBluetoothPermission]||현재 블루투스 권한 상태 확인|
/// |[getLocationPermission]||현재 사용자 위치 권한 상태 확인|
/// |[setBluetoothPermission]||블루투스 권한 요청|
/// |[setLocationPermission]||사용자 위치 권한 요청|
abstract class PermissionRepository {
  /// [getBluetoothPermission]는 블루투스 권한 상태 확인을 수행한다.
  ///
  /// 블루투스 권한 확인을 위해서는 블루투스 기능에 대한 권한(Permission) 설정이 필요하다.
  ///
  /// * Permission과 관련된 내용은 `lib/domain/usecases/permission_usecase.dart' 에서 확인할 수 있다.
  ///
  /// [Either]로서 ([Failure], [bool])의 형태로 반환되며, 아래와 같이 결과가 반환된다.
  ///
  /// |return||case|
  /// |:-------|-|:--------|
  /// |`Right(bool)`||현재 블루투스 권한 부여 상태 확인 성공(`true : 권한 부여됨`, `false : 권한 부여 안됨`)|
  /// |`Left(CacheFailure())`||현재 블루투스 권한 부여 상태 확인 실패|
  Future<Either<Failure, bool>> getBluetoothPermission();

  /// [getLocationPermission]는 사용자 위치 권한 상태 확인을 수행한다.
  ///
  /// 블루투스 권한 확인을 위해서는 사용자 위치 기능에 대한 권한(Permission) 설정이 필요하다.
  ///
  /// * Permission과 관련된 내용은 `lib/domain/usecases/permission_usecase.dart' 에서 확인할 수 있다.
  ///
  /// [Either]로서 ([Failure], [bool])의 형태로 반환되며, 아래와 같이 결과가 반환된다.
  ///
  /// |return||case|
  /// |:-------|-|:--------|
  /// |`Right(bool)`||현재 사용자 위치 권한 부여 상태 확인 성공(`true : 권한 부여됨`, `false : 권한 부여 안됨`)|
  /// |`Left(CacheFailure())`||현재 사용자 위치 권한 부여 상태 확인 실패|
  Future<Either<Failure, bool>> getLocationPermission();

  /// [setBluetoothPermission]는 블루투스 권한 요청을 수행한다.
  ///
  /// 블루투스 권한 요청을 위해서는 블루투스 기능에 대한 권한(Permission) 설정이 필요하다.
  ///
  /// * Permission과 관련된 내용은 `lib/domain/usecases/permission_usecase.dart' 에서 확인할 수 있다.
  ///
  /// [Either]로서 ([Failure], [Void])의 형태로 반환되며, 아래와 같이 결과가 반환된다.
  ///
  /// |return||case|
  /// |:-------|-|:--------|
  /// |`Right(Void())`||블루투스 권한 요청 성공(`요청 창을 띄울 수 있는 경우 > 요청 창 출력`, `요청 창을 띄울 수 없는 경우 > 설정 앱 전환`))|
  /// |`Left(CacheFailure())`||블루투스 권한 요청 실패|
  Future<Either<Failure, Void>> setBluetoothPermission();

  /// [setLocationPermission]는 사용자 위치 권한 요청을 수행한다.
  ///
  /// 사용자 위치 권한 요청을 위해서는 사용자 위치 기능에 대한 권한(Permission) 설정이 필요하다.
  ///
  /// * Permission과 관련된 내용은 `lib/domain/usecases/permission_usecase.dart' 에서 확인할 수 있다.
  ///
  /// [Either]로서 ([Failure], [Void])의 형태로 반환되며, 아래와 같이 결과가 반환된다.
  ///
  /// |return||case|
  /// |:-------|-|:--------|
  /// |`Right(Void())`||사용자 위치 권한 요청 성공(`요청 창을 띄울 수 있는 경우 > 요청 창 출력`, `요청 창을 띄울 수 없는 경우 > 설정 앱 전환`))|
  /// |`Left(CacheFailure())`||사용자 위치 권한 요청 실패|
  Future<Either<Failure, Void>> setLocationPermission();
}
