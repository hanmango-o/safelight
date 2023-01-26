import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:safelight/core/errors/failures.dart';
import 'package:safelight/core/usecases/usecase.dart';
import 'package:safelight/domain/usecases/crosswalk_usecase.dart';
import 'package:safelight/domain/usecases/nav_usecase.dart';
import 'package:safelight/domain/usecases/service_usecase.dart';
import 'package:safelight/injection.dart';
import 'package:safelight/presentation/bloc/crosswalk_event.dart';
import 'package:safelight/presentation/bloc/crosswalk_state.dart';

class CrosswalkBloc extends Bloc<CrosswalkEvent, CrosswalkState> {
  static Timer timer = Timer(Duration.zero, () {});
  final SearchCrosswalk searchCrosswalk;
  final ConnectCrosswalk sendAcousticSignal;
  final ConnectCrosswalk sendVoiceInductor;
  final GetCurrentPosition getCurrentPosition;
  final ControlFlash controlFlash;

  CrosswalkBloc({
    required this.searchCrosswalk,
    required this.sendAcousticSignal,
    required this.sendVoiceInductor,
    required this.getCurrentPosition,
    required this.controlFlash,
  }) : super(Off(results: const [])) {
    on<SearchFiniteCrosswalkEvent>(_searchFiniteCrosswalkEvent);
    on<SendAcousticSignalEvent>(_sendAcousticSignalEvent);
    on<SendVoiceInductorEvent>(_sendVoiceInductorEvent);
  }

  Future _searchFiniteCrosswalkEvent(
    SearchFiniteCrosswalkEvent event,
    Emitter<CrosswalkState> emit,
  ) async {
    try {
      timer.cancel();
      emit(On());

      final results = await searchCrosswalk(NoParams());
      results.fold(
        (failure) {
          if (failure is BlueFailure) {
            emit(Error(message: '블루투스 스캔 실패, 다시 시도해주세요.'));
          } else if (failure is ServerFailure) {
            emit(Error(message: '앱 내 블루투스와 위치 권한을 확인해주세요.'));
          }
        },
        (results) {
          DI.get<FlutterTts>().speak('${results.length} 개의 스마트 압버튼을 찾았습니다.');
          emit(Off(results: results));
        },
      );
    } catch (e) {
      emit(Error(message: '블루투스 스캔 실패, 다시 시도해주세요.'));
    }
  }

  Future _sendAcousticSignalEvent(
    SendAcousticSignalEvent event,
    Emitter<CrosswalkState> emit,
  ) async {
    try {
      emit(Connect());
      await controlFlash(NoParams());
      if (event.crosswalk.pos != null) {
        final results = await getCurrentPosition(NoParams());
        results.fold(
          (failure) {
            emit(Done(enableCompass: false));
          },
          (latLng) async {
            emit(Done(enableCompass: true, latLng: latLng));
          },
        );
      } else {
        emit(Done(enableCompass: false));
      }

      timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (timer.tick == 10) {
          timer.cancel();
        }
        final results = await sendAcousticSignal(event.crosswalk);
        if (results.isLeft()) {
          timer.cancel();
          emit(Error(message: '스마트 압버튼 연결 실패'));
        }
      });
    } catch (e) {
      emit(Error(message: 'connect failure'));
    }
  }

  Future _sendVoiceInductorEvent(
    SendVoiceInductorEvent event,
    Emitter<CrosswalkState> emit,
  ) async {
    try {
      emit(Connect());

      if (event.crosswalk.pos != null) {
        final results = await getCurrentPosition(NoParams());
        results.fold(
          (failure) {
            emit(Done(enableCompass: false));
          },
          (latLng) async {
            emit(Done(enableCompass: true, latLng: latLng));
          },
        );
      } else {
        emit(Done(enableCompass: false));
      }

      timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (timer.tick == 10) {
          timer.cancel();
        }
        final results = await sendVoiceInductor(event.crosswalk);
        if (results.isLeft()) {
          timer.cancel();
          emit(Error(message: '스마트 압버튼 연결 실패'));
        }
      });
    } catch (e) {
      emit(Error(message: 'connect failure'));
    }
  }
}
