import 'index.dart';

abstract class UnitSystemRepository {
  Future<Either<Failure, UnitSystem>> getUnitSystem();

  Future<Either<Failure, void>> setUnitSystem(UnitSystem unitSystem);
}

final unitSystemRepositoryProvider =
    Provider<UnitSystemRepository>((references) => throw UnimplementedError());
