import 'index.dart';

const String themedefault = 'theme_default';
const String dark = 'dark_theme';

class ThemeLocalSource {
  ThemeLocalSource(this.preferences);

  final SharedPreferences preferences;

  Future<Either<Failure, ThemeModel?>> getTheme() async {
    final string = preferences.getString(themedefault);

    if (string == null) {
      return const Right(null);
    }

    return Right(ThemeModel.parse(string));
  }

  Future<Either<Failure, void>> setTheme(ThemeModel theme) async {
    await preferences.setString(themedefault, theme.toString());

    return const Right(null);
  }

  Future<Either<Failure, DarkThemeModel?>> getDarkTheme() async {
    final string = preferences.getString(dark);

    if (string == null) {
      return const Right(null);
    }

    return Right(DarkThemeModel.parse(string));
  }

  Future<Either<Failure, void>> setDarkTheme(DarkThemeModel theme) async {
    await preferences.setString(dark, theme.toString());

    return const Right(null);
  }
}

final themeLocalSourceProvider = Provider(
  (references) => ThemeLocalSource(references.watch(sharedPreferencesProvider)),
);
