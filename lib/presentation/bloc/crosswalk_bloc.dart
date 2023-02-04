import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safelight/core/errors/failures.dart';
import 'package:safelight/core/usecases/usecase.dart';
import 'package:safelight/core/utils/tts.dart';
import 'package:safelight/domain/entities/crosswalk.dart';
import 'package:safelight/domain/usecases/crosswalk_usecase.dart';
import 'package:safelight/domain/usecases/nav_usecase.dart';
import 'package:safelight/domain/usecases/service_usecase.dart';
import 'package:safelight/injection.dart';
import 'package:safelight/presentation/bloc/crosswalk_event.dart';
import 'package:safelight/presentation/bloc/crosswalk_state.dart';

class CrosswalkBloc extends Bloc<CrosswalkEvent, CrosswalkState> {
  static Timer timer = Timer(Duration.zero, () {});
  final tts = DI.get<TTS>();
  final SearchCrosswalk search2FiniteTimes;
  final SearchCrosswalk search2InfiniteTimes;
  final ConnectCrosswalk sendAcousticSignal;
  final ConnectCrosswalk sendVoiceInductor;
  final GetCurrentPosition getCurrentPosition;
  final ControlFlash controlFlash;

  CrosswalkBloc({
    required this.search2FiniteTimes,
    required this.search2InfiniteTimes,
    required this.sendAcousticSignal,
    required this.sendVoiceInductor,
    required this.getCurrentPosition,
    required this.controlFlash,
  }) : super(Off(results: const [])) {
    on<SearchFiniteCrosswalkEvent>(_searchFiniteCrosswalkEvent);
    on<SearchInfiniteCrosswalkEvent>(_searchInfiniteCrosswalkEvent);
    on<SendAcousticSignalEvent>(_sendAcousticSignalEvent);
    on<SendVoiceInductorEvent>(_sendVoiceInductorEvent);
  }

  Future _searchInfiniteCrosswalkEvent(
    SearchInfiniteCrosswalkEvent event,
    Emitter<CrosswalkState> emit,
  ) async {
    tts('자동 스캔이 시작됩니다.');
    timer.cancel();
    emit(On(infinite: true));
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      await search2InfiniteTimes(NoParams());
    });
  }

  Future _searchFiniteCrosswalkEvent(
    SearchFiniteCrosswalkEvent event,
    Emitter<CrosswalkState> emit,
  ) async {
    try {
      timer.cancel();
      emit(On());

      final results = await search2FiniteTimes(NoParams());

      results.fold(
        (failure) {
          if (failure is BlueFailure) {
            emit(Error(message: '블루투스 스캔 실패, 다시 시도해주세요.'));
          } else if (failure is ServerFailure) {
            emit(Error(message: '앱 내 블루투스와 위치 권한을 확인해주세요.'));
          }
        },
        (results) {
          results = results as List<Crosswalk>;
          tts('${results.length} 개의 스마트 압버튼을 찾았습니다.');
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
      tts('${event.crosswalk.name}에 연결합니다.');
      emit(Connect());
      // Block
      await controlFlash(NoParams());
      if (event.crosswalk.pos != null) {
        final results = await getCurrentPosition(NoParams());
        results.fold(
          (failure) {
            emit(Done(enableCompass: false));
          },
          (latLng) async {
            tts('진동이 울리지 않는 방향으로 보행하세요.');
            emit(Done(enableCompass: true, latLng: latLng));
          },
        );
      } else {
        emit(Done(enableCompass: false));
      }

      timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        final results = await sendAcousticSignal(event.crosswalk);
        if (results.isLeft()) {
          emit(Error(message: '스마트 압버튼 연결 실패'));
          timer.cancel();
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
      tts('${event.crosswalk.name}에 연결합니다.');
      emit(Connect());
      await controlFlash(NoParams());
      if (event.crosswalk.pos != null) {
        final results = await getCurrentPosition(NoParams());
        results.fold(
          (failure) {
            emit(Done(enableCompass: false));
          },
          (latLng) async {
            tts('진동이 울리지 않는 방향으로 보행하세요.');
            emit(Done(enableCompass: true, latLng: latLng));
          },
        );
      } else {
        emit(Done(enableCompass: false));
      }

      timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        final results = await sendVoiceInductor(event.crosswalk);
        if (results.isLeft()) {
          emit(Error(message: '스마트 압버튼 연결 실패'));
          timer.cancel();
        }
      });
    } catch (e) {
      emit(Error(message: 'connect failure'));
    }
  }
}
