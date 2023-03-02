import 'index.dart';

class Weather extends Equatable {
  const Weather({
    required this.date,
    required this.temperature,
    required this.windSpeed,
    required this.tempFeel,
    required this.condition,
    required this.humidity,
    required this.clouds,
    required this.pressure,
    required this.uvIndex,
    required this.description,
    required this.iconCode,
    required this.unitSystem,
  });

  final DateTime date;
  final double temperature;
  final int condition;
  final int humidity;
  final double windSpeed;
  final double tempFeel;
  final int clouds;
  final int pressure;
  final double uvIndex;
  final String description;
  final String iconCode;
  final UnitSystem unitSystem;

  @override
  List<Object?> get props => [
        date,
        temperature,
        windSpeed,
        tempFeel,
        condition,
        humidity,
        clouds,
        pressure,
        uvIndex,
        description,
        iconCode,
        unitSystem,
      ];

  Weather changeUnitSystem(UnitSystem newUnitSystem) {
    if (unitSystem == newUnitSystem) {
      return this;
    }

    final double newTemperature;
    final double newTempFeel;
    final double newWindSpeed;

    switch (unitSystem) {
      case UnitSystem.imperial:
        newTemperature = convertFahrenheitToCelsius(temperature);
        newTempFeel = convertFahrenheitToCelsius(tempFeel);
        newWindSpeed = convertMilesPerHourToKilometersPerHour(windSpeed);
        break;

      case UnitSystem.metric:
        newTemperature = convertCelsiusToFahrenheit(temperature);
        newTempFeel = convertCelsiusToFahrenheit(tempFeel);
        newWindSpeed = convertKilometersPerHourToMilesPerHour(windSpeed);
    }

    return Weather(
      date: date,
      temperature: newTemperature,
      windSpeed: newWindSpeed,
      humidity: humidity,
      clouds: clouds,
      tempFeel: newTempFeel,
      condition: condition,
      pressure: pressure,
      uvIndex: uvIndex,
      description: description,
      iconCode: iconCode,
      unitSystem: newUnitSystem,
    );
  }
}
