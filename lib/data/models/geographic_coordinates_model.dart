import 'index.dart';

class GeographicCoordinatesModel extends Equatable {
  const GeographicCoordinatesModel({
    required this.city,
    required this.long,
    required this.lat,
  });

  factory GeographicCoordinatesModel.fromRemoteJson(List<dynamic> json) =>
      GeographicCoordinatesModel(
        city: City(name: json[0]['name'] as String),
        long: (json[0]['lon'] as num).toDouble(),
        lat: (json[0]['lat'] as num).toDouble(),
      );

  factory GeographicCoordinatesModel.fromLocalJson(Map<String, dynamic> json) =>
      GeographicCoordinatesModel(
        city: City(name: json['city'] as String),
        long: (json['long'] as num).toDouble(),
        lat: (json['lat'] as num).toDouble(),
      );

  final City city;
  final double long;
  final double lat;

  Map<String, dynamic> toJson() => {'city': city.name, 'long': long, 'lat': lat};

  @override
  List<Object?> get props => [city, long, lat];
}
