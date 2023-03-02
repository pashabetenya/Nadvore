import 'package:weather/ui/states/theme_state_notifier.dart' as t;
import 'index.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:weather/ui/states/theme_state_notifier.dart' show themeStateNotifierProvider;

Future<void> main({
  TransitionBuilder? builder,
  Widget Function(Widget widget)? topLevelBuilder,
  Locale? Function(BuildContext)? getLocale,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  final widget = ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPreferences),

      // ignore: deprecated_member_use
      cityRepositoryProvider.overrideWithProvider(
        Provider((ref) => ref.watch(cityRepositoryImplProvider)),
      ),

      // ignore: deprecated_member_use
      unitSystemRepositoryProvider.overrideWithProvider(
        Provider((ref) => ref.watch(unitSystemRepositoryImplProvider)),
      ),

      // ignore: deprecated_member_use
      entireWeatherRepositoryProvider.overrideWithProvider(
        Provider((ref) => ref.watch(entireWeatherRepoImplProvider)),
      ),
    ],
    child: Application(builder: builder, getLocale: getLocale),
  );

  runApp(topLevelBuilder?.call(widget) ?? widget);
}

class Application extends HookConsumerWidget {
  const Application({
    super.key,
    this.builder,
    this.getLocale,
  });

  final TransitionBuilder? builder;
  final Locale? Function(BuildContext)? getLocale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStateNotifier = ref.watch(themeStateNotifierProvider.notifier);

    useEffect(
      () {
        themeStateNotifier.loadTheme();

        return null;
      },
      [themeStateNotifier],
    );

    final themeState = ref.watch(themeStateNotifierProvider);

    if (themeState is t.EmptyState || themeState is t.Loading) {
      return const SizedBox.shrink();
    }

    return Sizer(
      builder: (context, orientation, screenType) => MaterialApp(
        locale: getLocale?.call(context),
        builder: (context, child) {
          final ClimaThemeData climateTheme;

          switch (Theme.of(context).brightness) {
            case Brightness.light:
              climateTheme = lightClimaTheme;
              break;

            case Brightness.dark:
              climateTheme = {
                DarkThemeModel.black: blackClimaTheme,
                DarkThemeModel.grey: darkGreyClimaTheme,
              }[themeState.darkTheme]!;
          }

          child = ClimaTheme(data: climateTheme, child: child!);

          return builder?.call(context, child) ?? child;
        },
        home: const WeatherPage(),
        theme: lightTheme,
        darkTheme: {
          DarkThemeModel.black: blackTheme,
          DarkThemeModel.grey: darkGreyTheme,
        }[themeState.darkTheme],
        themeMode: const {
          ThemeModel.systemDefault: ThemeMode.system,
          ThemeModel.light: ThemeMode.light,
          ThemeModel.dark: ThemeMode.dark,
        }[themeState.theme],
      ),
    );
  }
}
