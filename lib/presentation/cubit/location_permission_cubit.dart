import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safelight/core/utils/enums.dart';
import 'package:safelight/domain/usecases/permission_usecase.dart';

class LocationPermissionCubit extends Cubit<bool> {
  final GetPermission getPermission;
  final SetPermission setPermission;

  LocationPermissionCubit(
      {required this.getPermission, required this.setPermission})
      : super(false);

  Future<void> getPermissionStatus() async {
    try {
      final results = await getPermission(EPermission.LOCATION);
      results.fold(
        (failure) {
          emit(false);
        },
        (granted) {
          if (granted) {
            emit(true);
          } else {
            emit(false);
          }
        },
      );
    } catch (e) {
      emit(false);
    }
  }

  Future<void> setPermissionStatus() async {
    await setPermission(EPermission.LOCATION);
  }
}
