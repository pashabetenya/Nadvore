import 'index.dart';

class HourlyForecast extends Equatable {
  const HourlyForecast({
    required this.date,
    required this.temperature,
    required this.unitSystem,
    required this.pop,
    required this.iconCode,
  });

  final DateTime date;
  final double temperature;
  final UnitSystem unitSystem;
  final double pop;
  final String iconCode;

  @override
  List<Object?> get props => [date, temperature, pop, iconCode, unitSystem];

  HourlyForecast changeUnitSystem(UnitSystem newUnitSystem) {
    if (unitSystem == newUnitSystem) {
      return this;
    }

    final double newTemperature;

    switch (unitSystem) {
      case UnitSystem.imperial:
        newTemperature = convertFahrenheitToCelsius(temperature);
        break;

      case UnitSystem.metric:
        newTemperature = convertCelsiusToFahrenheit(temperature);
    }

    return HourlyForecast(
      pop: pop,
      date: date,
      temperature: newTemperature,
      iconCode: iconCode,
      unitSystem: newUnitSystem,
    );
  }
}
