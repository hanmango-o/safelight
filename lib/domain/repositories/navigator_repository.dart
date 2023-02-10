import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';

import '../../core/errors/failures.dart';

/// [NavigatorRepository]는 네비게이션(위치 기반 기능)과 관련된 Repository이다.
///
/// `NavUseCase`의 비즈니스 로직들의 요청을 처리하고 요청에 따른 결과를 반환한다.
///
/// [NavigatorRepository]는 Repository의 interface로서 캡슐화의 역할을 수행한다.
/// 이에 따라 [NavigatorRepository]는 `lib/data/repositories/naviagtor_repository_impl.dart`의
/// `NavigatorRepositoryImpl` 클래스를 통해 구현된다.
///
/// 이후, 객체 생성 시 [NavigatorRepository] 타입으로 객체를 생성하여 Domain Layer 와 Data Layer를 연결한다.
///
/// ---
/// ## Functions
/// [NavigatorRepository]는 요청에 따라 아래의 메소드를 호출하여 기능을 수행할 수 있다.
///
/// |기능||설명|
/// |:-------|-|:--------|
/// |[getCurrentPosition]||사용자의 위치 확인|
abstract class NavigatorRepository {
  /// [getCurrentPosition]는 사용자 위치 확인을 수행한다.
  ///
  /// 사용자 위치 확인을 위해서는 위치 기능에 대한 권한(Permission) 허가가 필요하다.
  ///
  /// * Permission과 관련된 내용은 `lib/domain/usecases/permission_usecase.dart' 에서 확인할 수 있다.
  ///
  /// [Either]로서 ([Failure], [LatLng])의 형태로 반환되며, 아래와 같이 결과가 반환된다.
  ///
  /// |return||case|
  /// |:-------|-|:--------|
  /// |`Right(LatLng(latitude, longitude))`||사용자 위치 확인 성공, 사용자의 위치(위도, 경도)를 `LatLng`을 통해 반환|
  /// |`Left(FlashFailure())`||사용자 위치 확인 실패|
  Future<Either<Failure, LatLng>> getCurrentPosition();
}
