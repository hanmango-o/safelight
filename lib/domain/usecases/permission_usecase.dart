import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../../core/utils/enums.dart';
import '../repositories/permission_repository.dart';

abstract class PermissionUseCase {}

class GetPermission extends PermissionUseCase
    implements UseCase<bool, EPermission> {
  PermissionRepository repository;

  GetPermission({required this.repository});

  @override
  Future<Either<Failure, bool>> call(EPermission params) async {
    switch (params) {
      case EPermission.BLUETOOTH:
        return await repository.getBluetoothPermission();

      case EPermission.LOCATION:
        return await repository.getLocationPermission();
    }
  }
}

class SetPermission extends PermissionUseCase
    implements UseCase<Void, EPermission> {
  PermissionRepository repository;

  SetPermission({required this.repository});

  @override
  Future<Either<Failure, Void>> call(EPermission params) async {
    switch (params) {
      case EPermission.BLUETOOTH:
        return await repository.setBluetoothPermission();

      case EPermission.LOCATION:
        return await repository.setLocationPermission();
    }
  }
}
