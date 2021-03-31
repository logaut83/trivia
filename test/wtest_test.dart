import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  Failure([this.properties = const <dynamic>[]]);
  final List properties;
  @override
  List<Object> get props => [properties];
}

// General failures
class ServerFailure extends Failure {
  final String str;

  ServerFailure(this.str) : super([str]);
}

class CacheFailure extends Failure {}

void main() {}
