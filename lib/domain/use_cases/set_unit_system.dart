import 'index.dart';

class SetUnitSystem implements Case<void, SetUnitSystemParams> {
  const SetUnitSystem(this.repository);

  final UnitSystemRepository repository;

  @override
  Future<Either<Failure, void>> call(SetUnitSystemParams params) =>
      repository.setUnitSystem(params.unitSystem);
}

class SetUnitSystemParams extends Equatable {
  const SetUnitSystemParams(this.unitSystem);

  final UnitSystem unitSystem;

  @override
  List<Object?> get props => [unitSystem];
}

final setUnitSystemProvider = Provider(
  (references) => SetUnitSystem(references.watch(unitSystemRepositoryProvider)),
);
