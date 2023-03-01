import 'index.dart';

class GetUnitSystem implements Case<UnitSystem, NoParams> {
  const GetUnitSystem(this.repository);

  final UnitSystemRepository repository;

  @override
  Future<Either<Failure, UnitSystem>> call(NoParams params) => repository.getUnitSystem();
}

final getUnitSystemProvider = Provider(
  (references) => GetUnitSystem(references.watch(unitSystemRepositoryProvider)),
);
