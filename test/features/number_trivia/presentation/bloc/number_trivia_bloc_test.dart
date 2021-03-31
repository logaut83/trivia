import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rogueteam/core/error/failures.dart';
import 'package:rogueteam/core/usecases/usecase.dart';
import 'package:rogueteam/core/util/input_converter.dart';
import 'package:rogueteam/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:rogueteam/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:rogueteam/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:rogueteam/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  InputConverter inputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    inputConverter = InputConverter();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: inputConverter,
    );
  });

  test('initialState should be NumberTriviaIntitalState', () {
    expect(bloc.state, equals(NumberTriviaIntitalState()));
  });

  group('getTriviaForConcreteNumberBloc', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');
    blocTest(
      'should return a LoadedState with trivia when input is valid',
      build: () {
        when(mockGetConcreteNumberTrivia.call(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        return bloc;
      },
      act: (blocB) => blocB.add(GetTriviaForConcreteNumberEvent('12')),
      expect: () => [LoadingState(), LoadedState(trivia: tNumberTrivia)],
    );

    blocTest(
      'shoud emit LoadingState then ErrorState when input is invalid',
      build: () => bloc,
      act: (bloc) => bloc.add(GetTriviaForConcreteNumberEvent('-124')),
      expect: () => [ErrorState(message: INVALID_INPUT_FAILURE_MESSAGE)],
    );

    blocTest(
      'should return ErrorState with Cache failure message',
      build: () {
        when(mockGetConcreteNumberTrivia.call(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForConcreteNumberEvent('12')),
      expect: () => [
        LoadingState(),
        ErrorState(message: CACHE_FAILURE_MESSAGE),
      ],
    );
    blocTest(
      'should return ErrorState with Server failure message',
      build: () {
        when(mockGetConcreteNumberTrivia.call(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForConcreteNumberEvent('12')),
      expect: () => [
        LoadingState(),
        ErrorState(message: SERVER_FAILURE_MESSAGE),
      ],
    );
  });

  group('getTriviaForRandomNumberBloc', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');
    blocTest(
      'should return a LoadedState with trivia',
      build: () {
        when(mockGetRandomNumberTrivia.call(NoParams()))
            .thenAnswer((_) async => Right(tNumberTrivia));
        return bloc;
      },
      act: (blocB) => blocB.add(GetTriviaForRandomNumberEvent()),
      expect: () => [LoadingState(), LoadedState(trivia: tNumberTrivia)],
    );

    blocTest(
      'should return ErrorState with Cache failure message',
      build: () {
        when(mockGetRandomNumberTrivia.call(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForRandomNumberEvent()),
      expect: () => [
        LoadingState(),
        ErrorState(message: CACHE_FAILURE_MESSAGE),
      ],
    );

    blocTest(
      'should return ErrorState with Server failure message',
      build: () {
        when(mockGetRandomNumberTrivia.call(NoParams()))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForRandomNumberEvent()),
      expect: () => [
        LoadingState(),
        ErrorState(message: SERVER_FAILURE_MESSAGE),
      ],
    );

    blocTest(
      'should return a LoadedState with trivia when input is valid',
      build: () {
        when(mockGetRandomNumberTrivia.call(NoParams()))
            .thenAnswer((_) async => Right(tNumberTrivia));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForRandomNumberEvent()),
      expect: () => [LoadingState(), LoadedState(trivia: tNumberTrivia)],
    );
  });
}
