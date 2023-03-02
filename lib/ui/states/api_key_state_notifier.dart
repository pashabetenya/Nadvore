import 'index.dart';

@sealed
@immutable
abstract class ApiKeyState extends Equatable {
  const ApiKeyState();

  ApiKeyModel? get apiKey => null;

  @override
  List<Object?> get props => const [];
}

class Empty extends ApiKeyState {
  const Empty();
}

class Loading extends ApiKeyState {
  const Loading();
}

class Loaded extends ApiKeyState {
  const Loaded(this.apiKey);

  @override
  final ApiKeyModel apiKey;

  @override
  List<Object?> get props => [apiKey];
}

class Error extends ApiKeyState {
  const Error(this.failure, {this.apiKey});

  final Failure failure;

  @override
  final ApiKeyModel? apiKey;

  @override
  List<Object?> get props => [failure, apiKey];
}

class ApiKeyStateNotifier extends StateNotifier<ApiKeyState> {
  ApiKeyStateNotifier(this.apiKeyRepositoryImpl) : super(const Empty());

  final ApiKeyRepositoryImpl apiKeyRepositoryImpl;

  Future<void> loadApiKey() async {
    state = const Loading();
    final data = await apiKeyRepositoryImpl.getApiKey();
    state = data.fold(Error.new, Loaded.new);
  }

  Future<void> setApiKey(ApiKeyModel apiKey) async {
    (await apiKeyRepositoryImpl.setApiKey(apiKey)).fold((failure) {
      state = Error(failure, apiKey: state.apiKey);
    }, (context) {
      state = Loaded(apiKey);
    });
  }
}

final apiKeyStateNotifierProvider = StateNotifierProvider<ApiKeyStateNotifier, ApiKeyState>(
  (references) => ApiKeyStateNotifier(references.watch(apiKeyRepositoryImplProvider)),
);
