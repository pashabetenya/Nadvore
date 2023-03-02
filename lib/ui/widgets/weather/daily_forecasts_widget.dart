import 'package:weather/ui/states/entire_weather_state_notifier.dart' as w;
import 'index.dart';
import 'package:intl/intl.dart';

class DailyForecastsWidget extends ConsumerWidget {
  const DailyForecastsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyForecasts = ref.watch(
      w.entireWeatherStateNotifierProvider.select(
        (state) => state.entireWeather!.dailyForecasts,
      ),
    );
    final timeZoneOffset = ref.watch(
      w.entireWeatherStateNotifierProvider.select(
        (state) => state.entireWeather!.timeZoneOffset,
      ),
    );
    final currentDayForecast = ref.watch(
      w.entireWeatherStateNotifierProvider.select(
        (state) => state.entireWeather!.currentDayForecast,
      ),
    );

    return Column(
      children: [
        for (final dailyForecast in dailyForecasts)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget1(context, dailyForecast, currentDayForecast, timeZoneOffset),
                widget2(context, dailyForecast),
                widget3(context, dailyForecast),
              ],
            ),
          ),
      ],
    );
  }

  Widget widget1(context, dailyForecast, currentDayForecast, timeZoneOffset) {
    return Expanded(
      flex: 2,
      child: Text(
        dailyForecast == currentDayForecast
            ? 'Today'
            : DateFormat.EEEE().format(dailyForecast.date.toUtc().add(timeZoneOffset)),
        style: kSubtitle1TextStyle(context).copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget widget2(context, dailyForecast) {
    return Expanded(
      flex: 2,
      child: Row(
        children: [
          SvgPicture.asset(getWeatherIcon(dailyForecast.iconCode), height: 6.h),
          Icon(
            FontAwesomeIcons.droplet,
            color: Theme.of(context).textTheme.subtitle2!.color,
            size: kIconSize(context),
          ),
          Text('${(dailyForecast.pop * 100).round()}%', style: kSubtitle2TextStyle(context)),
        ],
      ),
    );
  }

  Widget widget3(context, dailyForecast) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${dailyForecast.maxTemperature.round()}°', style: kSubtitle1TextStyle(context)),
          Text('/', style: kSubtitle2TextStyle(context)),
          Text('${dailyForecast.minTemperature.round()}°', style: kSubtitle2TextStyle(context)),
        ],
      ),
    );
  }
}
