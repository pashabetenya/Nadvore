import 'index.dart';

class EntireWeatherMemoizedSource {
  EntireWeather? weather;

  DateTime? fetching;

  static const invalidation = Duration(minutes: 10);

  Future<Either<Failure, EntireWeather?>> getMemoizedEntireWeather() async {
    if (weather == null) return const Right(null);

    if (DateTime.now().difference(fetching!) >= invalidation) {
      fetching = null;
      weather = null;

      return const Right(null);
    }

    await Future<void>.delayed(
      Duration(milliseconds: 200 + Random().nextInt(800 - 200)),
    );

    return Right(weather);
  }

  Future<Either<Failure, void>> setEntireWeather(EntireWeather weather) async {
    fetching = DateTime.now();
    weather = weather;

    return const Right(null);
  }
}

final entireWeatherMemoizedSourceProvider = Provider((references) => EntireWeatherMemoizedSource());
