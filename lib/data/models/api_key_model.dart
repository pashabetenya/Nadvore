import 'index.dart';

const defaultApiKey = '0cca00b6155fcac417cc140a5deba9a4';

class ApiKeyModel extends Equatable {
  const ApiKeyModel.apiKey()
      : apiKey = defaultApiKey,
        isCustom = false;

  const ApiKeyModel.custom(this.apiKey) : isCustom = true;

  factory ApiKeyModel.parse(String? string) {
    if (string == null) return const ApiKeyModel.apiKey();

    return ApiKeyModel.custom(string);
  }

  final String apiKey;
  final bool isCustom;

  @override
  List<Object?> get props => [apiKey, isCustom];
}
