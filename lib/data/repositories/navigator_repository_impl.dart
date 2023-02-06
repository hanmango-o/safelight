import 'package:latlong2/latlong.dart';
import 'package:dartz/dartz.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/repositories/navigator_repository.dart';
import '../sources/navigate_remote_data_source.dart';

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
