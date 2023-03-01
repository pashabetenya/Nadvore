import 'index.dart';
import 'package:http/http.dart' as http;

class EntireWeatherRemoteSource {
  EntireWeatherRemoteSource(this.geo, this.key);

  final GeocodingRepositoryImpl geo;
  final ApiKeyRepositoryImpl key;

  Future<Either<Failure, EntireWeatherModel>> getEntireWeather(City city) async {
    final model = (await key.getApiKey()).fold((context) => null, id)!;

    final coordinate = (await geo.getCoordinates(city)).fold((_) => null, id)!;

    final response = await http.get(
      Uri(
        scheme: 'https',
        host: 'api.openweathermap.org',
        path: '/data/2.5/onecall',
        queryParameters: {
          'lon': coordinate.long.toString(),
          'lat': coordinate.lat.toString(),
          'appid': model.apiKey,
          'units': 'metric',
          'exclude': 'minutely,alerts',
        },
      ),
    );

    if (response.statusCode >= 200 && response.statusCode <= 226) {
      try {
        return Right(
          EntireWeatherModel.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>,
            city: city,
          ),
        );
      } on FormatException {
        return const Left(FailedToParseResponse());
      }
    } else if (response.statusCode == 503) {
      return const Left(Server());
    } else if (response.statusCode == 404) {
      return Left(InvalidCity(city.name));
    } else if (response.statusCode == 429) {
      return const Left(CallLimitExceeded());
    } else {
      return const Left(FailedToParseResponse());
    }
  }
}

final entireWeatherRemoteDataSourceProvider = Provider(
  (references) => EntireWeatherRemoteSource(
    references.watch(geocodingRepositoryImplProvider),
    references.watch(apiKeyRepositoryImplProvider),
  ),
);
