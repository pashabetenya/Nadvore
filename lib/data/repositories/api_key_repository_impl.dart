import 'index.dart';
import 'package:http/http.dart' as http;

class ApiKeyRepositoryImpl {
  ApiKeyRepositoryImpl(this.source);

  final ApiKeyLocalSource source;

  Future<Either<Failure, ApiKeyModel>> getApiKey() => source.getApiKey();

  Future<Either<Failure, void>> setApiKey(ApiKeyModel model) async {
    if (!model.isCustom) {
      return source.setApiKey(model);
    }

    final response = await http.get(
      Uri(
        scheme: 'https',
        host: 'api.openweathermap.org',
        path: '/data/2.5/weather',
        queryParameters: {'appid': model.apiKey},
      ),
    );

    switch (response.statusCode) {
      case 400:
        return source.setApiKey(model);

      case 401:
        return const Left(InvalidApiKey());

      case 503:
        return const Left(Server());

      default:
        return const Left(FailedToParseResponse());
    }
  }
}

final apiKeyRepositoryImplProvider = Provider(
  (references) => ApiKeyRepositoryImpl(references.watch(apiKeyLocalSourceProvider)),
);
