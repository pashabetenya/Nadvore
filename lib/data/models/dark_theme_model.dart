import 'index.dart';

enum DarkThemeModel {
  black('black'),
  grey('grey');

  const DarkThemeModel(this.string);

  final String string;

  static DarkThemeModel parse(String string) {
    final theme = values.firstWhereOrNull((theme) => theme.string == string);

    if (theme == null) {
      throw FormatException('Invalid theme', string);
    }

    return theme;
  }

  @override
  String toString() => string;
}
