import 'index.dart';

class GetCity implements Case<City, NoParams> {
  const GetCity(this.repository);

  final CityRepository repository;

  @override
  Future<Either<Failure, City>> call(NoParams params) => repository.getCity();
}

final getCityProvider = Provider(
  (references) => GetCity(references.watch(cityRepositoryProvider)),
);
