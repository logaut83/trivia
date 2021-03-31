part of 'number_trivia_bloc.dart';

@immutable
abstract class NumberTriviaEvent extends Equatable {
  NumberTriviaEvent([this.properties = const <dynamic>[]]);
  final List properties;
  @override
  List<Object> get props => [properties];
}

// ignore: must_be_immutable
class GetTriviaForConcreteNumberEvent extends NumberTriviaEvent {
  final String numberString;

  GetTriviaForConcreteNumberEvent(this.numberString) : super([numberString]);
}

class GetTriviaForRandomNumberEvent extends NumberTriviaEvent {}
