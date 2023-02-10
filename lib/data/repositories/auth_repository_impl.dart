import 'package:dartz/dartz.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import '../sources/auth_remote_data_source.dart';

/// [AuthRepositoryImpl]는 [AuthRepository]의 구현부이다.
///
/// `sources` 폴더의 [AuthRemoteDataSource]를 사용하여 익명 로그인을 수행한다.
///
/// ---
/// ## Members
/// [AuthRepositoryImpl]의 member는 아래와 같다.
///
/// ### field
/// * [authDataSource]
///
/// ### method
/// * [signInAnonymously]
///   * [AuthRemoteDataSource.signInAnonymously]를 호출하여 익명 로그인을 수행한다.
///
/// * [signOutAnonymously]
///   * [AuthRemoteDataSource.signOutAnonymously]를 호출하여 익명 로그인을 수행한다.
/// ---
/// ## Example
/// [AuthRepositoryImpl]는 아래와 같이 [AuthRepository] 타입으로 객체를 생성해야 한다.
///
/// ```dart
/// AuthRepository repository = AuthRepositoryImpl(datasource);
/// ```
///
/// 또한 외부에서 의존성을 주입하여 객체를 생성하는 것을 권장한다.
///
/// ```dart
/// // 외부 의존성 주입이 완료된 경우
/// AuthRepository repository = DI.get<AuthRepository>();
/// ```
///
/// 객체의 생성이 끝난 경우 아래와 같이 메소드를 호출한다.
///
/// ```dart
/// repository.signInAnonymously(); // 익명 로그인
/// repository.signOutAnonymously(); // 익명 로그아웃
/// ```
///
/// 아래는 위 과정에 대한 전문이다.
///
/// ```dart
/// AuthRepository repository = AuthRepositoryImpl(datasource); // 권장
/// // 외부 의존성 주입이 완료된 경우
/// AuthRepository repository = DI.get<AuthRepository>(); // Best Practice
///
/// repository.signInAnonymously(); // 익명 로그인
/// repository.signOutAnonymously(); // 익명 로그아웃
/// ```
class AuthRepositoryImpl implements AuthRepository {
  /// [AuthRemoteDataSource] 객체를 담는 변수로서 외부에서 DI되어 사용된다.
  ///
  /// 변수형을 선언([AuthRemoteDataSource])하고 실제 DI하는 값은 [AuthRemoteDataSourceImpl] 객체로 주입한다.
  ///
  /// See also:
  ///  * DI에 대한 자세한 설명은 `injection.dart` 파일에서 확인할 수 있다.
  AuthRemoteDataSource authDataSource;

  /// Default constructor로서 의존성 주입을 위해 [authDataSource]를 Argument로 반드시 받아야 한다.
  ///
  /// 아래와 같이 사용할 수 있다.
  ///
  /// ```dart
  /// AuthRepository repository = AuthRepositoryImpl(datasource); // 권장
  /// // 외부 의존성 주입이 완료된 경우
  /// AuthRepository repository = DI.get<AuthRepository>(); // Best Practice
  /// ```
  AuthRepositoryImpl({required this.authDataSource});

  @override
  Future<Either<Failure, Void>> signInAnonymously() async {
    try {
      await authDataSource.signInAnonymously();
      return Right(Void());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Void>> signOutAnonymously() async {
    try {
      await authDataSource.signOutAnonymously();
      return Right(Void());
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
