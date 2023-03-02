import 'index.dart';
import 'package:weather/ui/states/api_key_state_notifier.dart' as a;
import 'package:weather/ui/states/city_state_notifier.dart' as c;
import 'package:weather/ui/states/entire_weather_state_notifier.dart' as w;
import 'package:weather/ui/states/unit_system_state_notifier.dart' as u;
import 'package:intl/intl.dart';

class WeatherPage extends HookConsumerWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entireWeatherState = ref.watch(w.entireWeatherStateNotifierProvider);
    final entireWeather = entireWeatherState.entireWeather;

    final entireWeatherStateNotifier = ref.watch(w.entireWeatherStateNotifierProvider.notifier);

    final apiKeyStateNotifier = ref.watch(a.apiKeyStateNotifierProvider.notifier);

    final controller = useFloatingSearchBarController();

    final cityStateNotifier = ref.watch(c.cityStateNotifierProvider.notifier);
    final cityState = ref.watch(c.cityStateNotifierProvider);

    final refreshIndicatorKey = useGlobalKey<RefreshIndicatorState>();

    final unitSystemStateNotifier = ref.watch(u.unitSystemStateNotifierProvider.notifier);

    final unitSystem = ref.watch(
      u.unitSystemStateNotifierProvider.select((state) => state.unitSystem),
    );

    useEffect(
      () {
        Future.microtask(
          () => Future.wait([
            apiKeyStateNotifier.loadApiKey(),
            unitSystemStateNotifier.loadUnitSystem(),
            entireWeatherStateNotifier.loadEntireWeather(),
          ]),
        );

        return null;
      },
      [entireWeatherStateNotifier, unitSystemStateNotifier, apiKeyStateNotifier],
    );

    useEffect(
      () {
        if (entireWeather == null) {
          return null;
        }

        return cityStateNotifier.addListener((state) {
          if (state is c.Error) {
            showFailureSnackBar(context, failure: state.failure, duration: 2);
          }
        });
      },
      [cityStateNotifier, entireWeather == null],
    );

    useEffect(
      () {
        if (entireWeather == null) {
          return null;
        }

        return entireWeatherStateNotifier.addListener((state) {
          if (state is w.Error) {
            showFailureSnackBar(context, failure: state.failure, duration: 2);
          }
        });
      },
      [entireWeatherStateNotifier, entireWeather == null],
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FloatingSearchAppBar(
        liftOnScrollElevation: 0.0,
        elevation: entireWeather == null ? 2.0 : 0.0,
        systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
        automaticallyImplyBackButton: false,
        controller: controller,
        progress: entireWeatherState is w.Loading || cityState is c.Loading,
        accentColor: Theme.of(context).colorScheme.secondary,
        onSubmitted: (newCityName) async {
          controller.close();

          final trimmedCityName = newCityName.trim();
          if (trimmedCityName.isEmpty) {
            return;
          }

          await cityStateNotifier.setCity(City(name: trimmedCityName));
          if (ref.read(c.cityStateNotifierProvider) is! c.Error) {
            await entireWeatherStateNotifier.loadEntireWeather();
          }
        },
        title: entireWeather == null
            ? const SizedBox.shrink()
            : Row(
                children: <Widget>[
                  Text(
                    'Updated ${DateFormat.Md().add_jm().format(entireWeather.currentWeather.date.toLocal())} · ',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.subtitle2!.color,
                      fontSize: MediaQuery.of(context).size.shortestSide < kTabletBreakpoint
                          ? 11.sp
                          : 5.sp,
                    ),
                  ),
                  Text(
                    () {
                      switch (unitSystem) {
                        case UnitSystem.metric:
                          return '°C';

                        case UnitSystem.imperial:
                          return '°F';

                        case null:
                          return '';
                      }
                    }(),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.subtitle1!.color,
                      fontSize: MediaQuery.of(context).size.shortestSide < kTabletBreakpoint
                          ? 11.sp
                          : 5.sp,
                    ),
                  ),
                ],
              ),
        hint: 'Enter city name..',
        color: Theme.of(context).appBarTheme.backgroundColor,
        transitionCurve: Curves.easeInOut,
        leadingActions: [
          FloatingSearchBarAction.back(color: Theme.of(context).appBarTheme.iconTheme!.color),
        ],
        actions: [
          FloatingSearchBarAction(
            child: CircularButton(
                icon: Icon(Icons.search, color: Theme.of(context).appBarTheme.iconTheme!.color),
                tooltip: 'Search',
                onPressed: () {
                  controller.open();
                }),
          ),
          const FloatingSearchBarAction(child: OverflowMenuButton()),
          FloatingSearchBarAction.searchToClear(
            color: Theme.of(context).appBarTheme.iconTheme!.color,
            showIfClosed: false,
          ),
        ],
        body: SafeArea(
          child: RefreshIndicator(
            key: refreshIndicatorKey,
            onRefresh: entireWeatherStateNotifier.loadEntireWeather,
            color: Theme.of(context).textTheme.subtitle1!.color,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: () {
                  if (MediaQuery.of(context).orientation == Orientation.landscape &&
                      MediaQuery.of(context).size.shortestSide > kTabletBreakpoint) {
                    return 10.0.w;
                  } else if (MediaQuery.of(context).orientation == Orientation.landscape &&
                      MediaQuery.of(context).size.shortestSide < kTabletBreakpoint) {
                    return 35.0.w;
                  } else {
                    return 5.0.w;
                  }
                }(),
              ),
              child: entireWeatherState is w.Error && entireWeather == null
                  ? FailureBanner(
                      failure: entireWeatherState.failure,
                      onRetry: entireWeatherStateNotifier.loadEntireWeather,
                    )
                  : entireWeather == null
                      ? null
                      : Container(
                          constraints: const BoxConstraints.expand(),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: <Widget>[
                                const MainInfoWidget(),
                                Divider(
                                  color:
                                      Theme.of(context).textTheme.subtitle1!.color!.withAlpha(65),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.aspectRatio == 1.0 ? 24.h : 16.h,
                                  child: const HourlyForecastsWidget(),
                                ),
                                Divider(
                                  color:
                                      Theme.of(context).textTheme.subtitle1!.color!.withAlpha(65),
                                ),
                                const DailyForecastsWidget(),
                                Divider(
                                  color:
                                      Theme.of(context).textTheme.subtitle1!.color!.withAlpha(65),
                                ),
                                const AdditionalInfoWidget(),
                              ],
                            ),
                          ),
                        ),
            ),
          ),
        ),
      ),
    );
  }
}
