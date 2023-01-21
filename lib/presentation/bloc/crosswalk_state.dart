import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:safelight/domain/entities/crosswalk.dart';

@immutable
abstract class CrosswalkState extends Equatable {
  @override
  List<Object?> get props => [];
}

class On extends CrosswalkState {}

class Off extends CrosswalkState {
  final List<Crosswalk> results;

  Off({required this.results});

  @override
  List<Object?> get props => results;
}

class Error extends CrosswalkState {
  final String message;

  Error({required this.message});

  @override
  List<Object?> get props => [message];
}

class Connect extends CrosswalkState {}

class Done extends CrosswalkState {
  final bool enableCompass;
  final LatLng? latLng;

  Done({required this.enableCompass, this.latLng});

  @override
  List<Object?> get props => [enableCompass];
}
