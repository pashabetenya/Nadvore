import 'index.dart';

abstract class CityRepository {
  Future<Either<Failure, City>> getCity();

  Future<Either<Failure, void>> setCity(City city);
}

final cityRepositoryProvider = Provider<CityRepository>((references) => throw UnimplementedError());
