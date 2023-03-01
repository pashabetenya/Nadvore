import 'index.dart';

class GetEntireWeather implements Case<EntireWeather, GetFullWeatherParams> {
  const GetEntireWeather(this.repository);

  final EntireWeatherRepository repository;

  @override
  Future<Either<Failure, EntireWeather>> call(GetFullWeatherParams params) =>
      repository.getEntireWeather(params.city);
}

class GetFullWeatherParams extends Equatable {
  const GetFullWeatherParams({required this.city});

  final City city;

  @override
  List<Object?> get props => [city];
}

final getEntireWeatherProvider = Provider(
  (references) => GetEntireWeather(references.watch(entireWeatherRepositoryProvider)),
);
