part of 'number_trivia_bloc.dart';

@immutable
abstract class NumberTriviaState extends Equatable {
  NumberTriviaState([this.propeties = const <dynamic>[]]);
  final List propeties;
  @override
  List<Object> get props => [propeties];
}

class NumberTriviaIntitalState extends NumberTriviaState {}

class LoadingState extends NumberTriviaState {}

class LoadedState extends NumberTriviaState {
  final NumberTrivia trivia;

  LoadedState({@required this.trivia}) : super([trivia]);
}

class ErrorState extends NumberTriviaState {
  final String message;

  ErrorState({@required this.message}) : super([message]);
}
