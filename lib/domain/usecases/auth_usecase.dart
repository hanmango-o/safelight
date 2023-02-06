import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// [AuthUseCase]는 사용자의 인증 상태를 제어하는 모든 [UseCase] 로직들의 super class이다.
///
/// 시스템을 사용하는 사용자는 [AuthUseCase]에 정의된 형태로 인증을 받아야 한다.
/// 즉, 로그인/로그아웃 또는 그 외의 모든 인증과 관련된 비즈니스 로직은 [AuthUseCase]의 자식 형태로 구현되어야 하며
/// [AuthUseCase]는 모든 인증 체계의 super class로서 위치해야 한다.
///
/// ---
/// ### Authentication
/// 시스템의 사용자 인증과 관련된 모든 것을 의미한다.
/// 큰 범위에서 로그인, 로그아웃으로 구분되어 있다.
///
/// *로그인/로그아웃 외에 다른 Auth 서비스가 필요한 경우 [AuthUseCase]를 상속받는 구조로 추가할 수 있다.*
///
/// [AuthUseCase]는 크게 아래의 비즈니스 카테고리를 가지고 있다.
///
/// #### 1. [SignIn]
/// 로그인 관련 비즈니스 로직의 super class이다.
///
/// #### 2. [SignOut]
/// 로그아웃 관련 비즈니스 로직의 super class이다.
///
/// ---
/// ### 주의할 점
/// [AuthUseCase]는 실질적인 비즈니스 로직으로서 사용되지 않는다.
///
/// 익명 로그인, 익명 로그아웃과 같은 실질적인(details) 비즈니스 로직들의 최상단 클래스로서
/// 이러한 비즈니스 로직들이 사용자의 인증(Authetication)과 관련되어 있다는 것을 알려주는 역할만을 수행한다.
///
/// 이후 구현이 필요한 비즈니스 로직이 사용자의 인증(Authentication)과 관련되어 있다면, [AuthUseCase]의 sub class로 배치되어야 한다.
abstract class AuthUseCase {}

/// [SignIn]은 [UseCase]로서, 모든 로그인 로직들의 super class이다.
///
/// 로그인 관련 모든 비즈니스 로직은 [SignIn]의 sub class로 구현되어야 한다.
/// [SignIn]이 포함하고 있는 비즈니스 로직은 아래와 같다.
///
/// * [SignInAnonymously]
///   * 익명 로그인 비즈니스 로직이다.
///
/// ---
/// ### 주의할 점
/// [SignIn]은 실질적인 비즈니스 로직으로서 사용되지 않는다.
///
/// 로그인 관련 비즈니스 로직들의 super class로서 이러한 비즈니스 로직들이
/// 사용자 로그인과 관련되어 있는 것을 알려주는 역할만을 수행한다.
///
/// 이후 구현이 필요한 로그인 관련 비즈니스 로직은 [SignIn]의 sub class로 배치되어야 한다.
///
/// ---
/// ### UseCase
/// [SignIn]의 sub class들은 [UseCase]의 [call] 메소드를 구현(implements)해야 한다.
/// 이때, [call] 메소드의 Parameter와 Return Type은 아래와 같다.
///
/// #### Parameter
/// 사용자의 정보를 담은 [Map]의 형태를 Parameter로 가진다.
///
/// `Map<String, dynamic>?`의 형태로 전달받은 데이터는
/// 해당 로그인 로직에 필요한 데이터(ex. id, pw)를 포함하고 있어야 하며,
///
/// 필요에 따라 [User] 객체로 변환하는 과정이 포함되어야 한다.
///
/// #### Return Type
/// [Either]로서 ([Failure], [Void])의 형태로 반환된다.
///
/// |Case|Type|
/// |:-------|:--------|
/// |실패할 경우|[Failure]|
/// |성공할 경우|[Void]|
abstract class SignIn extends AuthUseCase
    implements UseCase<Void, Map<String, dynamic>?> {}

/// [SignOut]은 [UseCase]로서, 모든 로그아웃 로직들의 super class이다.
///
/// 로그아웃 관련 모든 비즈니스 로직은 [SignOut]의 sub class로 구현되어야 한다.
/// [SignOut]이 포함하고 있는 비즈니스 로직은 아래와 같다.
///
/// * [SignOutAnonymously]
///   * 익명 로그아웃 비즈니스 로직이다.
///
/// ---
/// ### 주의할 점
/// [SignOut]은 실질적인 비즈니스 로직으로서 사용되지 않는다.
///
/// 로그아웃 관련 비즈니스 로직들의 super class로서 이러한 비즈니스 로직들이
/// 사용자 로그아웃과 관련되어 있는 것을 알려주는 역할만을 수행한다.
///
/// 이후 구현이 필요한 로그아웃 관련 비즈니스 로직은 [SignOut]의 sub class로 배치되어야 한다.
///
/// ---
/// ### UseCase
/// [SignOut]의 sub class들은 [UseCase]의 [call] 메소드를 구현(implements)해야 한다.
/// 이때, [call] 메소드의 Parameter와 Return Type은 아래와 같다.
///
/// #### Parameter
/// [NoParams]로서 할당 받는 값이 없다.
///
/// #### Return Type
/// [Either]로서 ([Failure], [Void])의 형태로 반환된다.
///
/// |Case|Type|
/// |:-------|:--------|
/// |실패할 경우|[Failure]|
/// |성공할 경우|[Void]|
abstract class SignOut extends AuthUseCase implements UseCase<Void, NoParams> {}

/// [SignInAnonymously]는 익명 로그인 비즈니스 로직이다.
///
///
/// ---
/// ### Members
/// [SignInAnonymously]의 member는 아래와 같다.
///
/// #### Field
/// *
///
/// #### Method
class SignInAnonymously implements SignIn {
  AuthRepository repository;

  SignInAnonymously({required this.repository});

  @override
  Future<Either<Failure, Void>> call(Map<String, dynamic>? user) async {
    return await repository.signInAnonymously();
  }
}

class SignOutAnonymously implements SignOut {
  AuthRepository repository;

  SignOutAnonymously({required this.repository});

  @override
  Future<Either<Failure, Void>> call(NoParams params) async {
    return await repository.signOutAnonymously();
  }
}
