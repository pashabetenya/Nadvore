import 'index.dart';

@sealed
@immutable
abstract class ThemeState extends Equatable {
  const ThemeState();

  ThemeModel? get theme;
  DarkThemeModel? get darkTheme;
}

class EmptyState extends ThemeState {
  const EmptyState();

  @override
  ThemeModel? get theme => null;

  @override
  DarkThemeModel? get darkTheme => null;

  @override
  List<Object?> get props => const [];
}

class Loading extends ThemeState {
  const Loading();

  @override
  ThemeModel? get theme => null;

  @override
  DarkThemeModel? get darkTheme => null;

  @override
  List<Object?> get props => const [];
}

class LoadedState extends ThemeState {
  const LoadedState({required this.theme, required this.darkTheme});

  @override
  final ThemeModel? theme;

  @override
  final DarkThemeModel? darkTheme;

  @override
  List<Object?> get props => [theme, darkTheme];
}

class ErrorState extends ThemeState {
  const ErrorState(this.failure, {this.theme, this.darkTheme});

  final Failure failure;

  @override
  final ThemeModel? theme;

  @override
  final DarkThemeModel? darkTheme;

  @override
  List<Object?> get props => [failure, theme, darkTheme];
}

class ThemeStateNotifier extends StateNotifier<ThemeState> {
  ThemeStateNotifier(this.repositoryImpl) : super(const EmptyState());

  final ThemeRepositoryImpl repositoryImpl;

  Future<void> loadTheme() async {
    final data = await Future.wait([repositoryImpl.getTheme(), repositoryImpl.getDarkTheme()]);

    state = data[0]
        .bind(
          (theme) => data[1].map(
            (darkTheme) => LoadedState(
              theme: theme as ThemeModel,
              darkTheme: darkTheme as DarkThemeModel,
            ),
          ),
        )
        .fold(ErrorState.new, id);
  }

  Future<void> setTheme(ThemeModel theme) async {
    state = (await repositoryImpl.setTheme(theme)).fold(
      (failure) => ErrorState(failure, theme: state.theme, darkTheme: state.darkTheme),
      (context) => LoadedState(theme: theme, darkTheme: state.darkTheme),
    );
  }

  Future<void> setDarkTheme(DarkThemeModel darkTheme) async {
    state = (await repositoryImpl.setDarkTheme(darkTheme)).fold(
      (failure) => ErrorState(failure, theme: state.theme, darkTheme: state.darkTheme),
      (context) => LoadedState(theme: state.theme, darkTheme: darkTheme),
    );
  }
}

final themeStateNotifierProvider = StateNotifierProvider<ThemeStateNotifier, ThemeState>(
  (references) => ThemeStateNotifier(references.watch(themeRepositoryImplProvider)),
);
