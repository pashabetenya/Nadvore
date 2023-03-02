import 'index.dart';

class UnitSystemRepositoryImpl implements UnitSystemRepository {
  UnitSystemRepositoryImpl(this.local);

  final UnitSystemLocalSource local;

  @override
  Future<Either<Failure, UnitSystem>> getUnitSystem() async =>
      (await local.getUnitSystem()).map((model) => model?.unitSystem ?? UnitSystem.metric);

  @override
  Future<Either<Failure, void>> setUnitSystem(UnitSystem unitSystem) =>
      local.setUnitSystem(UnitSystemModel(unitSystem));
}

final unitSystemRepositoryImplProvider = Provider(
  (references) => UnitSystemRepositoryImpl(references.watch(unitSystemLocalSourceProvider)),
);
