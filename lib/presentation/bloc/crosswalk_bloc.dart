import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:safelight/core/errors/failures.dart';
import 'package:safelight/core/usecases/usecase.dart';
import 'package:safelight/domain/usecases/crosswalk_usecase.dart';
import 'package:safelight/domain/usecases/nav_usecase.dart';
import 'package:safelight/injection.dart';
import 'package:safelight/presentation/bloc/crosswalk_event.dart';
import 'package:safelight/presentation/bloc/crosswalk_state.dart';

class CrosswalkBloc extends Bloc<CrosswalkEvent, CrosswalkState> {
  final SearchCrosswalk searchCrosswalk;
  final ConnectCrosswalk sendAcousticSignal;
  final ConnectCrosswalk sendVoiceInductor;
  final GetCurrentPosition getCurrentPosition;

  CrosswalkBloc({
    required this.searchCrosswalk,
    required this.sendAcousticSignal,
    required this.sendVoiceInductor,
    required this.getCurrentPosition,
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

      DI.get<FlutterTts>().speak('${event.crosswalk.name}의 스마트 압버튼에 연결합니다.');
      final results = await sendAcousticSignal(event.crosswalk);
      await results.fold(
        (failure) {
          if (failure is BlueFailure) {
            emit(Error(message: '스마트 압버튼 연결 실패'));
          }
        },
        (success) async {
          bool enableCompass = false;
          if (event.crosswalk.pos != null) {
            final results = await getCurrentPosition(NoParams());
            results.fold(
              (failure) {
                DI.get<FlutterTts>().speak(
                    '${event.crosswalk.name}의 스마트 압버튼에 연결되었습니다. 보행자 신호에 주의하여 보행하세요.');

                emit(Done(enableCompass: enableCompass));
              },
              (latLng) {
                DI.get<FlutterTts>().speak(
                    '${event.crosswalk.name}의 스마트 압버튼에 연결되었습니다. 보행자 신호에 주의하여 진동이 울리지 않는 방향으로 보행하세요.');

                enableCompass = true;
                emit(Done(enableCompass: enableCompass, latLng: latLng));
              },
            );
          } else {
            DI.get<FlutterTts>().speak(
                '${event.crosswalk.name}의 스마트 압버튼에 연결되었습니다. 보행자 신호에 주의하여 보행하세요.');

            emit(Done(enableCompass: enableCompass));
          }
        },
      );
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
      DI.get<FlutterTts>().speak('${event.crosswalk.name}의 스마트 압버튼에 연결합니다.');
      final results = await sendVoiceInductor(event.crosswalk);
      await results.fold(
        (failure) {
          if (failure is BlueFailure) {
            emit(Error(message: 'connect failure'));
          }
        },
        (success) async {
          bool enableCompass = false;
          if (event.crosswalk.pos != null) {
            final results = await getCurrentPosition(NoParams());
            results.fold(
              (failure) {
                DI.get<FlutterTts>().speak(
                    '${event.crosswalk.name}의 스마트 압버튼에 연결되었습니다. 보행자 신호에 주의하여 보행하세요.');
                emit(Done(enableCompass: enableCompass));
              },
              (latLng) {
                DI.get<FlutterTts>().speak(
                    '${event.crosswalk.name}의 스마트 압버튼에 연결되었습니다. 보행자 신호에 주의하여 진동이 울리지 않는 방향으로 보행하세요.');

                enableCompass = true;
                emit(Done(enableCompass: enableCompass, latLng: latLng));
              },
            );
          } else {
            DI.get<FlutterTts>().speak(
                '${event.crosswalk.name}의 스마트 압버튼에 연결되었습니다. 보행자 신호에 주의하여 보행하세요.');

            emit(Done(enableCompass: enableCompass));
          }
        },
      );
    } catch (e) {
      emit(Error(message: 'connect failure'));
    }
  }
}
