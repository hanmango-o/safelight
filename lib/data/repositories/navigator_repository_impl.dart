import 'package:safelight/core/errors/exceptions.dart';
import 'package:safelight/core/errors/failures.dart';
import 'package:latlong2/latlong.dart';
import 'package:dartz/dartz.dart';
import 'package:safelight/data/sources/navigate_remote_data_source.dart';
import 'package:safelight/domain/repositories/navigator_repository.dart';

class NavigatorRepositoryImpl implements NavigatorRepository {
  NavigateRemoteDataSource navDataSource;

  NavigatorRepositoryImpl({required this.navDataSource});

  @override
  Future<Either<Failure, LatLng>> getCurrentPosition() async {
    try {
      final position = await navDataSource.getCurrentLatLng();
      return Right(position);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
