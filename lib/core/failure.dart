import 'index.dart';

@sealed
abstract class Failure extends Equatable {
  const Failure();
}

class Connection extends Failure {
  const Connection();

  @override
  List<Object?> get props => const [];
}

class Server extends Failure {
  const Server();

  @override
  List<Object?> get props => const [];
}

class FailedToParseResponse extends Failure {
  const FailedToParseResponse();

  @override
  List<Object?> get props => const [];
}

class InvalidCity extends Failure {
  const InvalidCity(this.city);

  final String city;

  @override
  List<Object?> get props => [city];
}

class InvalidApiKey extends Failure {
  const InvalidApiKey();

  @override
  List<Object?> get props => const [];
}

class CallLimitExceeded extends Failure {
  const CallLimitExceeded();

  @override
  List<Object?> get props => const [];
}
