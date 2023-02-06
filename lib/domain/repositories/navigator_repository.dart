import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';

import '../../core/errors/failures.dart';

abstract class NavigatorRepository {
  Future<Either<Failure, LatLng>> getCurrentPosition();
}
