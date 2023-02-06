import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';

abstract class PermissionRepository {
  Future<Either<Failure, bool>> getBluetoothPermission();
  Future<Either<Failure, bool>> getLocationPermission();
  Future<Either<Failure, Void>> setBluetoothPermission();
  Future<Either<Failure, Void>> setLocationPermission();
}
