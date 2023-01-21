import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';
import 'package:safelight/core/errors/failures.dart';
import 'package:safelight/core/usecases/usecase.dart';
import 'package:safelight/domain/repositories/navigator_repository.dart';

abstract class NavUseCase {}

class GetCurrentPosition extends NavUseCase
    implements UseCase<LatLng, NoParams> {
  NavigatorRepository navRepository;

  GetCurrentPosition({required this.navRepository});

  @override
  Future<Either<Failure, LatLng>> call(NoParams params) async {
    return await navRepository.getCurrentPosition();
  }
}
