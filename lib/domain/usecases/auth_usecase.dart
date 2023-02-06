import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

abstract class AuthUseCase {}

abstract class SignIn extends AuthUseCase
    implements UseCase<Void, Map<String, dynamic>?> {}

abstract class SignOut extends AuthUseCase implements UseCase<Void, NoParams> {}

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
