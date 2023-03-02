import 'index.dart';
import 'package:http/http.dart' as http;

class GeocodingRemoteSource {
  GeocodingRemoteSource(this.key);

  final ApiKeyRepositoryImpl key;

  Future<Either<Failure, GeographicCoordinatesModel>> getCoordinates(
    City city,
  ) async {
    final apiKeyModel = (await key.getApiKey()).fold((_) => null, id)!;

    final response = await http.get(
      Uri(
        scheme: 'https',
        host: 'api.openweathermap.org',
        path: '/geo/1.0/direct',
        queryParameters: {
          'q': city.name,
          'appid': apiKeyModel.apiKey,
          'limit': '1',
        },
      ),
    );

    switch (response.statusCode) {
      case 503:
        return const Left(Server());

      case 429:
        return const Left(CallLimitExceeded());
    }

    dynamic body;

    try {
      body = jsonDecode(response.body);
    } on FormatException {
      return const Left(FailedToParseResponse());
    }

    if (body is List) {
      if (body.isEmpty) {
        return Left(InvalidCity(city.name));
      }

      return Right(GeographicCoordinatesModel.fromRemoteJson(body));
    } else {
      return const Left(FailedToParseResponse());
    }
  }
}

final geocodingRemoteSourceProvider = Provider(
  (references) => GeocodingRemoteSource(references.watch(apiKeyRepositoryImplProvider)),
);
