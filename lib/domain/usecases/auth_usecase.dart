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
/// ## Authentication
/// 시스템의 사용자 인증과 관련된 모든 것을 의미한다.
/// 큰 범위에서 로그인, 로그아웃으로 구분되어 있다.
///
/// ---
/// ## Service
/// [AuthUseCase]는 아래의 Auth 서비스를 가지고 있다.
///
/// * *로그인/로그아웃 외에 다른 Auth 서비스가 필요한 경우 [AuthUseCase]를 상속받는 구조로 추가할 수 있다.*
///
/// |service||설명|
/// |:-------|-|:--------|
/// |[SignIn]||로그인 관련 비즈니스 로직의 super class|
/// |[SignOut]||로그아웃 관련 비즈니스 로직의 super class|
///
/// ---
/// ## 주의할 점
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
/// |sub class||설명|
/// |:-------|-|:--------|
/// |[SignInAnonymously]||익명 로그인 비즈니스 로직|
///
/// ---
/// ## 주의할 점
/// [SignIn]은 실질적인 비즈니스 로직으로서 사용되지 않는다.
///
/// 로그인 관련 비즈니스 로직들의 super class로서 이러한 비즈니스 로직들이
/// 사용자 로그인과 관련되어 있는 것을 알려주는 역할만을 수행한다.
///
/// 이후 구현이 필요한 로그인 관련 비즈니스 로직은 [SignIn]의 sub class로 배치되어야 한다.
///
/// 또한, [SignIn]은 사용자가 로그아웃 상태일 경우에 사용해야 한다.
/// 만약 사용자가 로그아웃 상태가 아니라면 [SignOut]의 비즈니스 로직이 선행되어야 한다.
///
/// ---
/// ## UseCase
/// [SignIn]의 sub class들은 [UseCase]의 [call] 메소드를 구현(implements)해야 한다.
/// 이때, [call] 메소드의 Parameter와 Return Type은 아래와 같다.
///
/// ### Parameter
/// 사용자의 정보를 담은 [Map]의 형태를 Parameter로 가진다.
///
/// `Map<String, dynamic>?`의 형태로 전달받은 데이터는
/// 해당 로그인 로직에 필요한 데이터(ex. id, pw)를 포함하고 있어야 하며,
///
/// 필요에 따라 [User] 객체로 변환하는 과정이 수행되어야 한다.
///
/// ### Return Type
/// [Either]로서 ([Failure], [Void])의 형태로 반환된다.
///
/// |return||case|
/// |:-------|-|:--------|
/// |[Void]||로그인에 성공하는 경우|
/// |[Failure]||로그인에 실패하는 경우|
abstract class SignIn extends AuthUseCase
    implements UseCase<Void, Map<String, dynamic>?> {}

/// [SignOut]은 [UseCase]로서, 모든 로그아웃 로직들의 super class이다.
///
/// 로그아웃 관련 모든 비즈니스 로직은 [SignOut]의 sub class로 구현되어야 한다.
/// [SignOut]이 포함하고 있는 비즈니스 로직은 아래와 같다.
///
/// |sub class||설명|
/// |:-------|-|:--------|
/// |[SignOutAnonymously]||익명 로그아웃 비즈니스 로직|
///
/// ---
/// ## 주의할 점
/// [SignOut]은 실질적인 비즈니스 로직으로서 사용되지 않는다.
///
/// 로그아웃 관련 비즈니스 로직들의 super class로서 이러한 비즈니스 로직들이
/// 사용자 로그아웃과 관련되어 있는 것을 알려주는 역할만을 수행한다.
///
/// 이후 구현이 필요한 로그아웃 관련 비즈니스 로직은 [SignOut]의 sub class로 배치되어야 한다.
///
/// 또한, [SignOut]은 사용자가 로그인 상태일 경우에 사용해야 한다.
///
/// ---
/// ## UseCase
/// [SignOut]의 sub class들은 [UseCase]의 [call] 메소드를 구현(implements)해야 한다.
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
/// |[Void]||로그아웃에 성공하는 경우|
/// |[Failure]||로그아웃에 실패하는 경우|
abstract class SignOut extends AuthUseCase implements UseCase<Void, NoParams> {}

/// [SignInAnonymously]는 익명 로그인 비즈니스 로직이다.
///
/// 사용자가 익명으로 로그인 할 시 사용되며, [call] 메소드를 통해 [AuthRepository.signInAnonymously]를 호출하여 익명 로그인을 시도한다.
///
/// 익명 로그인의 경우 사용자 정보가 필요하지 않으므로, 사용 시 [call]의 `user` Parameter에 `null`을 Argument로 넘겨야 한다.
///
/// [SignInAnonymously]의 로직이 수행될 경우, 아래와 같이 결과가 반환된다.
///
/// |return||case|
/// |:-------|-|:--------|
/// |[Void]||익명 로그인 성공|
/// |[ServerFailure]||인터넷 연결 불안정으로 인한 로그인 실패|
///
/// ---
/// ## 주의할 점
/// [SignInAnonymously]은 [SignIn]에 속하기 때문에 사용자가 로그아웃된 상태에서만 사용되어야 한다.
///
/// * 자세한 사항은 `SignIn > 주의할 점`을 참고
///
/// ---
/// ## Members
/// [SignInAnonymously]의 member는 아래와 같다.
///
/// ### field
/// * [repository]
///
/// ### method
/// * [call]
///
/// ---
/// ## Example
/// [SignInAnonymously]는 아래와 같이 직접 클래스를 생성하고 의존성을 주입하여 객체를 생성할 수 있다.
///
/// ```dart
/// SignInAnonymously signInAnonymously = SignInAnonymously(repository);
/// ```
///
/// 단, 아래와 같이 [SignInAnonymously]의 super class인 [SignIn]을 변수형으로 선언하고, 되도록 외부에서 의존성을 주입하는 방식을 권장한다.
///
/// ```dart
/// // 변수형 SignIn 사용
/// SignIn signInAnonymously = SignInAnonymously(repository);
///
/// // 외부 의존성 주입이 완료된 경우
/// SignIn signInAnonymously = DI.get<SignIn>();
/// ```
///
/// 객체의 생성이 끝난 경우 아래의 방법으로 [call] 메소드를 호출한다.
/// 이때 argument로 [Map]을 넘겨주어야 하지만, [SignInAnonymously]의 경우 익명 로그인이므로 `null`을 넘겨준다.
///
/// ```dart
/// signInAnonymously(null);
/// ```
///
/// 아래는 위 과정에 대한 전문이다.
/// ```dart
/// SignInAnonymously signInAnonymously = SignInAnonymously(repository); // 비권장
/// SignIn signInAnonymously = SignInAnonymously(repository); // 권장
/// SignIn signInAnonymously = DI.get<SignIn>(); // Best Practice
///
/// signInAnonymously(null); // call 메소드 호출
/// ```
class SignInAnonymously implements SignIn {
  /// [AuthRepository] 객체를 담는 변수로서 외부에서 DI되어 사용된다.
  ///
  /// domain layer의 repository interface로 변수형을 선언([AuthRepository])하고 실제 DI하는 값은
  /// data layer의 repository implements로 주입하여, 캡슐화한다.
  ///
  /// See also:
  ///  * DI에 대한 자세한 설명은 `injection.dart` 파일에서 확인할 수 있다.
  AuthRepository repository;

  /// Default constructor로서 의존성 주입을 위해 [repository]를 Argument로 반드시 받아야 한다.
  ///
  /// 아래와 같이 사용할 수 있다.
  /// ```dart
  /// SignInAnonymously signInAnonymously = SignInAnonymously(repository); // 비권장
  /// SignIn signInAnonymously = SignInAnonymously(repository); // 권장
  /// SignIn signInAnonymously = DI.get<SignIn>(); // Best Practice
  /// ```
  SignInAnonymously({required this.repository});

  @override
  Future<Either<Failure, Void>> call(Map<String, dynamic>? user) async {
    return await repository.signInAnonymously();
  }
}

/// [SignOutAnonymously]는 익명 로그아웃 비즈니스 로직이다.
///
/// 사용자가 익명으로 로그아웃 할 시 사용되며, [call] 메소드를 통해 [AuthRepository.signOutAnonymously]를 호출하여 익명 로그아웃을 시도한다.
///
/// 사용 시 [call]의 parameter에 [NoParams] 객체를 Argument로 넘겨주어야 한다.
///
/// [SignOutAnonymously]의 로직이 수행될 경우, 아래와 같이 결과가 반환된다.
///
/// |return||case|
/// |:-------|-|:--------|
/// |[Void]||익명 로그아웃 성공|
/// |[ServerFailure]||인터넷 연결 불안정으로 인한 로그아웃 실패|
///
/// ---
/// ## 주의할 점
/// [SignOutAnonymously]은 [SignOut]에 속하기 때문에 사용자가 로그인된 상태에서만 사용되어야 한다.
///
/// ---
/// ## Members
/// [SignOutAnonymously]의 member는 아래와 같다.
///
/// ### field
/// * [repository]
///
/// ### method
/// * [call]
///
/// ---
/// ## Example
/// [SignOutAnonymously]는 아래와 같이 직접 클래스를 생성하고 의존성을 주입하여 객체를 생성할 수 있다.
///
/// ```dart
/// SignOutAnonymously signOutAnonymously = SignOutAnonymously(repository);
/// ```
///
/// 단, 아래와 같이 [SignOutAnonymously]의 super class인 [SignOut]을 변수형으로 선언하고, 되도록 외부에서 의존성을 주입하는 방식을 권장한다.
///
/// ```dart
/// // 변수형 SignOut 사용
/// SignOut signOutAnonymously = SignOutAnonymously(repository);
///
/// // 외부 의존성 주입이 완료된 경우
/// SignOut signOutAnonymously = DI.get<SignOut>();
/// ```
///
/// 객체의 생성이 끝난 경우 아래의 방법으로 [call] 메소드를 호출한다.
/// 이때 argument로 [NoParams]를 넘겨준다.
///
/// ```dart
/// signOutAnonymously(NoParams());
/// ```
///
/// 아래는 위 과정에 대한 전문이다.
/// ```dart
/// SignOutAnonymously signOutAnonymously = SignOutAnonymously(repository); // 비권장
/// SignOut signOutAnonymously = SignOutAnonymously(repository); // 권장
/// SignOut signOutAnonymously = DI.get<SignOut>(); // Best Practice
///
/// signOutAnonymously(NoParams()); // call 메소드 호출
/// ```
class SignOutAnonymously implements SignOut {
  /// [AuthRepository] 객체를 담는 변수로서 외부에서 DI되어 사용된다.
  ///
  /// domain layer의 repository interface로 변수형을 선언([AuthRepository])하고 실제 DI하는 값은
  /// data layer의 repository implements로 주입하여, 캡슐화한다.
  ///
  /// See also:
  ///  * DI에 대한 자세한 설명은 `injection.dart` 파일에서 확인할 수 있다.
  AuthRepository repository;

  /// Default constructor로서 의존성 주입을 위해 [repository]를 Argument로 반드시 받아야 한다.
  ///
  /// 아래와 같이 사용할 수 있다.
  /// ```dart
  /// SignOutAnonymously signOutAnonymously = SignOutAnonymously(repository); // 비권장
  /// SignOut signOutAnonymously = SignOutAnonymously(repository); // 권장
  /// SignOut signOutAnonymously = DI.get<SignOut>(); // Best Practice
  /// ```
  SignOutAnonymously({required this.repository});

  @override
  Future<Either<Failure, Void>> call(NoParams params) async {
    return await repository.signOutAnonymously();
  }
}
