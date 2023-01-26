import 'package:safelight/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:safelight/core/usecases/usecase.dart';
import 'package:safelight/domain/repositories/flash_repository.dart';

abstract class ServiceUseCase {}

abstract class ControlFlash extends ServiceUseCase
    implements UseCase<void, NoParams> {}

class ControlFlashOn implements ControlFlash {
  final FlashRepository repository;

  ControlFlashOn({required this.repository});

  @override
  Future<Either<Failure, Void>> call(NoParams params) async {
    return await repository.turnOn();
  }
}

class ControlFlashOnWithWeather implements ControlFlash {
  final FlashRepository repository;

  ControlFlashOnWithWeather({required this.repository});

  @override
  Future<Either<Failure, Void>> call(NoParams params) async {
    return await repository.turnOnWithWeather();
  }
}

class ControlFlashOff implements ControlFlash {
  final FlashRepository repository;

  ControlFlashOff({required this.repository});

  @override
  Future<Either<Failure, Void>> call(NoParams params) async {
    return await repository.turnOff();
  }
}
