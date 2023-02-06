import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../../domain/usecases/auth_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn signInAnonymously;
  final SignOut signOutAnonymously;

  AuthBloc({
    required this.signInAnonymously,
    required this.signOutAnonymously,
  }) : super(Done()) {
    on<SignInAnonymouslyEvent>(_signInAnonymouslyEvent);
    on<SignOutAnonymouslyEvent>(_signOutAnonymouslyEvent);
  }

  Future _signInAnonymouslyEvent(
    AuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(Loading());

      final result = await signInAnonymously(null);
      result.fold(
        (failure) {
          if (failure is ServerFailure) {
            emit(Error(message: '인터넷 연결 안됨'));
          }
        },
        (success) {
          emit(Done());
        },
      );
    } catch (e) {
      emit(Error(message: '로그인 실패, 다시 시도해주세요.'));
    }
  }

  Future _signOutAnonymouslyEvent(
    AuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(Loading());

      final result = await signOutAnonymously(NoParams());
      result.fold(
        (failure) {
          if (failure is ServerFailure) {
            emit(Error(message: '인터넷 연결 안됨'));
          }
        },
        (success) {
          emit(Done());
        },
      );
    } catch (e) {
      emit(Error(message: '로그아웃 실패, 다시 시도해주세요.'));
    }
  }
}
