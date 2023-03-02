import 'index.dart';

class ThemeRepositoryImpl {
  const ThemeRepositoryImpl({required this.local});

  final ThemeLocalSource local;

  Future<Either<Failure, ThemeModel>> getTheme() async =>
      (await local.getTheme()).map((theme) => theme ?? ThemeModel.systemDefault);

  Future<Either<Failure, void>> setTheme(ThemeModel theme) => local.setTheme(theme);

  Future<Either<Failure, DarkThemeModel>> getDarkTheme() async =>
      (await local.getDarkTheme()).map((theme) => theme ?? DarkThemeModel.grey);

  Future<Either<Failure, void>> setDarkTheme(DarkThemeModel theme) => local.setDarkTheme(theme);
}

final themeRepositoryImplProvider = Provider(
  (references) => ThemeRepositoryImpl(local: references.watch(themeLocalSourceProvider)),
);
