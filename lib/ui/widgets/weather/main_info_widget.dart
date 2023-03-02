import 'package:weather/ui/states/entire_weather_state_notifier.dart' as w;
import 'index.dart';

class MainInfoWidget extends ConsumerWidget {
  const MainInfoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(
      w.entireWeatherStateNotifierProvider.select(
        (state) => state.entireWeather!.currentWeather,
      ),
    );
    final currentDayForecast = ref.watch(
      w.entireWeatherStateNotifierProvider.select(
        (state) => state.entireWeather!.currentDayForecast,
      ),
    );
    final city = ref.watch(
      w.entireWeatherStateNotifierProvider.select(
        (state) => state.entireWeather!.city,
      ),
    );

    return Padding(
      padding: EdgeInsets.only(
        top: () {
          if (MediaQuery.of(context).size.shortestSide < kTabletBreakpoint) {
            if (MediaQuery.of(context).orientation == Orientation.landscape) {
              return 0.0;
            } else {
              return 4.h;
            }
          } else {
            return 8.h;
          }
        }(),
        bottom: 4.h,
      ),
      child: Column(
        children: <Widget>[
          widget1(context, city),
          widget2(context, currentWeather),
          widget3(context, currentDayForecast),
          widget4(context, currentWeather),
        ],
      ),
    );
  }

  Widget widget1(context, city) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Text(
        city.name.toUpperCase(),
        style: kSubtitle1TextStyle(context).copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 5,
          fontSize: MediaQuery.of(context).size.shortestSide < kTabletBreakpoint ? 20.sp : 14.sp,
        ),
      ),
    );
  }

  Widget widget2(context, currentWeather) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Text(
        '${currentWeather.temperature.round()}°',
        maxLines: 1,
        style: kSubtitle1TextStyle(context).copyWith(
          fontSize: MediaQuery.of(context).size.shortestSide < kTabletBreakpoint ? 40.sp : 30.sp,
          fontWeight: FontWeight.w100,
        ),
      ),
    );
  }

  Widget widget3(context, currentDayForecast) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.keyboard_arrow_up,
            size: kIconSize(context),
            color: Theme.of(context).textTheme.subtitle1!.color,
          ),
          Text(
            '${currentDayForecast.maxTemperature.round()}°',
            style: kSubtitle1TextStyle(context),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Icon(
              Icons.keyboard_arrow_down,
              size: kIconSize(context),
              color: Theme.of(context).textTheme.subtitle1!.color,
            ),
          ),
          Text(
            '${currentDayForecast.minTemperature.round()}°',
            style: kSubtitle1TextStyle(context),
          ),
        ],
      ),
    );
  }

  Widget widget4(context, currentWeather) {
    return Text(
      currentWeather.description.toUpperCase(),
      style: kSubtitle1TextStyle(context).copyWith(
        fontWeight: FontWeight.w300,
        letterSpacing: 5,
        fontSize: MediaQuery.of(context).size.shortestSide < kTabletBreakpoint ? 15.sp : 10.sp,
      ),
    );
  }
}
