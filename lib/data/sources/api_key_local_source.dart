import 'index.dart';

const apiKeyPreferencesKey = 'open_weather_map_api_key';

class ApiKeyLocalSource {
  ApiKeyLocalSource(this.preferences);

  final SharedPreferences preferences;

  Future<Either<Failure, ApiKeyModel>> getApiKey() async {
    return Right(
      ApiKeyModel.parse(preferences.getString(apiKeyPreferencesKey)),
    );
  }

  Future<Either<Failure, void>> setApiKey(ApiKeyModel model) async {
    if (model.isCustom) {
      await preferences.setString(apiKeyPreferencesKey, model.apiKey);
    } else {
      await preferences.remove(apiKeyPreferencesKey);
    }

    return const Right(null);
  }
}

final apiKeyLocalSourceProvider = Provider(
  (references) => ApiKeyLocalSource(references.watch(sharedPreferencesProvider)),
);
