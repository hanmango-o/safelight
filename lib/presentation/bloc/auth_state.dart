import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Done extends AuthState {}

class Loading extends AuthState {}

class Error extends AuthState {
  final String message;

  Error({required this.message});

  @override
  List<Object?> get props => [message];
}
