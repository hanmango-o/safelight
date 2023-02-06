import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? id;
  final String? pw;

  const User({
    this.id,
    this.pw,
  });

  @override
  List<Object?> get props => [id, pw];
}
