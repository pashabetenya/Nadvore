import 'index.dart';

abstract class Case<R, P> {
  Future<Either<Failure, R>> call(P params);
}

@sealed
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => const [];
}
