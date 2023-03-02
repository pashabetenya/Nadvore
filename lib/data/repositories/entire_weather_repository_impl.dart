import 'index.dart';

class EntireWeatherRepositoryImpl implements EntireWeatherRepository {
  EntireWeatherRepositoryImpl(
    this.memoized,
    this.remote,
    this.connectivity,
  );

  final EntireWeatherRemoteSource remote;
  final EntireWeatherMemoizedSource memoized;
  final Connectivity connectivity;

  @override
  Future<Either<Failure, EntireWeather>> getEntireWeather(City city) async {
    if (await connectivity.checkConnectivity() == ConnectivityResult.none) {
      return const Left(Connection());
    } else {
      final memoizedWeather = await memoized.getMemoizedEntireWeather();

      if (memoizedWeather is Left ||
          memoizedWeather.all(
            (weather) => weather != null && weather.city.name == city.name,
          )) {
        return memoizedWeather.map((weather) => weather!);
      }

      final weather = (await remote.getEntireWeather(city)).map((model) => model.weather);

      await weather.map<Future<void>>(memoized.setEntireWeather).getOrElse(() async {});

      return weather;
    }
  }
}

final entireWeatherRepoImplProvider = Provider<EntireWeatherRepository>(
  (references) => EntireWeatherRepositoryImpl(
    references.watch(entireWeatherMemoizedSourceProvider),
    references.watch(entireWeatherRemoteDataSourceProvider),
    references.watch(connectivityProvider),
  ),
);
