import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';

/// [AuthRepository]는 사용자 인증(로그인/로그아웃)과 관련된 Repository이다.
///
/// `AuthUseCase`의 비즈니스 로직들의 요청을 처리하고 요청에 따른 결과를 반환한다.
///
/// [AuthRepository]는 Repository의 interface로서 캡슐화의 역할을 수행한다.
/// 이에 따라 [AuthRepository]는 `lib/data/repositories/auth_repository_impl.dart`의
/// `AuthRepositoryImpl` 클래스를 통해 구현된다.
///
/// 이후, 객체 생성 시 [AuthRepository] 타입으로 객체를 생성하여 Domain Layer 와 Data Layer를 연결한다.
///
/// ---
/// ## Functions
/// [AuthRepository]는 요청에 따라 아래의 메소드를 호출하여 기능을 수행할 수 있다.
///
/// |기능||설명|
/// |:-------|-|:--------|
/// |[signInAnonymously]||FirebaseAuth를 통한 익명 로그인|
/// |[signOutAnonymously]||FirebaseAuth를 통한 익명 로그아웃|
abstract class AuthRepository {
  /// [signInAnonymously]는 익명 로그인을 수행한다.
  ///
  /// [Either]로서 ([Failure], [Void])의 형태로 반환되며, 경우에 따라 아래와 같이 결과가 반환된다.
  ///
  /// |return||case|
  /// |:-------|-|:--------|
  /// |`Right(Void())`||익명 로그인 성공|
  /// |`Left(ServerFailure())`||인터넷 연결 불안정으로 인한 로그인 실패|
  Future<Either<Failure, Void>> signInAnonymously();

  /// [signOutAnonymously]는 익명 로그아웃을 수행한다.
  ///
  /// [Either]로서 ([Failure], [Void])의 형태로 반환되며, 아래와 같이 결과가 반환된다.
  ///
  /// |return||case|
  /// |:-------|-|:--------|
  /// |`Right(Void())`||익명 로그아웃 성공|
  /// |`Left(ServerFailure())`||인터넷 연결 불안정으로 인한 로그아웃 실패|
  Future<Either<Failure, Void>> signOutAnonymously();
}
