import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../repositories/flash_repository.dart';

/// [ServiceUseCase]는 횡단보도 검색/연결(`lib/domain/usecases/crosswalk_usecase.dart`)를 제외한 앱 내 모든 추가 기능(편의 기능)의 [UseCase] 로직들의 super class이다.
///
/// 앱 내 편의 기능과 관련된 서비스는 [ServiceUseCase]에 정의되어야 한다.
/// 즉, 안전 경광등 또는 그 외의 모든 기타 서비스와 관련된 비즈니스 로직은 [ServiceUseCase]의 자식 형태로 구현되어야 하며
/// [ServiceUseCase]는 모든 편의 기능의 super class로서 위치해야 한다.
///
/// ---
/// ## 추가 기능이란?
/// 시스템 내 블루투스를 통한 횡단보도 스캔 및 연결을 제외한 모든 편의 기능을 의미한다.
/// 즉, 메인이 되는 기능(횡단보도 관련 기능)을 제외한 추가적인 기타 서비스를 의미한다.
///
/// * *[ServiceUseCase]는 메인 기능과 기타 서비스의 구분을 위해 존재하며, 이는 추후 개발 시 필요에 따라 변경될 수 있다.*
/// * *안전 나침반의 경우 횡단보도 연결(`lib/domain/usecases/crosswalk_usecase.dart`)에 의해 실행되기 때문에 [ServiceUseCase]의 비즈니스 로직으로는 구현하지 않았다.*
///
/// ---
/// ## Service
/// [ServiceUseCase]는 아래의 기타 서비스를 가지고 있다.
///
/// * *안전 경광등 외에 다른 추가 기능이 필요한 경우 [ServiceUseCase]를 상속받는 구조로 추가할 수 있다.*
///
/// |service||설명|
/// |:-------|-|:--------|
/// |[ControlFlash]||안전 경광등 관련 비즈니스 로직의 super class|
///
/// ---
/// ## 주의할 점
/// [ServiceUseCase]는 실질적인 비즈니스 로직으로서 사용되지 않는다.
///
/// 안전 경광등 켜기/끄기 와 같은 실질적인(details) 비즈니스 로직들의 최상단 클래스로서
/// 이러한 비즈니스 로직들이 추가 기능([ServiceUseCase])과 관련되어 있다는 것을 알려주는 역할만을 수행한다.
///
/// 이후 구현이 필요한 비즈니스 로직이 추가 기능이라면, [ServiceUseCase]의 sub class로 배치되어야 한다.
abstract class ServiceUseCase {}

/// [ControlFlash]은 [UseCase]로서, 안전 경광등 기능의 super class이다.
///
/// 안전 경광등 관련 모든 비즈니스 로직은 [ControlFlash]의 sub class로 구현되어야 한다.
/// [ControlFlash]이 포함하고 있는 비즈니스 로직은 아래와 같다.
///
/// |sub class||설명|
/// |:-------|-|:--------|
/// |[ControlFlashOn]||안전 경광등 켜기 비즈니스 로직|
/// |[ControlFlashOnWithWeather]||날씨에 따른 안전 경광등 켜기 비즈니스 로직|
/// |[ControlFlashOff]||안전 경광등 끄기 비즈니스 로직|
///
/// ---
/// ## 주의할 점
/// [ControlFlash]은 실질적인 비즈니스 로직으로서 사용되지 않는다.
///
/// 안전 경광등 관련 비즈니스 로직들의 super class로서 이러한 비즈니스 로직들이
/// 안전 경광등과 관련되어 있는 것을 알려주는 역할만을 수행한다.
///
/// 이후 구현이 필요한 안전 경광등 관련 비즈니스 로직은 [ControlFlash]의 sub class로 배치되어야 한다.
///
/// 또한, [ControlFlash]은 디바이스의 카메라 후래쉬가 있는 경우 동작된다.
/// 만약 카메라 후래쉬가 없는 경우 동작에 실패([Failure])하게 된다.
///
/// ---
/// ## UseCase
/// [ControlFlash]의 sub class들은 [UseCase]의 [call] 메소드를 구현(implements)해야 한다.
/// 이때, [call] 메소드의 Parameter와 Return Type은 아래와 같다.
///
/// ### Parameter
/// [NoParams]로서 할당 받는 값이 없다.
///
/// ### Return Type
/// [Either]로서 ([Failure], [Void])의 형태로 반환된다.
///
/// |return||case|
/// |:-------|-|:--------|
/// |[Void]||경광등 관련 로직 수행이 성공하는 경우|
/// |[Failure]||경광등 관련 로직 수행이 실패하는 경우|
abstract class ControlFlash extends ServiceUseCase
    implements UseCase<Void, NoParams> {}

/// [ControlFlashOn]는 안전 경광등 켜기 비즈니스 로직이다.
///
/// 안전 경광등을 무한하게 켜야하는 경우 사용되며, [call] 메소드를 통해 [FlashRepository.turnOn]를 호출하여 안전 경광등 켜기를 시도한다.
///
/// 사용 시 [call]의 parameter에 [NoParams] 객체를 Argument로 넘겨주어야 한다.
///
/// [ControlFlashOn]의 로직이 수행될 경우, 아래와 같이 결과가 반환된다.
///
/// |return||case|
/// |:-------|-|:--------|
/// |[Void]||안전 경광등 켜기 성공|
/// |[FlashFailure]||안전 경광등 켜기 실패|
///
/// ---
/// ## 주의할 점
/// [ControlFlashOn]은 안전 경광등을 켜는 기능만을 수행하기 때문에 안전 경광등을 끄고 싶다면 [ControlFlashOff]를 활용하여 안전 경광등을 종료해야 한다.
///
/// ---
/// ## Members
/// [ControlFlashOn]의 member는 아래와 같다.
///
/// ### field
/// * [repository]
///
/// ### method
/// * [call]
///
/// ---
/// ## Example
/// [ControlFlashOn]는 아래와 같이 직접 클래스를 생성하고 의존성을 주입하여 객체를 생성할 수 있다.
///
/// ```dart
/// ControlFlashOn controlFlashOn = ControlFlashOn(repository);
/// ```
///
/// 단, 아래와 같이 [ControlFlashOn]의 super class인 [ControlFlash]을 변수형으로 선언하고, 되도록 외부에서 의존성을 주입하는 방식을 권장한다.
///
/// ```dart
/// // 변수형 ControlFlash 사용
/// ControlFlash controlFlashOn = ControlFlashOn(repository);
///
/// // 외부 의존성 주입이 완료된 경우
/// ControlFlash controlFlashOn = DI.get<ControlFlash>();
/// ```
///
/// 객체의 생성이 끝난 경우 아래의 방법으로 [call] 메소드를 호출한다.
/// 이때 argument는 [NoParams]이므로 아래와 같이 사용한다.
///
/// ```dart
/// controlFlashOn(NoParams());
/// ```
///
/// 아래는 위 과정에 대한 전문이다.
/// ```dart
/// ControlFlashOn controlFlashOn = ControlFlashOn(repository); // 비권장
/// ControlFlash controlFlashOn = ControlFlashOn(repository); // 권장
/// ControlFlash controlFlashOn = DI.get<ControlFlash>(); // Best Practice
///
/// controlFlashOn(NoParams()); // call 메소드 호출
/// ```
class ControlFlashOn implements ControlFlash {
  /// [FlashRepository] 객체를 담는 변수로서 외부에서 DI되어 사용된다.
  ///
  /// domain layer의 repository interface로 변수형을 선언([FlashRepository])하고 실제 DI하는 값은
  /// data layer의 repository implements로 주입하여, 캡슐화한다.
  ///
  /// See also:
  ///  * DI에 대한 자세한 설명은 `injection.dart` 파일에서 확인할 수 있다.
  final FlashRepository repository;

  /// Default constructor로서 의존성 주입을 위해 [repository]를 Argument로 반드시 받아야 한다.
  ///
  /// 아래와 같이 사용할 수 있다.
  /// ```dart
  /// ControlFlashOn controlFlashOn = ControlFlashOn(repository); // 비권장
  /// ControlFlash controlFlashOn = ControlFlashOn(repository); // 권장
  /// ControlFlash controlFlashOn = DI.get<ControlFlash>(); // Best Practice
  /// ```
  ControlFlashOn({required this.repository});

  @override
  Future<Either<Failure, Void>> call(NoParams params) async {
    return await repository.turnOn();
  }
}

/// [ControlFlashOnWithWeather]는 날씨에 따른 안전 경광등 켜기 비즈니스 로직이다.
///
/// 사용자의 위치를 기반으로 현재 날씨에 따라 안전 경광등을 켜야하는 경우 사용되며, [call] 메소드를 통해 [FlashRepository.turnOnWithWeather]를 호출하여 안전 경광등 켜기를 시도한다.
///
/// 사용 시 [call]의 parameter에 [NoParams] 객체를 Argument로 넘겨주어야 한다.
///
/// [ControlFlashOnWithWeather]의 로직이 수행될 경우, 아래와 같이 결과가 반환된다.
///
/// |return||case|
/// |:-------|-|:--------|
/// |[Void]||안전 경광등 켜기 성공|
/// |[ValidateFailure]||현재 날씨 상태가 안전 경광등을 켜지 않아도 되는 상태(안전 경광등 켜지지 않음)|
/// |[FlashFailure]||안전 경광등 켜기 실패|
/// |[ServerFailure]||인터넷 연결 불안정으로 인한 현재 사용자 위치 파악 불가(안전 경광등 켜지지 않음)|
///
/// ---
/// ## 주의할 점
/// [ControlFlashOnWithWeather]은 안전 경광등을 켜는 기능만을 수행하기 때문에 안전 경광등을 끄고 싶다면 [ControlFlashOff]를 활용하여 안전 경광등을 종료해야 한다.
///
/// ---
/// ## Members
/// [ControlFlashOnWithWeather]의 member는 아래와 같다.
///
/// ### field
/// * [repository]
///
/// ### method
/// * [call]
///
/// ---
/// ## Example
/// [ControlFlashOnWithWeather]는 아래와 같이 직접 클래스를 생성하고 의존성을 주입하여 객체를 생성할 수 있다.
///
/// ```dart
/// ControlFlashOnWithWeather controlFlashOnWithWeather = ControlFlashOnWithWeather(repository);
/// ```
///
/// 단, 아래와 같이 [ControlFlashOnWithWeather]의 super class인 [ControlFlash]을 변수형으로 선언하고, 되도록 외부에서 의존성을 주입하는 방식을 권장한다.
///
/// ```dart
/// // 변수형 ControlFlash 사용
/// ControlFlash controlFlashOnWithWeather = ControlFlashOnWithWeather(repository);
///
/// // 외부 의존성 주입이 완료된 경우
/// ControlFlash controlFlashOnWithWeather = DI.get<ControlFlash>();
/// ```
///
/// 객체의 생성이 끝난 경우 아래의 방법으로 [call] 메소드를 호출한다.
/// 이때 argument는 [NoParams]이므로 아래와 같이 사용한다.
///
/// ```dart
/// controlFlashOnWithWeather(NoParams());
/// ```
///
/// 아래는 위 과정에 대한 전문이다.
/// ```dart
/// ControlFlashOnWithWeather controlFlashOnWithWeather = ControlFlashOnWithWeather(repository); // 비권장
/// ControlFlash controlFlashOnWithWeather = ControlFlashOnWithWeather(repository); // 권장
/// ControlFlash controlFlashOnWithWeather = DI.get<ControlFlash>(); // Best Practice
///
/// controlFlashOnWithWeather(NoParams()); // call 메소드 호출
/// ```
class ControlFlashOnWithWeather implements ControlFlash {
  /// [FlashRepository] 객체를 담는 변수로서 외부에서 DI되어 사용된다.
  ///
  /// domain layer의 repository interface로 변수형을 선언([FlashRepository])하고 실제 DI하는 값은
  /// data layer의 repository implements로 주입하여, 캡슐화한다.
  ///
  /// See also:
  ///  * DI에 대한 자세한 설명은 `injection.dart` 파일에서 확인할 수 있다.
  final FlashRepository repository;

  /// Default constructor로서 의존성 주입을 위해 [repository]를 Argument로 반드시 받아야 한다.
  ///
  /// 아래와 같이 사용할 수 있다.
  /// ```dart
  /// ControlFlashOnWithWeather controlFlashOnWithWeather = ControlFlashOnWithWeather(repository); // 비권장
  /// ControlFlash controlFlashOnWithWeather = ControlFlashOnWithWeather(repository); // 권장
  /// ControlFlash controlFlashOnWithWeather = DI.get<ControlFlash>(); // Best Practice
  /// ```
  ControlFlashOnWithWeather({required this.repository});

  @override
  Future<Either<Failure, Void>> call(NoParams params) async {
    return await repository.turnOnWithWeather();
  }
}

/// [ControlFlashOff]는 안전 경광등 끄기 비즈니스 로직이다.
///
/// 안전 경광등을 꺼야하는 경우 사용되며, [call] 메소드를 통해 [FlashRepository.turnOff]를 호출하여 안전 경광등 끄기를 시도한다.
///
/// 사용 시 [call]의 parameter에 [NoParams] 객체를 Argument로 넘겨주어야 한다.
///
/// [ControlFlashOff]의 로직이 수행될 경우, 아래와 같이 결과가 반환된다.
///
/// |return||case|
/// |:-------|-|:--------|
/// |[Void]||안전 경광등 끄기 성공|
/// |[FlashFailure]||안전 경광등 끄기 실패|
///
/// ---
/// ## Members
/// [ControlFlashOff]의 member는 아래와 같다.
///
/// ### field
/// * [repository]
///
/// ### method
/// * [call]
///
/// ---
/// ## Example
/// [ControlFlashOff]는 아래와 같이 직접 클래스를 생성하고 의존성을 주입하여 객체를 생성할 수 있다.
///
/// ```dart
/// ControlFlashOff controlFlashOff = ControlFlashOff(repository);
/// ```
///
/// 단, 아래와 같이 [ControlFlashOff]의 super class인 [ControlFlash]을 변수형으로 선언하고, 되도록 외부에서 의존성을 주입하는 방식을 권장한다.
///
/// ```dart
/// // 변수형 ControlFlash 사용
/// ControlFlash controlFlashOff = ControlFlashOff(repository);
///
/// // 외부 의존성 주입이 완료된 경우
/// ControlFlash controlFlashOff = DI.get<ControlFlash>();
/// ```
///
/// 객체의 생성이 끝난 경우 아래의 방법으로 [call] 메소드를 호출한다.
/// 이때 argument는 [NoParams]이므로 아래와 같이 사용한다.
///
/// ```dart
/// controlFlashOff(NoParams());
/// ```
///
/// 아래는 위 과정에 대한 전문이다.
/// ```dart
/// ControlFlashOff controlFlashOff = ControlFlashOff(repository); // 비권장
/// ControlFlash controlFlashOff = ControlFlashOff(repository); // 권장
/// ControlFlash controlFlashOff = DI.get<ControlFlash>(); // Best Practice
///
/// controlFlashOff(NoParams()); // call 메소드 호출
/// ```
class ControlFlashOff implements ControlFlash {
  /// [FlashRepository] 객체를 담는 변수로서 외부에서 DI되어 사용된다.
  ///
  /// domain layer의 repository interface로 변수형을 선언([FlashRepository])하고 실제 DI하는 값은
  /// data layer의 repository implements로 주입하여, 캡슐화한다.
  ///
  /// See also:
  ///  * DI에 대한 자세한 설명은 `injection.dart` 파일에서 확인할 수 있다.
  final FlashRepository repository;

  /// Default constructor로서 의존성 주입을 위해 [repository]를 Argument로 반드시 받아야 한다.
  ///
  /// 아래와 같이 사용할 수 있다.
  /// ```dart
  /// ControlFlashOnWithWeather controlFlashOnWithWeather = ControlFlashOnWithWeather(repository); // 비권장
  /// ControlFlash controlFlashOnWithWeather = ControlFlashOnWithWeather(repository); // 권장
  /// ControlFlash controlFlashOnWithWeather = DI.get<ControlFlash>(); // Best Practice
  /// ```
  ControlFlashOff({required this.repository});

  @override
  Future<Either<Failure, Void>> call(NoParams params) async {
    return await repository.turnOff();
  }
}
