import 'index.dart';

class SetCity implements Case<void, SetCityParams> {
  const SetCity(this.repo);

  final CityRepository repo;

  @override
  Future<Either<Failure, void>> call(SetCityParams params) => repo.setCity(params.city);
}

class SetCityParams extends Equatable {
  const SetCityParams(this.city);

  final City city;

  @override
  List<Object?> get props => [city];
}

final setCityProvider = Provider(
  (references) => SetCity(references.watch(cityRepositoryProvider)),
);
