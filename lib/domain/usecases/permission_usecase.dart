import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../../core/utils/enums.dart';
import '../repositories/permission_repository.dart';

/// [PermissionUseCase]는 디바이스의 권한 설정과 관련된 모든 [UseCase] 로직들의 super class이다.
///
/// 디바이스의 기능(블루투스, 위치 등)을 사용하기 위한 권한 설정과 관련된 기능은 [PermissionUseCase]에 정의되어야 한다.
/// 즉, 블루투스 권한 요청/확인 또는 그 외의 권한 관련된 비즈니스 로직은 [PermissionUseCase]의 자식 형태로 구현되어야 하며
/// [PermissionUseCase]는 모든 권한 설정의 super class로서 위치해야 한다.
///
/// ---
/// ## Permission
/// 디바이스의 센서를 사용하고 싶은 경우, 또는 사용자의 허가가 필요한 기능을 수행해야 하는 경우 권한 요청 창을 통해 허가를 받아야 한다.
/// 대표적으로 블루투스 센서 사용, 카메라 접근, 사용자 위치 접근과 같은 기능들이 사용자에 의해 권한 허가 후 사용할 수 있는 기능들이다.
///
/// * [AOS/IOS Permission 정리](https://bangu4.tistory.com/347)
///
/// ---
/// ## Service
/// [PermissionUseCase]는 아래의 Permission 서비스를 가지고 있다.
///
/// * *블루투스, 위치 외에 다른 Permission 서비스가 필요한 경우 [EPermission]에 해당 권한 값을 추가하여 사용할 수 있다.*
///
/// |service||설명|
/// |:-------|-|:--------|
/// |[GetPermission]||권한 상태 확인 비즈니스 로직의 super class|
/// |[SetPermission]||권한 요청 비즈니스 로직의 super class|
///
/// ---
/// ## 주의할 점
/// [PermissionUseCase]는 실질적인 비즈니스 로직으로서 사용되지 않는다.
///
/// 권한 요청, 권한 상태 확인과 같은 실질적인(details) 비즈니스 로직들의 최상단 클래스로서
/// 이러한 비즈니스 로직들이 사용자의 권한(Permission)과 관련되어 있다는 것을 알려주는 역할만을 수행한다.
///
/// 또한, 각 권한은 OS에 맞는 환경 설정이 되어 있어야 한다.
/// ios의 경우 `ios/Runner/Info.plist`, aos의 경우 `android/app/src/main/AndroidManifest.xml`에 각 권한에 맞는 설정을 해주어야 한다.
///
/// * [Flutter Permission Handler - OS 권한 설정](https://pub.dev/packages/permission_handler)
abstract class PermissionUseCase {}

/// [GetPermission]는 권한 확인 비즈니스 로직이다.
///
/// 현재 특정 권한에 대한 상태 확인 시 사용되며, 사용하고자 하는 권한에 따라 [call] 메소드를 통해 [PermissionRepository]의 메소드를 호출하여 권한 상태를 확인을 시도한다.
///
/// 확인하고자 하는 권한에 따른 [PermissionRepository]의 호출 메소드는 아래와 같다.
///
/// |permission||method||case|
/// |:---------------------|-|:--------------------------------------------|-|:--------------|
/// |[EPermission.BLUETOOTH]||[PermissionRepository.getBluetoothPermission]||블루투스 권한 확인 시|
/// |[EPermission.LOCATION]||[PermissionRepository.getLocationPermission]||사용자 위치 권한 확인 시|
///
/// 권한 확인의 경우 확인하고자 하는 권한을 설정해 주어야 하므로, [call]의 `params` Parameter에 해당 권한의 [EPermission]을 Argument로 넘겨야 한다.
///
/// ---
/// ## 주의할 점
/// [GetPermission]이 수행되기 위해서는 각 OS에 맞는 환경 설정이 되어 있어야 한다.
///
/// * 자세한 사항은 `PermissionUseCase > 주의할 점`을 참고
///
/// ---
/// ## UseCase
/// [GetPermission]은 [UseCase]의 [call] 메소드를 구현(implements)해야 한다.
/// 이때, [call] 메소드의 Parameter와 Return Type은 아래와 같다.
///
/// ### Parameter
/// 확인하고자 하는 권한을 나타내는 [EPermission]을 Parameter로 가진다.
///
/// ### Return Type
/// [Either]로서 ([Failure], [bool])의 형태로 반환된다.
///
/// [GetPermission]의 로직이 수행될 경우, 아래와 같이 결과가 반환된다.
///
/// |return||case|
/// |:-------|-|:--------|
/// |[bool]||권한 확인 성공(`true : 권한 부여됨`, `false : 권한 부여 안됨`)|
/// |[CacheFailure]||권한 확인 실패|
///
/// ---
/// ## Members
/// [GetPermission]의 member는 아래와 같다.
///
/// ### field
/// * [repository]
///
/// ### method
/// * [call]
///
/// ---
/// ## Example
/// [GetPermission]는 아래와 같이 직접 클래스를 생성하고 의존성을 주입하여 객체를 생성할 수 있다.
///
/// ```dart
/// GetPermission getPermission = GetPermission(repository);
/// ```
///
/// 단, 되도록 외부에서 의존성을 주입하는 방식을 권장한다.
///
/// ```dart
/// // 외부 의존성 주입이 완료된 경우
/// GetPermission getPermission = DI.get<GetPermission>();
/// ```
///
/// 객체의 생성이 끝난 경우 아래의 방법으로 [call] 메소드를 호출한다.
/// 이때 argument로 확인하고 싶은 권한의 [EPermission]을 넘겨주어야 한다.
///
/// ```dart
/// getPermission(EPermission.BLUETOOTH); // 블루투스 권한 확인
/// getPermission(EPermission.LOCATION); // 위치 권한 확인
/// ```
///
/// 아래는 위 과정에 대한 전문이다.
/// ```dart
/// GetPermission getPermission = GetPermission(repository); // 권장
/// GetPermission getPermission = DI.get<GetPermission>(); // Best Practice
///
/// getPermission(EPermission.BLUETOOTH); // 블루투스 권한 확인
/// getPermission(EPermission.LOCATION); // 위치 권한 확인
/// ```
class GetPermission extends PermissionUseCase
    implements UseCase<bool, EPermission> {
  /// [PermissionRepository] 객체를 담는 변수로서 외부에서 DI되어 사용된다.
  ///
  /// domain layer의 repository interface로 변수형을 선언([PermissionRepository])하고 실제 DI하는 값은
  /// data layer의 repository implements로 주입하여, 캡슐화한다.
  ///
  /// See also:
  ///  * DI에 대한 자세한 설명은 `injection.dart` 파일에서 확인할 수 있다.
  PermissionRepository repository;

  /// Default constructor로서 의존성 주입을 위해 [repository]를 Argument로 반드시 받아야 한다.
  ///
  /// 아래와 같이 사용할 수 있다.
  /// ```dart
  /// GetPermission getPermission = GetPermission(repository); // 권장
  /// GetPermission getPermission = DI.get<GetPermission>(); // Best Practice
  /// ```
  GetPermission({required this.repository});

  @override
  Future<Either<Failure, bool>> call(EPermission params) async {
    switch (params) {
      // 블루투스 권한 확인
      case EPermission.BLUETOOTH:
        return await repository.getBluetoothPermission();

      // 사용자 위치 권한 확인
      case EPermission.LOCATION:
        return await repository.getLocationPermission();

      // EPermission에 등록되지 않은 권한을 확인할 경우
      default:
        return Left(CacheFailure());
    }
  }
}

/// [SetPermission]는 권한 요청 비즈니스 로직이다.
///
/// 현재 특정 권한에 대한 허가 요청 시 사용되며, 사용하고자 하는 권한에 따라 [call] 메소드를 통해 [PermissionRepository]의 메소드를 호출하여 권한 요청을 시도한다.
///
/// 요청하고자 하는 권한에 따른 [PermissionRepository]의 호출 메소드는 아래와 같다.
///
/// |permission||method||case|
/// |:---------------------|-|:--------------------------------------------|-|:--------------|
/// |[EPermission.BLUETOOTH]||[PermissionRepository.setBluetoothPermission]||블루투스 권한 요청 시|
/// |[EPermission.LOCATION]||[PermissionRepository.setLocationPermission]||사용자 위치 권한 요청 시|
///
/// 권한 요청의 경우 요청하고자 하는 권한을 설정해 주어야 하므로, [call]의 `params` Parameter에 해당 권한의 [EPermission]을 Argument로 넘겨야 한다.
///
/// ---
/// ## 주의할 점
/// [SetPermission]이 수행되기 위해서는 각 OS에 맞는 환경 설정이 되어 있어야 한다.
///
/// * 자세한 사항은 `PermissionUseCase > 주의할 점`을 참고
///
/// ---
/// ## UseCase
/// [SetPermission]은 [UseCase]의 [call] 메소드를 구현(implements)해야 한다.
/// 이때, [call] 메소드의 Parameter와 Return Type은 아래와 같다.
///
/// ### Parameter
/// 확인하고자 하는 권한을 나타내는 [EPermission]을 Parameter로 가진다.
///
/// ### Return Type
/// [Either]로서 ([Failure], [Void])의 형태로 반환된다.
///
/// [SetPermission]의 로직이 수행될 경우, 아래와 같이 결과가 반환된다.
///
/// |return||case|
/// |:-------|-|:--------|
/// |[Void]||권한 요청 성공(`요청 창을 띄울 수 있는 경우 > 요청 창 출력`, `요청 창을 띄울 수 없는 경우 > 설정 앱 전환`))|
/// |[CacheFailure]||권한 요청 실패|
///
/// * 요청 창과 관련된 자세한 사항은 `lib/data/sources/permission_native_data_source.dart`를 참고
///
/// ---
/// ## Members
/// [SetPermission]의 member는 아래와 같다.
///
/// ### field
/// * [repository]
///
/// ### method
/// * [call]
///
/// ---
/// ## Example
/// [SetPermission]는 아래와 같이 직접 클래스를 생성하고 의존성을 주입하여 객체를 생성할 수 있다.
///
/// ```dart
/// SetPermission setPermission = SetPermission(repository);
/// ```
///
/// 단, 되도록 외부에서 의존성을 주입하는 방식을 권장한다.
///
/// ```dart
/// // 외부 의존성 주입이 완료된 경우
/// SetPermission setPermission = DI.get<SetPermission>();
/// ```
///
/// 객체의 생성이 끝난 경우 아래의 방법으로 [call] 메소드를 호출한다.
/// 이때 argument로 요청하고 싶은 권한의 [EPermission]을 넘겨주어야 한다.
///
/// ```dart
/// setPermission(EPermission.BLUETOOTH); // 블루투스 권한 요청
/// setPermission(EPermission.LOCATION); // 위치 권한 요청
/// ```
///
/// 아래는 위 과정에 대한 전문이다.
/// ```dart
/// SetPermission setPermission = SetPermission(repository); // 권장
/// SetPermission setPermission = DI.get<SetPermission>(); // Best Practice
///
/// setPermission(EPermission.BLUETOOTH); // 블루투스 권한 요청
/// setPermission(EPermission.LOCATION); // 위치 권한 요청
/// ```
class SetPermission extends PermissionUseCase
    implements UseCase<Void, EPermission> {
  /// [PermissionRepository] 객체를 담는 변수로서 외부에서 DI되어 사용된다.
  ///
  /// domain layer의 repository interface로 변수형을 선언([PermissionRepository])하고 실제 DI하는 값은
  /// data layer의 repository implements로 주입하여, 캡슐화한다.
  ///
  /// See also:
  ///  * DI에 대한 자세한 설명은 `injection.dart` 파일에서 확인할 수 있다.
  PermissionRepository repository;

  /// Default constructor로서 의존성 주입을 위해 [repository]를 Argument로 반드시 받아야 한다.
  ///
  /// 아래와 같이 사용할 수 있다.
  /// ```dart
  /// SetPermission setPermission = SetPermission(repository); // 권장
  /// SetPermission setPermission = DI.get<SetPermission>(); // Best Practice
  /// ```
  SetPermission({required this.repository});

  @override
  Future<Either<Failure, Void>> call(EPermission params) async {
    switch (params) {
      // 블루투스 권한 요청
      case EPermission.BLUETOOTH:
        return await repository.setBluetoothPermission();

      // 사용자 위치 권한 요청
      case EPermission.LOCATION:
        return await repository.setLocationPermission();

      // EPermission에 등록되지 않은 권한을 허용을 요청할 경우
      default:
        return Left(CacheFailure());
    }
  }
}
