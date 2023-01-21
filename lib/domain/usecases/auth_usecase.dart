import 'package:safelight/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:safelight/core/usecases/usecase.dart';
import 'package:safelight/domain/repositories/auth_repository.dart';

abstract class AuthUseCase implements UseCase<Void, NoParams> {}

abstract class SignIn extends AuthUseCase {}

abstract class SignOut extends AuthUseCase {}

class SignInAnonymously implements SignIn {
  AuthRepository repository;

  SignInAnonymously({required this.repository});

  @override
  Future<Either<Failure, Void>> call(NoParams params) async {
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
