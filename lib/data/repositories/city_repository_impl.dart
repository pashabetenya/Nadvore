import 'index.dart';

class CityRepositoryImpl implements CityRepository {
  CityRepositoryImpl({
    required this.random,
    required this.geocoding,
    required this.local,
  });

  final CityRandomSource random;
  final GeocodingRepositoryImpl geocoding;
  final CityLocalSource local;

  @override
  Future<Either<Failure, City>> getCity() async {
    final city = await local.getCity();

    if (city is Left) {
      return city.map((model) => model!.city);
    }

    final model = (city as Right<Failure, CityModel?>).value;

    if (model == null) {
      return (await random.getCity()).map((model) => model.city);
    }

    return Right(model.city);
  }

  @override
  Future<Either<Failure, void>> setCity(City city) async {
    final coordinates = await geocoding.getCoordinates(city);

    return coordinates.fold(
      (failure) async => Left(failure),
      (coordinates) => local.setCity(coordinates.city),
    );
  }
}

final cityRepositoryImplProvider = Provider(
  (references) => CityRepositoryImpl(
    random: references.watch(cityRandomSourceProvider),
    geocoding: references.watch(geocodingRepositoryImplProvider),
    local: references.watch(cityLocalSourceProvider),
  ),
);
