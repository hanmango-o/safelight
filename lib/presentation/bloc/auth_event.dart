import 'package:equatable/equatable.dart';

class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInAnonymouslyEvent extends AuthEvent {}

class SignOutAnonymouslyEvent extends AuthEvent {}
