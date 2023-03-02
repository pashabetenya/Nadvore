import 'index.dart';

const city = [
  'Wroclaw',
  'Brest',
  'Minsk',
  'Pinsk',
  'Kobrin',
  'Warsaw',
];

class CityRandomSource {
  Future<Either<Failure, CityModel>> getCity() async => Right(
        CityModel(
          City(name: city[Random().nextInt(city.length)]),
        ),
      );
}

final cityRandomSourceProvider = Provider((references) => CityRandomSource());
