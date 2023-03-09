part of controller;

@immutable
abstract class CrosswalkState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchOn extends CrosswalkState {
  final bool infinite;

  SearchOn({this.infinite = false});

  @override
  List<Object?> get props => [infinite];
}

class SearchOff extends CrosswalkState {
  final List<Crosswalk> results;

  SearchOff({required this.results});

  @override
  List<Object?> get props => results;
}

class CrosswalkError extends CrosswalkState {
  final String message;

  CrosswalkError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ConnectOn extends CrosswalkState {}

class ConnectOff extends CrosswalkState {
  final bool enableCompass;
  final LatLng? latLng;

  ConnectOff({required this.enableCompass, this.latLng});

  @override
  List<Object?> get props => [enableCompass];
}
