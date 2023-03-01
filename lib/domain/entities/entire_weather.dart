import 'index.dart';

class EntireWeather extends Equatable {
  const EntireWeather({
    required this.city,
    required this.timeZoneOffset,
    required this.currentWeather,
    required this.dailyForecasts,
    required this.hourlyForecasts,
    required this.unitSystem,
  });

  final City city;
  final Duration timeZoneOffset;
  final Weather currentWeather;
  final List<DailyForecast> dailyForecasts;
  final List<HourlyForecast> hourlyForecasts;
  final UnitSystem unitSystem;

  DailyForecast get currentDayForecast => minBy(
        dailyForecasts.where(
          (forecast) =>
              forecast.date.add(timeZoneOffset).weekday ==
              currentWeather.date.add(timeZoneOffset).weekday,
        ),
        (forecast) => forecast.date.difference(currentWeather.date).abs(),
      )!;

  @override
  List<Object> get props =>
      [city, timeZoneOffset, currentWeather, dailyForecasts, hourlyForecasts, unitSystem];

  EntireWeather changeUnitSystem(UnitSystem newUnitSystem) {
    if (unitSystem == newUnitSystem) {
      return this;
    }

    return EntireWeather(
      unitSystem: newUnitSystem,
      city: city,
      timeZoneOffset: timeZoneOffset,
      currentWeather: currentWeather.changeUnitSystem(newUnitSystem),
      hourlyForecasts: [
        for (final forecast in hourlyForecasts) forecast.changeUnitSystem(newUnitSystem)
      ],
      dailyForecasts: [
        for (final forecast in dailyForecasts) forecast.changeUnitSystem(newUnitSystem)
      ],
    );
  }
}
