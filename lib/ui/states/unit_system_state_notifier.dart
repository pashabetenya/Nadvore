import 'index.dart';

@sealed
@immutable
abstract class UnitSystemState extends Equatable {
  const UnitSystemState();

  UnitSystem? get unitSystem => null;

  @override
  List<Object?> get props => const [];
}

class Empty extends UnitSystemState {
  const Empty();
}

class Loading extends UnitSystemState {
  const Loading();
}

class Loaded extends UnitSystemState {
  const Loaded(this.unitSystem);

  @override
  final UnitSystem unitSystem;

  @override
  List<Object?> get props => [unitSystem];
}

class Error extends UnitSystemState {
  const Error(this.failure, {this.unitSystem});

  final Failure failure;

  @override
  final UnitSystem? unitSystem;

  @override
  List<Object?> get props => [failure, unitSystem];
}

class UnitSystemStateNotifier extends StateNotifier<UnitSystemState> {
  UnitSystemStateNotifier(this.getUnit, this.setUnit) : super(const Empty());

  final GetUnitSystem getUnit;
  final SetUnitSystem setUnit;

  Future<void> loadUnitSystem() async {
    state = const Loading();
    final data = await getUnit(const NoParams());
    state = data.fold(Error.new, Loaded.new);
  }

  Future<void> setUnitSystem(UnitSystem unitSystem) async {
    (await setUnit(SetUnitSystemParams(unitSystem))).fold((failure) {
      state = Error(failure, unitSystem: state.unitSystem);
    }, (context) {
      state = Loaded(unitSystem);
    });
  }
}

final unitSystemStateNotifierProvider =
    StateNotifierProvider<UnitSystemStateNotifier, UnitSystemState>(
  (references) => UnitSystemStateNotifier(
    references.watch(getUnitSystemProvider),
    references.watch(setUnitSystemProvider),
  ),
);
