import 'index.dart';

class CityLocalSource {
  CityLocalSource(this.preferences);

  final SharedPreferences preferences;

  Future<Either<Failure, CityModel?>> getCity() async {
    final city = preferences.getString('name');

    if (city == null) return const Right(null);

    return Right(
      CityModel(City(name: city)),
    );
  }

  Future<Either<Failure, void>> setCity(City city) async {
    await preferences.setString('name', city.name);

    return const Right(null);
  }
}

final cityLocalSourceProvider = Provider(
  (references) => CityLocalSource(references.watch(sharedPreferencesProvider)),
);
