import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:triviaapp/core/error/exceptions.dart';
import 'package:triviaapp/core/error/failures.dart';
import 'package:triviaapp/core/network/network_info.dart';
import 'package:triviaapp/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:triviaapp/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:triviaapp/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:triviaapp/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:triviaapp/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDatasource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDatasource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDatasource mockRemoteDatasource;
  MockLocalDatasource mockLocalDatasource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDatasource = MockRemoteDatasource();
    mockLocalDatasource = MockLocalDatasource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDatasource,
      localDataSource: mockLocalDatasource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'Test text', number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () async {
      // arange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'should return remote data when the call to remote datasource is successful',
          () async {
        // arange
        when(mockRemoteDatasource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockRemoteDatasource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });
      test(
          'should cache the data localy when the call to remote datasource is successful',
          () async {
        // arange
        when(mockRemoteDatasource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockRemoteDatasource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDatasource.cacheNumberTrivia(tNumberTriviaModel));
      });
      test(
          'should return server failure when the call to remote datasource is unsuccessful',
          () async {
        // arange
        when(mockRemoteDatasource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockRemoteDatasource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestOffline(() {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
          'should return last locally cached data when the cached data is present',
          () async {
        // arange
        when(mockLocalDatasource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verifyZeroInteractions(mockRemoteDatasource);
        verify(mockLocalDatasource.getLastNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });
      test('should return CacheFailure when there is no cached data present',
          () async {
        // arange
        when(mockLocalDatasource.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        verifyZeroInteractions(mockRemoteDatasource);
        verify(mockLocalDatasource.getLastNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });
  });

  /// test for Random Number trivia
  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(text: 'Test text', number: 1);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () async {
      // arange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.getRandomNumberTrivia();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'should return remote data when the call to remote datasource is successful',
          () async {
        // arange
        when(mockRemoteDatasource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verify(mockRemoteDatasource.getRandomNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });
      test(
          'should cache the data localy when the call to remote datasource is successful',
          () async {
        // arange
        when(mockRemoteDatasource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        await repository.getRandomNumberTrivia();
        // assert
        verify(mockRemoteDatasource.getRandomNumberTrivia());
        verify(mockLocalDatasource.cacheNumberTrivia(tNumberTriviaModel));
      });
      test(
          'should return server failure when the call to remote datasource is unsuccessful',
          () async {
        // arange
        when(mockRemoteDatasource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verify(mockRemoteDatasource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDatasource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestOffline(() {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
          'should return last locally cached data when the cached data is present',
          () async {
        // arange
        when(mockLocalDatasource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verifyZeroInteractions(mockRemoteDatasource);
        verify(mockLocalDatasource.getLastNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });
      test('should return CacheFailure when there is no cached data present',
          () async {
        // arange
        when(mockLocalDatasource.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result = await repository.getRandomNumberTrivia();
        // assert
        verifyZeroInteractions(mockRemoteDatasource);
        verify(mockLocalDatasource.getLastNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });
  });
}
