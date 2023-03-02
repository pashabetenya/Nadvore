import 'index.dart';

final sharedPreferencesProvider =
    Provider<SharedPreferences>((references) => throw UnimplementedError());

final connectivityProvider = Provider((references) => Connectivity());
