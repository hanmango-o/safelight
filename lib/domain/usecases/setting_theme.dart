import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';

abstract class SettingTheme {}

class GetSettingThemeMode
    implements SettingTheme, UseCase<ThemeMode, NoParams> {
  @override
  Future<Either<Failure, ThemeMode>> call(NoParams params) {
    throw UnimplementedError();
  }
}

class SetSettingThemeMode
    implements SettingTheme, UseCase<ThemeMode, ThemeMode> {
  @override
  Future<Either<Failure, ThemeMode>> call(ThemeMode params) {
    throw UnimplementedError();
  }
}
