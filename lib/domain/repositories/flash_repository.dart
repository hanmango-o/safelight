import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';

/// [FlashRepository]는 안전 경광등 켜기/끄기와 관련된 Repository이다.
///
/// `ServiceUseCase`의 `ControlFlash` 비즈니스 로직들의 요청을 처리하고 요청에 따른 결과를 반환한다.
///
/// [FlashRepository]는 Repository의 interface로서 캡슐화의 역할을 수행한다.
/// 이에 따라 [FlashRepository]는 `lib/data/repositories/flash_repository_impl.dart`의
/// `FlashRepositoryImpl` 클래스를 통해 구현된다.
///
/// 이후, 객체 생성 시 [FlashRepository] 타입으로 객체를 생성하여 Domain Layer 와 Data Layer를 연결한다.
///
/// ---
/// ## Functions
/// [FlashRepository]는 요청에 따라 아래의 메소드를 호출하여 기능을 수행할 수 있다.
///
/// |기능||설명|
/// |:-------|-|:--------|
/// |[turnOn]||안전 경광등 켜기|
/// |[turnOnWithWeather]||날씨에 따른 안전 경광등 켜기|
/// |[turnOff]||안전 경광등 끄기|
abstract class FlashRepository {
  /// [turnOn]는 안전 경광등 켜기를 수행한다.
  ///
  /// 안전 경광등이 켜지게 되면 [turnOff]를 통해 종료되기 전까지 무한하게 켜지게 된다.
  ///
  /// [Either]로서 ([Failure], [Void])의 형태로 반환되며, 아래와 같이 결과가 반환된다.
  ///
  /// |return||case|
  /// |:-------|-|:--------|
  /// |`Right(Void())`||안전 경광등 켜기 성공|
  /// |`Left(FlashFailure())`||안전 경광등 켜기 실패|
  Future<Either<Failure, Void>> turnOn();

  /// [turnOnWithWeather]는 날씨에 따른 안전 경광등 켜기를 수행한다.
  ///
  /// 안전 경광등이 켜지게 되면 [turnOff]를 통해 종료되기 전까지 무한하게 켜지게 된다.
  ///
  /// [Either]로서 ([Failure], [Void])의 형태로 반환되며, 아래와 같이 결과가 반환된다.
  ///
  /// |return||case|
  /// |:-------|-|:--------|
  /// |`Right(Void())`||날씨에 따른 안전 경광등 켜기 성공|
  /// |`Left(FlashFailure())`||안전 경광등 켜기 실패|
  /// |`Left(ValidateFailure())`||현재 날씨 상태가 안전 경광등을 켜지 않아도 되는 상태(안전 경광등 켜지지 않음)|
  /// |`Left(ServerFailure())`||인터넷 연결 불안정으로 인한 현재 사용자 위치 파악 불가(안전 경광등 켜지지 않음)|
  Future<Either<Failure, Void>> turnOnWithWeather();

  /// [turnOff]는 안전 경광등 끄기를 수행한다.
  ///
  /// [Either]로서 ([Failure], [Void])의 형태로 반환되며, 아래와 같이 결과가 반환된다.
  ///
  /// |return||case|
  /// |:-------|-|:--------|
  /// |`Right(Void())`||안전 경광등 끄기 성공|
  /// |`Left(FlashFailure())`||안전 경광등 끄기 실패|
  Future<Either<Failure, Void>> turnOff();
}
