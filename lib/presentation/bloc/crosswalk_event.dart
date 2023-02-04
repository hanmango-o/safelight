import 'package:equatable/equatable.dart';
import 'package:safelight/domain/entities/crosswalk.dart';

abstract class CrosswalkEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchFiniteCrosswalkEvent extends CrosswalkEvent {}

class SearchInfiniteCrosswalkEvent extends CrosswalkEvent {}

class SendAcousticSignalEvent extends CrosswalkEvent {
  final Crosswalk crosswalk;

  SendAcousticSignalEvent({required this.crosswalk});
}

class SendVoiceInductorEvent extends CrosswalkEvent {
  final Crosswalk crosswalk;

  SendVoiceInductorEvent({required this.crosswalk});
}
