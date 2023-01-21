import 'package:flutter/material.dart';
import 'package:safelight/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:safelight/core/usecases/usecase.dart';

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
