import 'package:latlong2/latlong.dart';
import 'package:dartz/dartz.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/repositories/navigator_repository.dart';
import '../sources/navigate_remote_data_source.dart';

/// [NavigatorRepositoryImpl]는 [NavigatorRepository]의 구현부이다.
///
/// `sources` 폴더의 [NavigateRemoteDataSource]를 사용하여 현재 사용자의 위치 정보를 요청한다.
///
/// ---
/// ## Members
/// [NavigatorRepositoryImpl]의 member는 아래와 같다.
///
/// ### field
/// * [navDataSource]
///
/// ### method
/// * [getCurrentPosition]
///   * [NavigateRemoteDataSource.getCurrentLatLng]을 호출하여 현재 사용자의 위치 정보 요청을 수행한다.
///
/// ---
/// ## Example
/// [NavigatorRepositoryImpl]는 아래와 같이 [NavigatorRepository] 타입으로 객체를 생성해야 한다.
///
/// ```dart
/// NavigatorRepository repository = NavigatorRepositoryImpl(datasource);
/// ```
///
/// 또한 외부에서 의존성을 주입하여 객체를 생성하는 것을 권장한다.
///
/// ```dart
/// // 외부 의존성 주입이 완료된 경우
/// NavigatorRepository repository = DI.get<NavigatorRepository>();
/// ```
///
/// 객체의 생성이 끝난 경우 아래와 같이 메소드를 호출한다.
///
/// ```dart
/// repository.getCurrentLatLng(); // 횡단보도 찾기
/// ```
///
/// 아래는 위 과정에 대한 전문이다.
///
/// ```dart
/// NavigatorRepository repository = NavigatorRepositoryImpl(datasource); // 권장
/// // 외부 의존성 주입이 완료된 경우
/// NavigatorRepository repository = DI.get<NavigatorRepository>(); // Best Practice
///
/// repository.getCurrentLatLng(); // 횡단보도 찾기
/// ```
class NavigatorRepositoryImpl implements NavigatorRepository {
  /// [NavigateRemoteDataSource] 객체를 담는 변수로서 외부에서 DI되어 사용된다.
  ///
  /// 변수형을 선언([NavigateRemoteDataSource])하고 실제 DI하는 값은 [NavigateRemoteDataSourceImpl] 객체로 주입한다.
  ///
  /// See also:
  ///  * DI에 대한 자세한 설명은 `injection.dart` 파일에서 확인할 수 있다.
  NavigateRemoteDataSource navDataSource;

  /// Default constructor로서 의존성 주입을 위해 [navDataSource]를 Argument로 반드시 받아야 한다.
  ///
  /// 아래와 같이 사용할 수 있다.
  ///
  /// ```dart
  /// NavigatorRepository repository = NavigatorRepositoryImpl(datasource); // 권장
  /// // 외부 의존성 주입이 완료된 경우
  /// NavigatorRepository repository = DI.get<NavigatorRepository>(); // Best Practice
  /// ```
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
