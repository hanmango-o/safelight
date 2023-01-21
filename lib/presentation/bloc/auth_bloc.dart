import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safelight/core/errors/failures.dart';
import 'package:safelight/core/usecases/usecase.dart';
import 'package:safelight/domain/usecases/auth_usecase.dart';
import 'package:safelight/presentation/bloc/auth_event.dart';
import 'package:safelight/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCase signIn;
  final AuthUseCase signOut;

  AuthBloc({
    required this.signIn,
    required this.signOut,
  }) : super(Wait()) {
    on<SignInAnonymouslyEvent>(_signInAnonymouslyEvent);
    on<SignOutAnonymouslyEvent>(_signOutAnonymouslyEvent);
  }

  Future _signInAnonymouslyEvent(
    AuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(Loading());

      final result = await signIn(NoParams());
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

      final result = await signOut(NoParams());
      result.fold(
        (failure) {
          log('faile');
          if (failure is ServerFailure) {
            log('dd');
            emit(Error(message: '인터넷 연결 안됨'));
          }
        },
        (success) {
          log('dddd');
          emit(Done());
        },
      );
    } catch (e) {
      emit(Error(message: '로그아웃 실패, 다시 시도해주세요.'));
    }
  }
}
