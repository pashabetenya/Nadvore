import 'package:weather/ui/states/entire_weather_state_notifier.dart' as w;
import 'index.dart';
import 'package:intl/intl.dart';

class AdditionalInfoWidget extends ConsumerWidget {
  const AdditionalInfoWidget({super.key});

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
    final timeZoneOffset = ref.watch(
      w.entireWeatherStateNotifierProvider.select(
        (state) => state.entireWeather!.timeZoneOffset,
      ),
    );

    final unitSystem = ref.watch(
      unitSystemStateNotifierProvider.select(
        (state) => state.unitSystem!,
      ),
    );

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 2.h, top: 2.h, left: 5.w, right: 5.w),
          child: Row(
            children: [
              AdditionalInfoTile(title: 'Feels like', value: '${currentWeather.tempFeel.round()}°'),
              AdditionalInfoTile(title: 'Humidity', value: '${currentWeather.humidity}%'),
              AdditionalInfoTile(
                title: 'Wind speed',
                value: '${currentWeather.windSpeed.round()} ${() {
                  switch (unitSystem) {
                    case UnitSystem.metric:
                      return 'km/h';

                    case UnitSystem.imperial:
                      return 'mph';
                  }
                }()}',
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 2.h, top: 1.h, right: 5.w, left: 5.w),
          child: Row(
            children: [
              AdditionalInfoTile(title: 'Clouds', value: '${currentWeather.clouds.toString()}%'),
              AdditionalInfoTile(title: 'UV index', value: currentWeather.uvIndex.toString()),
              AdditionalInfoTile(
                title: 'Chance of rain',
                value: '${(currentDayForecast.pop * 100).round()}%',
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 3.h, top: 1.h, right: 5.w, left: 5.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AdditionalInfoTile(
                title: 'Sunrise',
                value: DateFormat.Hm().format(
                  currentDayForecast.sunrise.toUtc().add(timeZoneOffset),
                ),
              ),
              AdditionalInfoTile(
                title: 'Sunset',
                value: DateFormat.Hm().format(
                  currentDayForecast.sunset.toUtc().add(timeZoneOffset),
                ),
              ),
              AdditionalInfoTile(title: 'Pressure', value: '${currentWeather.pressure} mbar'),
            ],
          ),
        ),
      ],
    );
  }
}
