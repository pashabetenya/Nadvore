import 'package:weather/ui/states/entire_weather_state_notifier.dart' as w;
import 'index.dart';
import 'package:intl/intl.dart';

class HourlyForecastsWidget extends ConsumerWidget {
  const HourlyForecastsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hourlyForecasts = ref.watch(
      w.entireWeatherStateNotifierProvider.select(
        (state) => state.entireWeather!.hourlyForecasts,
      ),
    );
    final timeZoneOffset = ref.watch(
      w.entireWeatherStateNotifierProvider.select(
        (state) => state.entireWeather!.timeZoneOffset,
      ),
    );

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: 24,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final hourlyForecast = hourlyForecasts[index];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              widget1(context, hourlyForecast, timeZoneOffset),
              widget2(hourlyForecast),
              widget3(context, hourlyForecast),
              widget4(context, hourlyForecast),
            ],
          ),
        );
      },
    );
  }

  Widget widget1(context, hourlyForecast, timeZoneOffset) {
    return Text(
      DateFormat.j().format(hourlyForecast.date.toUtc().add(timeZoneOffset)),
      style: kSubtitle2TextStyle(context),
    );
  }

  Widget widget2(hourlyForecast) {
    return SvgPicture.asset(
      getWeatherIcon(hourlyForecast.iconCode),
      height: 6.h,
    );
  }

  Widget widget3(context, hourlyForecast) {
    return Text(
      '${hourlyForecast.temperature.round()}°',
      style: kSubtitle1TextStyle(context),
    );
  }

  Widget widget4(context, hourlyForecast) {
    return Row(
      children: <Widget>[
        Icon(
          FontAwesomeIcons.droplet,
          color: Theme.of(context).textTheme.subtitle2!.color,
          size: kIconSize(context),
        ),
        Text('${(hourlyForecast.pop * 100).round()}%', style: kSubtitle2TextStyle(context)),
      ],
    );
  }
}
