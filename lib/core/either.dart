import 'index.dart';

@sealed
abstract class Either<L, R> extends Equatable {
  const Either();

  T fold<T>(T Function(L) left, T Function(R) right);

  Either<L, R2> map<R2>(R2 Function(R) f) => fold(
        Left.new,
        (right) => Right(f(right)),
      );

  R getOrElse(R Function() orElse) => fold((left) => orElse(), id);

  bool all(bool Function(R) f) => fold((left) => false, f);

  Either<L, R2> bind<R2>(Either<L, R2> Function(R) f) => fold(Left.new, f);

  @override
  bool get stringify => true;
}

class Left<L, R> extends Either<L, R> {
  const Left(this.value) : super();

  final L value;

  @override
  T fold<T>(T Function(L) left, T Function(Never) right) => left(value);

  @override
  List<Object?> get props => [value];
}

class Right<L, R> extends Either<L, R> {
  const Right(this.value) : super();

  final R value;

  @override
  T fold<T>(T Function(Never) left, T Function(R) right) => right(value);

  @override
  List<Object?> get props => [value];
}
