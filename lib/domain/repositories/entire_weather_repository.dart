import 'index.dart';

abstract class EntireWeatherRepository {
  Future<Either<Failure, EntireWeather>> getEntireWeather(City city);
}

final entireWeatherRepositoryProvider =
    Provider<EntireWeatherRepository>((references) => throw UnimplementedError());
