import 'package:safelight/core/errors/exceptions.dart';
import 'package:safelight/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:safelight/core/usecases/usecase.dart';
import 'package:safelight/data/sources/permission_native_data_source.dart';
import 'package:safelight/domain/repositories/permission_repository.dart';

class PermissionRepositoryImpl implements PermissionRepository {
  PermissionNativeDataSource permissionDataSource;

  PermissionRepositoryImpl({required this.permissionDataSource});

  @override
  Future<Either<Failure, bool>> getBluetoothPermission() async {
    try {
      final status = await permissionDataSource.getBluetoothPermissionStatus();
      return Right(status);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> getLocationPermission() async {
    try {
      final status = await permissionDataSource.getLocationPermissionStatus();
      return Right(status);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Void>> setBluetoothPermission() async {
    try {
      await permissionDataSource.setBluetoothPermission();
      return Right(Void());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Void>> setLocationPermission() async {
    try {
      await permissionDataSource.setLocationPermission();
      return Right(Void());
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
