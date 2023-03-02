import 'index.dart';

const preferencesKey = 'unit_system';

class UnitSystemLocalSource {
  UnitSystemLocalSource(this.preferences);

  final SharedPreferences preferences;

  Future<Either<Failure, UnitSystemModel?>> getUnitSystem() async {
    final string = preferences.getString(preferencesKey);

    if (string == null) return const Right(null);

    return Right(UnitSystemModel.parse(string));
  }

  Future<Either<Failure, void>> setUnitSystem(UnitSystemModel model) async {
    await preferences.setString(preferencesKey, model.toString());

    return const Right(null);
  }
}

final unitSystemLocalSourceProvider = Provider(
  (references) => UnitSystemLocalSource(references.watch(sharedPreferencesProvider)),
);
