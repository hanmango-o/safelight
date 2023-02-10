import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../repositories/navigator_repository.dart';

/// [NavUseCase]는 네비게이션(위치)과 완련된 모든 [UseCase] 로직들의 super class이다.
///
/// 일반적인 네비게이션 뿐만 아니라 앱 내 위치와 관련된 기능은 [NavUseCase]에 정의되어야 한다.
/// 즉, 현재 사용자 위치 확인 또는 그 외의 모든 네비게이션과 관련된 비즈니스 로직은 [NavUseCase]의 자식 형태로 구현되어야 하며
/// [NavUseCase]는 모든 위치 기반 서비스의 super class로서 위치해야 한다.
///
/// ---
/// ## Service
/// [NavUseCase]는 아래의 Nav 서비스를 가지고 있다.
///
/// * *사용자 위치 확인 외에 다른 Nav 서비스가 필요한 경우 [NavUseCase]를 상속받는 구조로 추가할 수 있다.*
///
/// |service||설명|
/// |:-------|-|:--------|
/// |[GetCurrentPosition]||사용자 위치 확인 비즈니스 로직|
///
/// ---
/// ## 주의할 점
/// [NavUseCase]는 실질적인 비즈니스 로직으로서 사용되지 않는다.
///
/// 사용자 위치 확인과 같은 실질적인(details) 비즈니스 로직들의 최상단 클래스로서
/// 이러한 비즈니스 로직들이 네비게이션(위치 기반 서비스)과 관련되어 있다는 것을 알려주는 역할만을 수행한다.
///
/// 이후 구현이 필요한 비즈니스 로직이 위치 기반 서비스와 관련되어 있다면, [NavUseCase]의 sub class로 배치되어야 한다.
abstract class NavUseCase {}

/// [GetCurrentPosition]는 현재 사용자의 위치를 확인하는 비즈니스 로직이다.
///
/// 사용자의 현재 위치를 알고 싶을 때 사용되며, [call] 메소드를 통해 [NavigatorRepository.getCurrentPosition]를 호출하여
/// 현재 사용자의 위치를 반환한다.
///
/// 사용 시 [call]의 parameter에 [NoParams] 객체를 Argument로 넘겨주어야 한다.
///
/// ---
/// ## 주의할 점
/// [GetCurrentPosition] 로직은 사용자 현재 위치 파악을 수행한다.
/// 따라서 `사용자 위치 정보 제공 허가`, `인터넷 연결`이 모두 선행되어야 한다.
///
/// ---
/// ## UseCase
/// [GetCurrentPosition]은 [UseCase]의 [call] 메소드를 구현(implements)해야 한다.
/// 이때, [call] 메소드의 Parameter와 Return Type은 아래와 같다.
///
/// ### Parameter
/// [NoParams]로서 할당 받는 값이 없다.
///
/// ### Return Type
/// [Either]로서 ([Failure], [bool])의 형태로 반환된다.
///
/// [GetCurrentPosition]의 로직이 수행될 경우, 아래와 같이 결과가 반환된다.
///
/// |return||case|
/// |:-------|-|:--------|
/// |[LatLng]||현재 위치 확인 후, 사용자의 현재 위치(위도, 경도)를 [LatLng]으로 담아 반환|
/// |[ServerFailure]||인터넷 연결 불안정으로 인한 사용자 현재 위치 파악 실패|
///
/// ---
/// ## Members
/// [GetCurrentPosition]의 member는 아래와 같다.
///
/// ### field
/// * [repository]
///
/// ### method
/// * [call]
///
/// ---
/// ## Example
/// [GetCurrentPosition]는 아래와 같이 직접 클래스를 생성하고 의존성을 주입하여 객체를 생성할 수 있다.
///
/// ```dart
/// GetCurrentPosition getCurrentPosition = GetCurrentPosition(repository);
/// ```
///
/// 단, 아래와 같이 [GetCurrentPosition]의 super class인 [NavUseCase]을 변수형으로 선언하고, 되도록 외부에서 의존성을 주입하는 방식을 권장한다.
///
/// ```dart
/// // 변수형 NavUseCase 사용
/// NavUseCase getCurrentPosition = GetCurrentPosition(repository);
///
/// // 외부 의존성 주입이 완료된 경우
/// NavUseCase getCurrentPosition = DI.get<NavUseCase>();
/// ```
///
/// 객체의 생성이 끝난 경우 아래의 방법으로 [call] 메소드를 호출한다.
/// 이때 argument는 [NoParams]이므로 아래와 같이 사용한다.
///
/// ```dart
/// getCurrentPosition(NoParams());
/// ```
///
/// 아래는 위 과정에 대한 전문이다.
/// ```dart
/// GetCurrentPosition getCurrentPosition = GetCurrentPosition(repository); // 비권장
/// NavUseCase getCurrentPosition = GetCurrentPosition(repository); // 권장
/// NavUseCase getCurrentPosition = DI.get<NavUseCase>(); // Best Practice
///
/// getCurrentPosition(NoParams()); // call 메소드 호출
/// ```
class GetCurrentPosition extends NavUseCase
    implements UseCase<LatLng, NoParams> {
  /// [NavigatorRepository] 객체를 담는 변수로서 외부에서 DI되어 사용된다.
  ///
  /// domain layer의 repository interface로 변수형을 선언([NavigatorRepository])하고 실제 DI하는 값은
  /// data layer의 repository implements로 주입하여, 캡슐화한다.
  ///
  /// See also:
  ///  * DI에 대한 자세한 설명은 `injection.dart` 파일에서 확인할 수 있다.
  NavigatorRepository repository;

  /// Default constructor로서 의존성 주입을 위해 [repository]를 Argument로 반드시 받아야 한다.
  ///
  /// 아래와 같이 사용할 수 있다.
  /// ```dart
  /// GetCurrentPosition getCurrentPosition = GetCurrentPosition(repository); // 비권장
  /// NavUseCase getCurrentPosition = GetCurrentPosition(repository); // 권장
  /// NavUseCase getCurrentPosition = DI.get<NavUseCase>(); // Best Practice
  /// ```
  GetCurrentPosition({required this.repository});

  @override
  Future<Either<Failure, LatLng>> call(NoParams params) async {
    return await repository.getCurrentPosition();
  }
}
