import 'index.dart';

class CityModel extends Equatable {
  const CityModel(this.city);

  final City city;

  @override
  List<Object?> get props => [city];
}
