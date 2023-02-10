import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/crosswalk.dart';

/// [CrosswalkRepository]는 횡단보도 검색/연결과 관련된 Repository이다.
///
/// `CrosswalkUseCase`의 비즈니스 로직들의 요청을 처리하고 요청에 따른 결과를 반환한다.
///
/// [CrosswalkRepository]는 Repository의 interface로서 캡슐화의 역할을 수행한다.
/// 이에 따라 [CrosswalkRepository]는 `lib/data/repositories/crosswalk_repository_impl.dart`의
/// `CrosswalkRepositoryImpl` 클래스를 통해 구현된다.
///
/// 이후, 객체 생성 시 [CrosswalkRepository] 타입으로 객체를 생성하여 Domain Layer 와 Data Layer를 연결한다.
///
/// ---
/// ## Functions
/// [CrosswalkRepository]는 요청에 따라 아래의 메소드를 호출하여 기능을 수행할 수 있다.
///
/// |기능||설명|
/// |:-------|-|:--------|
/// |[getCrosswalkFiniteTimes]||제한된 시간 동안 Bluetooth 스캔과 Firestore를 통한 주변 횡단보도 검색|
/// |[getCrosswalkInfiniteTimes]||Bluetooth 스캔/연결을 통한 자동 스캔-연결 및 데이터 송신(이하 자동스캔)|
/// |[sendCommand2Crosswalk]||Bluetooth 연결을 통한 횡단보도(비콘 포스트) 연결 및 데이터 송신|
abstract class CrosswalkRepository {
  /// [getCrosswalkFiniteTimes]는 제한된 시간 동안 주변 횡단보도 검색을 수행한다.
  ///
  /// [Either]로서 ([Failure], `List<Crosswalk>`)의 형태로 반환되며, 아래와 같이 결과가 반환된다.
  ///
  /// |return||case|
  /// |:-------|-|:--------|
  /// |`Right(List<Crosswalk>)`||횡단보도 검색 성공, 검색된 결과를 [List]로 반환|
  /// |`Left(BlueFailure())`||블루투스 스캔 실패로 인한 횡단보도 검색 실패|
  /// |`Left(ServerFailure())`||인터넷 연결 불안정으로 인한 횡단보도 정보 요청 실패|
  Future<Either<Failure, List<Crosswalk>>> getCrosswalkFiniteTimes();

  /// [getCrosswalkInfiniteTimes]는 주변 횡단보도 검색-연결(데이터 송신)을 수행한다.
  ///
  /// [Either]로서 ([Failure], `List<Crosswalk>?`)의 형태로 반환되며, 아래와 같이 결과가 반환된다.
  ///
  /// |return||case|
  /// |:-------|-|:--------|
  /// |`Right(null)`||횡단보도 스캔-연결(데이터 송신) 성공|
  /// |`Left(BlueFailure())`||블루투스 스캔/연결 실패|
  Future<Either<Failure, List<Crosswalk>?>> getCrosswalkInfiniteTimes();

  /// [sendCommand2Crosswalk]는 주변 횡단보도 연결(데이터 송신)을 수행한다.
  ///
  /// [crosswalk] parameter를 통해 연결하고자 하는 횡단보도([Crosswalk])를 argument로 받아야 한다.
  /// 또한, 전송하고자 하는 커맨드를 [command] parameter를 통해 받아야 한다.
  ///
  /// [Either]로서 ([Failure], `List<Crosswalk>?`)의 형태로 반환되며, 아래와 같이 결과가 반환된다.
  ///
  /// |return||case|
  /// |:-------|-|:--------|
  /// |`Right(null)`||횡단보도 스캔-연결(데이터 송신) 성공|
  /// |`Left(BlueFailure())`||블루투스 스캔/연결 실패|
  Future<Either<Failure, Void>> sendCommand2Crosswalk(
    Crosswalk crosswalk,
    List<int> command,
  );
}
