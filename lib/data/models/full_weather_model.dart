import 'index.dart';
import 'package:weather/data/utils/date_time.dart' as date_time_utils;

class EntireWeatherModel extends Equatable {
  const EntireWeatherModel(this.weather);

  factory EntireWeatherModel.fromJson(
    Map<String, dynamic> json, {
    required City city,
  }) {
    final current = json['current'];

    return EntireWeatherModel(
      EntireWeather(
        city: city,
        unitSystem: UnitSystem.metric,
        timeZoneOffset: Duration(seconds: json['timezone_offset'] as int),
        currentWeather: Weather(
          unitSystem: UnitSystem.metric,
          temperature: (current['temp'] as num).toDouble(),
          tempFeel: (current['feels_like'] as num).toDouble(),
          windSpeed: (current['wind_speed'] as num).toDouble() * 3.6,
          condition: current['weather'][0]['id'] as int,
          description: current['weather'][0]['description'] as String,
          date: date_time_utils.fromUtcUnixTime(current['dt'] as int),
          iconCode: current['weather'][0]['icon'] as String,
          humidity: current['humidity'] as int,
          clouds: current['clouds'] as int,
          pressure: current['pressure'] as int,
          uvIndex: (current['uvi'] as num).toDouble(),
        ),
        dailyForecasts: (json['daily'] as List)
            .map(
              (forecast) => DailyForecast(
                unitSystem: UnitSystem.metric,
                maxTemperature: (forecast['temp']['max'] as num).toDouble(),
                minTemperature: (forecast['temp']['min'] as num).toDouble(),
                date: date_time_utils.fromUtcUnixTime(forecast['dt'] as int),
                iconCode: forecast['weather'][0]['icon'] as String,
                pop: (forecast['pop'] as num).toDouble(),
                sunrise: date_time_utils.fromUtcUnixTime(forecast['sunrise'] as int),
                sunset: date_time_utils.fromUtcUnixTime(forecast['sunset'] as int),
              ),
            )
            .toList(),
        hourlyForecasts: [
          for (final forecast in json['hourly'] as List)
            HourlyForecast(
              unitSystem: UnitSystem.metric,
              date: date_time_utils.fromUtcUnixTime(forecast['dt'] as int),
              iconCode: forecast['weather'][0]['icon'] as String,
              temperature: (forecast['temp'] as num).toDouble(),
              pop: (forecast['pop'] as num).toDouble(),
            ),
        ],
      ),
    );
  }

  final EntireWeather weather;

  @override
  List<Object?> get props => [weather];
}
