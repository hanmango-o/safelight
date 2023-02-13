import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/crosswalk.dart';
import '../repositories/crosswalk_repository.dart';

/// [CrosswalkUseCase]는 횡단보도와 관련된 모든 [UseCase] 로직들의 super class이다.
///
/// 횡단보도의 검색 및 연결에 대한 제어는 [CrosswalkUseCase]에 정의된 형태로 호출되어야 한다.
/// 즉, 블루투스를 활용한 횡단보도의 검색 및 연결, 또는 그 외의 모든 횡단보도와 관련된 비즈니스 로직은 [CrosswalkUseCase]의 자식 형태로 구현되어야 하며
/// [CrosswalkUseCase]는 횡단보도 관련 모든 비즈니스 로직의 super class로서 위치해야 한다.
///
/// ---
/// ## Service
/// [CrosswalkUseCase]는 아래의 서비스를 가지고 있다.
///
/// * *아래 서비스 외에 횡단보도 관련 추가 서비스가 필요하다면 [CrosswalkUseCase]를 상속받는 구조로 추가할 수 있다.*
///
/// |service||설명|
/// |:-------|-|:--------|
/// |[SearchCrosswalk]||횡단보도 검색 관련 비즈니스 로직의 super class|
/// |[ConnectCrosswalk]||횡단보도 연결 관련 비즈니스 로직의 super class|
///
/// ---
/// ## 주의할 점
/// [CrosswalkUseCase]는 실질적인 비즈니스 로직으로서 사용되지 않는다.
///
/// 스마트 압버튼(비콘)이 부착되어 있는 횡단보도 검색과 같은 실질적인(details) 비즈니스 로직들의 최상단 클래스로서
/// 이러한 비즈니스 로직들이 횡단보도(Crosswalk)과 관련되어 있다는 것을 알려주는 역할만을 수행한다.
///
/// 이후 구현이 필요한 비즈니스 로직이 횡단보도(Crosswalk)과 관련되어 있다면, [CrosswalkUseCase]의 sub class로 배치되어야 한다.
abstract class CrosswalkUseCase {}

/// [SearchCrosswalk]은 [UseCase]로서, 모든 횡단보도 검색 로직들의 super class이다.
///
/// 횡단보도 검색과 관련된 비즈니스 로직은 [SearchCrosswalk]의 sub class로 구현되어야 한다.
/// [SearchCrosswalk]가 포함하고 있는 비즈니스 로직은 아래와 같다.
///
/// |sub class||설명|
/// |:-------|-|:--------|
/// |[Search2FiniteTimes]||제한 시간 안에 주변 스마트 압버튼(비콘) 스캔 후, 결과에 따른 횡단보도 검색|
/// |[Search2InfiniteTimes]||주변 스마트 압버튼(비콘) 스캔 후 즉시 연결, 무한 스캔시 사용|
///
/// ---
/// ## 주의할 점
/// [SearchCrosswalk]은 실질적인 비즈니스 로직으로서 사용되지 않는다.
///
/// 횡단보도 검색 관련 비즈니스 로직들의 super class로서 이러한 비즈니스 로직들이
/// 횡단보도 검색과 관련되어 있는 것을 알려주는 역할만을 수행한다.
///
/// 이후 구현이 필요한 횡단보도 검색 관련 비즈니스 로직은 [SearchCrosswalk]의 sub class로 배치되어야 한다.
///
/// ---
/// ## UseCase
/// [SearchCrosswalk]의 sub class들은 [UseCase]의 [call] 메소드를 구현(implements)해야 한다.
/// 이때, [call] 메소드의 Parameter와 Return Type은 아래와 같다.
///
/// ### Parameter
/// [NoParams]로서 할당 받는 값이 없다.
///
/// ### Return Type
/// [Either]로서 ([Failure], `List<Crosswalk>?`)의 형태로 반환된다.
///
/// |return||case|
/// |:-------|-|:--------|
/// |`List<Crosswalk>?`||횡단보도 검색에 성공하는 경우|
/// |[Failure]||횡단보도 검색에 실패하는 경우|
abstract class SearchCrosswalk extends CrosswalkUseCase
    implements UseCase<List<Crosswalk>?, NoParams> {}

/// [ConnectCrosswalk]은 [UseCase]로서, 모든 횡단보도 연결 로직들의 super class이다.
///
/// 횡단보도 연결과 관련된 비즈니스 로직은 [ConnectCrosswalk]의 sub class로 구현되어야 한다.
/// [ConnectCrosswalk]가 포함하고 있는 비즈니스 로직은 아래와 같다.
///
/// |sub class||설명|
/// |:-------|-|:--------|
/// |[SendAcousticSignal]||비콘 포스트에 음성 유도 커맨드([0x31, 0x00, 0x02])를 보냄|
/// |[SendVoiceInductor]||비콘 포스트에 압버튼 누르기 커맨드([0x31, 0x00, 0x01])를 보냄|
///
/// ---
/// ## 주의할 점
/// [ConnectCrosswalk]는 실질적인 비즈니스 로직으로서 사용되지 않는다.
///
/// 횡단보도 연결 관련 비즈니스 로직들의 super class로서 이러한 비즈니스 로직들이
/// 횡단보도 연결과 관련되어 있는 것을 알려주는 역할만을 수행한다.
///
/// 이후 구현이 필요한 횡단보도 연결 관련 비즈니스 로직은 [ConnectCrosswalk]의 sub class로 배치되어야 한다.
///
/// ---
/// ## UseCase
/// [ConnectCrosswalk]의 sub class들은 [UseCase]의 [call] 메소드를 구현(implements)해야 한다.
/// 이때, [call] 메소드의 Parameter와 Return Type은 아래와 같다.
///
/// ### Parameter
/// 연결할 횡단보도의 정보를 담은 [Crosswalk]를 parameter로 가진다.
///
/// ### Return Type
/// [Either]로서 ([Failure], [Void])의 형태로 반환된다.
///
/// |return||case|
/// |:-------|-|:--------|
/// |[Void]||횡단보도 연결에 성공하는 경우|
/// |[Failure]||횡단보도 연결에 실패하는 경우|
abstract class ConnectCrosswalk extends CrosswalkUseCase
    implements UseCase<Void, Crosswalk> {}

/// [Search2FiniteTimes]는 제한된 시간 내 횡단보도 검색 비즈니스 로직이다.
///
/// 수동 스캔 모드 시 사용되며, [call] 메소드를 통해 [CrosswalkRepository.getCrosswalkFiniteTimes]를 호출하여
/// 주변 횡단보도의 블루투스 압버튼을 스캔하고 스캔된 결과에 맞는 횡단보도 정보를 반환한다.
///
/// 사용 시 [call]의 parameter에 [NoParams] 객체를 Argument로 넘겨주어야 한다.
///
/// [Search2FiniteTimes]의 로직이 수행될 경우, 아래와 같이 결과가 반환된다.
///
/// |return||case|
/// |:-------|-|:--------|
/// |`List<Crosswalk>?`||횡단보도 검색 성공 후, 검색된 횡단보도([Crosswalk])를 [List]형태로 반환|
/// |[BlueFailure]||주변 스마트 압버튼(비콘 포스트) 블루투스 스캔 실패|
/// |[ServerFailure]||인터넷 연결 불안정으로 인한 DB에 횡단보도 정보 요청 실패 및 사용자 현재 위치 파악 실패|
///
/// ---
/// ## 주의할 점
/// [Search2FiniteTimes] 로직은 블루투스 스캔, DB에 횡단보도 정보 요청, 사용자 현재 위치 파악을 수행한다.
/// 따라서 `블루투스 권한 허가`, `사용자 위치 정보 제공 허가`, `인터넷 연결`이 모두 선행되어야 한다.
///
/// ---
/// ## Members
/// [Search2FiniteTimes]의 member는 아래와 같다.
///
/// ### field
/// * [repository]
///
/// ### method
/// * [call]
///
/// ---
/// ## Example
/// [Search2FiniteTimes]는 아래와 같이 직접 클래스를 생성하고 의존성을 주입하여 객체를 생성할 수 있다.
///
/// ```dart
/// Search2FiniteTimes search2FiniteTimes = Search2FiniteTimes(repository);
/// ```
///
/// 단, 아래와 같이 [Search2FiniteTimes]의 super class인 [SearchCrosswalk]을 변수형으로 선언하고, 되도록 외부에서 의존성을 주입하는 방식을 권장한다.
///
/// ```dart
/// // 변수형 SearchCrosswalk 사용
/// SearchCrosswalk search2FiniteTimes = Search2FiniteTimes(repository);
///
/// // 외부 의존성 주입이 완료된 경우
/// SearchCrosswalk search2FiniteTimes = DI.get<SearchCrosswalk>();
/// ```
///
/// 객체의 생성이 끝난 경우 아래의 방법으로 [call] 메소드를 호출한다.
/// 이때 argument는 [NoParams]이므로 아래와 같이 사용한다.
///
/// ```dart
/// search2FiniteTimes(NoParams());
/// ```
///
/// 아래는 위 과정에 대한 전문이다.
/// ```dart
/// Search2FiniteTimes search2FiniteTimes = Search2FiniteTimes(repository); // 비권장
/// SearchCrosswalk search2FiniteTimes = Search2FiniteTimes(repository); // 권장
/// SearchCrosswalk search2FiniteTimes = DI.get<SearchCrosswalk>(); // Best Practice
///
/// search2FiniteTimes(NoParams()); // call 메소드 호출
/// ```
class Search2FiniteTimes implements SearchCrosswalk {
  /// [CrosswalkRepository] 객체를 담는 변수로서 외부에서 DI되어 사용된다.
  ///
  /// domain layer의 repository interface로 변수형을 선언([CrosswalkRepository])하고 실제 DI하는 값은
  /// data layer의 repository implements로 주입하여, 캡슐화한다.
  ///
  /// See also:
  ///  * DI에 대한 자세한 설명은 `injection.dart` 파일에서 확인할 수 있다.
  final CrosswalkRepository repository;

  /// Default constructor로서 의존성 주입을 위해 [repository]를 Argument로 반드시 받아야 한다.
  ///
  /// 아래와 같이 사용할 수 있다.
  /// ```dart
  /// Search2FiniteTimes search2FiniteTimes = Search2FiniteTimes(repository); // 비권장
  /// SearchCrosswalk search2FiniteTimes = Search2FiniteTimes(repository); // 권장
  /// SearchCrosswalk search2FiniteTimes = DI.get<SearchCrosswalk>(); // Best Practice
  /// ```
  Search2FiniteTimes({required this.repository});

  @override
  Future<Either<Failure, List<Crosswalk>?>> call(NoParams params) async {
    return await repository.getCrosswalkFiniteTimes();
  }
}

/// [Search2InfiniteTimes]는 무한한 시간동안 스마트 압버튼(비콘 포스트)을 검색하고 즉시 연결하는 비즈니스 로직이다.
///
/// 자동 스캔 모드 시 사용되며, [call] 메소드를 통해 [CrosswalkRepository.getCrosswalkInfiniteTimes]를 호출하여
/// 주변 횡단보도의 블루투스 압버튼을 스캔하고 스캔된 비콘 포스트에 즉시 연결한다.
/// 이때 연결에 사용하는 커맨드는 압버튼 누르기([0x31, 0x00, 0x01])이다.
///
/// 사용 시 [call]의 parameter에 [NoParams] 객체를 Argument로 넘겨주어야 한다.
///
/// [Search2InfiniteTimes]의 로직이 수행될 경우, 아래와 같이 결과가 반환된다.
///
/// |return||case|
/// |:-------|-|:--------|
/// |`null`||주변 비콘 포스트를 찾고 해당 비콘 포스트에 즉시 연결 성공|
/// |[BlueFailure]||주변 스마트 압버튼(비콘 포스트) 블루투스 스캔/연결 실패|
///
/// ---
/// ## 주의할 점
/// [Search2InfiniteTimes] 로직은 블루투스 스캔과 연결을 수행한다.
/// 따라서 `블루투스 권한 허가`가 선행되어야 한다.
///
/// 또한, [Search2InfiniteTimes] 로직 자체는 1번의 스캔과 연결만을 수행한다.
/// 따라서 [Search2InfiniteTimes] 로직을 무한하게 호출함으로써 자동 스캔을 구현할 수 있다.
///
/// ```dart
/// Timer.periodic(const Duration(seconds: 1), (timer) async {
///   await search2InfiniteTimes(NoParams());
/// });
/// ```
/// *실제 사용은 `lib/presentation/bloc/crosswalk_bloc`의 `CrosswalkBloc._searchInfiniteCrosswalkEvent()`에서 자세히 확인할 수 있다.*
///
/// ---
/// ## Members
/// [Search2InfiniteTimes]의 member는 아래와 같다.
///
/// ### field
/// * [repository]
///
/// ### method
/// * [call]
///
/// ---
/// ## Example
/// [Search2InfiniteTimes]는 아래와 같이 직접 클래스를 생성하고 의존성을 주입하여 객체를 생성할 수 있다.
///
/// ```dart
/// Search2InfiniteTimes search2InfiniteTimes = Search2InfiniteTimes(repository);
/// ```
///
/// 단, 아래와 같이 [Search2InfiniteTimes]의 super class인 [SearchCrosswalk]을 변수형으로 선언하고, 되도록 외부에서 의존성을 주입하는 방식을 권장한다.
///
/// ```dart
/// // 변수형 SearchCrosswalk 사용
/// SearchCrosswalk search2InfiniteTimes = Search2InfiniteTimes(repository);
///
/// // 외부 의존성 주입이 완료된 경우
/// SearchCrosswalk search2InfiniteTimes = DI.get<SearchCrosswalk>();
/// ```
///
/// 객체의 생성이 끝난 경우 아래의 방법으로 [call] 메소드를 호출한다.
/// 이때 argument는 [NoParams]이므로 아래와 같이 사용한다.
///
/// ```dart
/// search2InfiniteTimes(NoParams());
/// ```
///
/// 아래는 위 과정에 대한 전문이다.
/// ```dart
/// Search2InfiniteTimes search2InfiniteTimes = Search2InfiniteTimes(repository); // 비권장
/// SearchCrosswalk search2InfiniteTimes = Search2InfiniteTimes(repository); // 권장
/// SearchCrosswalk search2InfiniteTimes = DI.get<SearchCrosswalk>(); // Best Practice
///
/// search2InfiniteTimes(NoParams()); // call 메소드 호출
/// ```
class Search2InfiniteTimes implements SearchCrosswalk {
  /// [CrosswalkRepository] 객체를 담는 변수로서 외부에서 DI되어 사용된다.
  ///
  /// domain layer의 repository interface로 변수형을 선언([CrosswalkRepository])하고 실제 DI하는 값은
  /// data layer의 repository implements로 주입하여, 캡슐화한다.
  ///
  /// See also:
  ///  * DI에 대한 자세한 설명은 `injection.dart` 파일에서 확인할 수 있다.
  final CrosswalkRepository repository;

  /// Default constructor로서 의존성 주입을 위해 [repository]를 Argument로 반드시 받아야 한다.
  ///
  /// 아래와 같이 사용할 수 있다.
  /// ```dart
  /// Search2InfiniteTimes search2InfiniteTimes = Search2InfiniteTimes(repository); // 비권장
  /// SearchCrosswalk search2InfiniteTimes = Search2InfiniteTimes(repository); // 권장
  /// SearchCrosswalk search2InfiniteTimes = DI.get<SearchCrosswalk>(); // Best Practice
  /// ```
  Search2InfiniteTimes({required this.repository});

  @override
  Future<Either<Failure, List<Crosswalk>?>> call(NoParams params) async {
    return await repository.getCrosswalkInfiniteTimes();
  }
}

/// [SendAcousticSignal]는 비콘 포스트에 음성 유도 커맨드([0x31, 0x00, 0x02])를 보내는 비즈니스 로직이다.
///
/// 특정 횡단보도의 음성 유도에 사용되며, [call] 메소드를 통해 [CrosswalkRepository.sendCommand2Crosswalk]를 호출하여
/// 연결하고자 하는 신호등에 음성 유도 커맨드([0x31, 0x00, 0x02])를 보내게 된다.
///
/// 사용 시 [call]의 parameter에 [Crosswalk] 객체를 Argument로 넘겨주어야 한다.
///
/// [SendAcousticSignal]의 로직이 수행될 경우, 아래와 같이 결과가 반환된다.
///
/// |return||case|
/// |:-------|-|:--------|
/// |[Void]||비콘 포스트 연결 및 음성 유도 커맨드 발송 성공|
/// |[BlueFailure]||비콘 포스트 연결 및 음성 유도 커맨드 발송 실패|
///
/// ---
/// ## 주의할 점
/// [SendAcousticSignal] 로직은 블루투스 연결을 수행한다.
/// 따라서 `블루투스 권한 허가`가 선행되어야 한다.
///
/// 또한, 비콘 포스트와의 연결을 위해서는 주변 횡단보도의 스캔이 선행되어야 하므로 [Search2FiniteTimes]가 선행되어야 한다.
///
/// ---
/// ## Members
/// [SendAcousticSignal]의 member는 아래와 같다.
///
/// ### field
/// * [repository]
///
/// ### method
/// * [call]
///
/// ---
/// ## Example
/// [SendAcousticSignal]는 아래와 같이 직접 클래스를 생성하고 의존성을 주입하여 객체를 생성할 수 있다.
///
/// ```dart
/// SendAcousticSignal sendAcousticSignal = SendAcousticSignal(repository);
/// ```
///
/// 단, 아래와 같이 [SendAcousticSignal]의 super class인 [ConnectCrosswalk]을 변수형으로 선언하고, 되도록 외부에서 의존성을 주입하는 방식을 권장한다.
///
/// ```dart
/// // 변수형 ConnectCrosswalk 사용
/// ConnectCrosswalk sendAcousticSignal = SendAcousticSignal(repository);
///
/// // 외부 의존성 주입이 완료된 경우
/// ConnectCrosswalk sendAcousticSignal = DI.get<ConnectCrosswalk>();
/// ```
///
/// 객체의 생성이 끝난 경우 아래의 방법으로 [call] 메소드를 호출한다.
/// 이때 argument는 [Crosswalk]이므로 아래와 같이 사용한다.
///
/// ```dart
/// sendAcousticSignal(Crosswalk());
/// ```
///
/// 아래는 위 과정에 대한 전문이다.
/// ```dart
/// SendAcousticSignal sendAcousticSignal = SendAcousticSignal(repository); // 비권장
/// ConnectCrosswalk sendAcousticSignal = SendAcousticSignal(repository); // 권장
/// ConnectCrosswalk sendAcousticSignal = DI.get<ConnectCrosswalk>(); // Best Practice
///
/// sendAcousticSignal(Crosswalk()); // call 메소드 호출
/// ```
class SendAcousticSignal implements ConnectCrosswalk {
  /// 스마트 압버튼에 전송하는 음성 유도 커맨드이다.
  ///
  /// 해당 커맨드를 전송하여 시각장애인에게 현재 횡단보도의 위치를 알려주는 음성 유도 기능을 수행할 수 있다.
  /// [_command]의 값은 블루투스 압버튼의 데이터 통신과 관련된 경찰청 제공 프로토콜(2021년 개정)을 따른다.
  final List<int> _command = [0x31, 0x00, 0x02];

  /// [CrosswalkRepository] 객체를 담는 변수로서 외부에서 DI되어 사용된다.
  ///
  /// domain layer의 repository interface로 변수형을 선언([CrosswalkRepository])하고 실제 DI하는 값은
  /// data layer의 repository implements로 주입하여, 캡슐화한다.
  ///
  /// See also:
  ///  * DI에 대한 자세한 설명은 `injection.dart` 파일에서 확인할 수 있다.
  CrosswalkRepository repository;

  /// Default constructor로서 의존성 주입을 위해 [repository]를 Argument로 반드시 받아야 한다.
  ///
  /// 아래와 같이 사용할 수 있다.
  /// ```dart
  /// SendAcousticSignal sendAcousticSignal = SendAcousticSignal(repository); // 비권장
  /// ConnectCrosswalk sendAcousticSignal = SendAcousticSignal(repository); // 권장
  /// ConnectCrosswalk sendAcousticSignal = DI.get<ConnectCrosswalk>(); // Best Practice
  /// ```
  SendAcousticSignal({required this.repository});

  @override
  Future<Either<Failure, Void>> call(Crosswalk params) async {
    return await repository.sendCommand2Crosswalk(params, _command);
  }
}

/// [SendVoiceInductor]는 비콘 포스트에 압버튼 누르기 커맨드([0x31, 0x00, 0x01])를 보내는 비즈니스 로직이다.
///
/// 특정 횡단보도의 압버튼 누르기에 사용되며, [call] 메소드를 통해 [CrosswalkRepository.sendCommand2Crosswalk]를 호출하여
/// 연결하고자 하는 신호등에 압버튼 누르기 커맨드([0x31, 0x00, 0x01])를 보내게 된다.
///
/// 사용 시 [call]의 parameter에 [Crosswalk] 객체를 Argument로 넘겨주어야 한다.
///
/// [SendVoiceInductor]의 로직이 수행될 경우, 아래와 같이 결과가 반환된다.
///
/// |return||case|
/// |:-------|-|:--------|
/// |[Void]||비콘 포스트 연결 및 압버튼 누르기 커맨드 발송 성공|
/// |[BlueFailure]||비콘 포스트 연결 및 음성 유도 커맨드 발송 실패|
///
/// ---
/// ## 주의할 점
/// [SendVoiceInductor] 로직은 블루투스 연결을 수행한다.
/// 따라서 `블루투스 권한 허가`가 선행되어야 한다.
///
/// 또한, 비콘 포스트와의 연결을 위해서는 주변 횡단보도의 스캔이 선행되어야 하므로 [Search2FiniteTimes]가 선행되어야 한다.
///
/// ---
/// ## Members
/// [SendVoiceInductor]의 member는 아래와 같다.
///
/// ### field
/// * [repository]
///
/// ### method
/// * [call]
///
/// ---
/// ## Example
/// [SendVoiceInductor]는 아래와 같이 직접 클래스를 생성하고 의존성을 주입하여 객체를 생성할 수 있다.
///
/// ```dart
/// SendVoiceInductor sendVoiceInductor = SendVoiceInductor(repository);
/// ```
///
/// 단, 아래와 같이 [SendVoiceInductor]의 super class인 [ConnectCrosswalk]을 변수형으로 선언하고, 되도록 외부에서 의존성을 주입하는 방식을 권장한다.
///
/// ```dart
/// // 변수형 ConnectCrosswalk 사용
/// ConnectCrosswalk sendVoiceInductor = SendVoiceInductor(repository);
///
/// // 외부 의존성 주입이 완료된 경우
/// ConnectCrosswalk sendVoiceInductor = DI.get<ConnectCrosswalk>();
/// ```
///
/// 객체의 생성이 끝난 경우 아래의 방법으로 [call] 메소드를 호출한다.
/// 이때 argument는 [Crosswalk]이므로 아래와 같이 사용한다.
///
/// ```dart
/// sendVoiceInductor(Crosswalk());
/// ```
///
/// 아래는 위 과정에 대한 전문이다.
/// ```dart
/// SendVoiceInductor sendVoiceInductor = SendVoiceInductor(repository); // 비권장
/// ConnectCrosswalk sendVoiceInductor = SendVoiceInductor(repository); // 권장
/// ConnectCrosswalk sendVoiceInductor = DI.get<ConnectCrosswalk>(); // Best Practice
///
/// sendVoiceInductor(Crosswalk()); // call 메소드 호출
/// ```
class SendVoiceInductor implements ConnectCrosswalk {
  /// 스마트 압버튼에 전송하는 압버튼 누르기 커맨드이다.
  ///
  /// 해당 커맨드를 전송하여 시각장애인에게 현재 횡단보도의 압버튼을 누르는 압버튼 누르기 기능을 수행할 수 있다.
  /// [_command]의 값은 블루투스 압버튼의 데이터 통신과 관련된 경찰청 제공 프로토콜(2021년 개정)을 따른다.
  static const List<int> _command = [0x31, 0x00, 0x01];

  /// [CrosswalkRepository] 객체를 담는 변수로서 외부에서 DI되어 사용된다.
  ///
  /// domain layer의 repository interface로 변수형을 선언([CrosswalkRepository])하고 실제 DI하는 값은
  /// data layer의 repository implements로 주입하여, 캡슐화한다.
  ///
  /// See also:
  ///  * DI에 대한 자세한 설명은 `injection.dart` 파일에서 확인할 수 있다.
  CrosswalkRepository repository;

  /// Default constructor로서 의존성 주입을 위해 [repository]를 Argument로 반드시 받아야 한다.
  ///
  /// 아래와 같이 사용할 수 있다.
  /// ```dart
  /// SendVoiceInductor sendVoiceInductor = SendVoiceInductor(repository); // 비권장
  /// ConnectCrosswalk sendVoiceInductor = SendVoiceInductor(repository); // 권장
  /// ConnectCrosswalk sendVoiceInductor = DI.get<ConnectCrosswalk>(); // Best Practice
  /// ```
  SendVoiceInductor({required this.repository});

  @override
  Future<Either<Failure, Void>> call(Crosswalk params) async {
    return await repository.sendCommand2Crosswalk(params, _command);
  }
}
