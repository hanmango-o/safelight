import 'package:dartz/dartz.dart';
import 'package:safelight/core/errors/failures.dart';
import 'package:safelight/core/usecases/usecase.dart';
import 'package:safelight/domain/entities/crosswalk.dart';
import 'package:safelight/domain/repositories/crosswalk_repository.dart';

abstract class CrosswalkUseCase {}

abstract class ConnectCrosswalk extends CrosswalkUseCase
    implements UseCase<Void, Crosswalk> {}

class SendAcousticSignal implements ConnectCrosswalk {
  final List<int> _command = [0x31, 0x00, 0x02];
  CrosswalkRepository repository;

  SendAcousticSignal({required this.repository});

  @override
  Future<Either<Failure, Void>> call(Crosswalk params) async {
    return await repository.sendCommand2Crosswalk(params, _command);
  }
}

class SendVoiceInductor implements ConnectCrosswalk {
  static const List<int> _command = [0x31, 0x00, 0x01];
  CrosswalkRepository repository;

  SendVoiceInductor({required this.repository});

  @override
  Future<Either<Failure, Void>> call(Crosswalk params) async {
    return await repository.sendCommand2Crosswalk(params, _command);
  }
}

abstract class SearchCrosswalk extends CrosswalkUseCase
    implements UseCase<List<Crosswalk>, NoParams> {}

class Search2FiniteTimes implements SearchCrosswalk {
  final CrosswalkRepository repository;

  Search2FiniteTimes({required this.repository});

  @override
  Future<Either<Failure, List<Crosswalk>>> call(NoParams params) async {
    return await repository.getCrosswalkFiniteTimes();
  }
}

class Search2InfiniteTimes implements SearchCrosswalk {
  final CrosswalkRepository repository;

  Search2InfiniteTimes({required this.repository});

  @override
  Future<Either<Failure, List<Crosswalk>>> call(NoParams params) async {
    // return await repository.getCrosswalkFiniteTimes();
    throw Exception();
  }
}
