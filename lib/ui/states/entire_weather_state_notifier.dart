import 'index.dart';

@sealed
@immutable
abstract class EntireWeatherState extends Equatable {
  const EntireWeatherState();

  EntireWeather? get entireWeather;
}

class Empty extends EntireWeatherState {
  const Empty();

  @override
  EntireWeather? get entireWeather => null;

  @override
  List<Object?> get props => const [];
}

class Loading extends EntireWeatherState {
  const Loading({this.entireWeather});

  @override
  final EntireWeather? entireWeather;

  @override
  List<Object?> get props => [entireWeather];
}

class Loaded extends EntireWeatherState {
  const Loaded(this.entireWeather);

  @override
  final EntireWeather entireWeather;

  @override
  List<Object?> get props => [entireWeather];
}

class Error extends EntireWeatherState {
  const Error(this.failure, {required this.entireWeather});

  final Failure failure;

  @override
  final EntireWeather? entireWeather;

  @override
  List<Object?> get props => [failure, entireWeather];
}

class EntireWeatherStateNotifier extends StateNotifier<EntireWeatherState> {
  EntireWeatherStateNotifier(
    this.getEntireWeather,
    this.getCity,
    this.getUnitSystem,
  ) : super(const Empty());

  final GetEntireWeather getEntireWeather;
  final GetCity getCity;
  final GetUnitSystem getUnitSystem;

  Future<Either<Failure, EntireWeather>> _loadWeather() async {
    final cityEither = await getCity(const NoParams());

    if (cityEither is Left) {
      return Left((cityEither as Left<Failure, City>).value);
    }

    final city = (cityEither as Right<Failure, City>).value;

    final entireWeatherEither = await getEntireWeather(GetFullWeatherParams(city: city));

    if (entireWeatherEither is Left) {
      return Left((entireWeatherEither as Left<Failure, EntireWeather>).value);
    }

    final entireWeather = (entireWeatherEither as Right<Failure, EntireWeather>).value;

    final unitSystemEither = await getUnitSystem(const NoParams());

    if (unitSystemEither is Left) {
      return Left((unitSystemEither as Left<Failure, UnitSystem>).value);
    }

    final unitSystem = (unitSystemEither as Right<Failure, UnitSystem>).value;

    return Right(entireWeather.changeUnitSystem(unitSystem));
  }

  Future<void> loadEntireWeather() async {
    state = Loading(entireWeather: state.entireWeather);

    state = (await _loadWeather()).fold(
      (failure) => Error(failure, entireWeather: state.entireWeather),
      Loaded.new,
    );
  }

  Future<void> _changeUnitSystem(UnitSystem unitSystem) async {
    final state = this.state;

    final entireWeather = state.entireWeather;

    if (entireWeather == null || entireWeather.unitSystem == unitSystem) return;

    final newEntireWeather = entireWeather.changeUnitSystem(unitSystem);

    if (state is Error) {
      this.state = Error(state.failure, entireWeather: newEntireWeather);
    } else if (state is Loading) {
      this.state = Loading(entireWeather: newEntireWeather);
    } else if (state is Loaded) {
      this.state = Loaded(newEntireWeather);
    }
  }
}

final entireWeatherStateNotifierProvider =
    StateNotifierProvider<EntireWeatherStateNotifier, EntireWeatherState>(
  (ref) {
    final notifier = EntireWeatherStateNotifier(
      ref.watch(getEntireWeatherProvider),
      ref.watch(getCityProvider),
      ref.watch(getUnitSystemProvider),
    );

    ref.listen<UnitSystemState>(
      unitSystemStateNotifierProvider,
      (prev, next) {
        if (next.unitSystem != null) {
          notifier._changeUnitSystem(next.unitSystem!);
        }
      },
    );

    return notifier;
  },
);
