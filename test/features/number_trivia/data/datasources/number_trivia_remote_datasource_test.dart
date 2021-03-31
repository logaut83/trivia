import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rogueteam/core/error/exceptions.dart';
import 'package:rogueteam/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:rogueteam/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('something wrong', 404));
  }

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    final url = Uri.parse(
        ('https://cors-anywhere.herokuapp.com/http://numbersapi.com/$tNumber'));
    test(
        'should perform a get request on a URL with number being the endpoint with application/json content-type',
        () async {
      // arange
      setUpMockHttpClientSuccess200();
      // act
      dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockHttpClient
          .get(url, headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when response code is 200', () async {
      // arange
      setUpMockHttpClientSuccess200();
      // act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw ServerExeption when the responde code is 404 or other',
        () async {
      // arange
      setUpMockHttpClientFailure404();
      // act
      final call = dataSource.getConcreteNumberTrivia;
      // assert
      expect(() => call(tNumber), throwsA(isA<ServerException>()));
    });
  });

  /// Get Random Number Trivia
  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    final url = Uri.parse(
        ('https://cors-anywhere.herokuapp.com/http://numbersapi.com/random'));
    test(
        'should perform a get request on a URL with number being the endpoint with application/json content-type',
        () async {
      // arange
      setUpMockHttpClientSuccess200();
      // act
      dataSource.getRandomNumberTrivia();
      // assert
      verify(mockHttpClient
          .get(url, headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when response code is 200', () async {
      // arange
      setUpMockHttpClientSuccess200();
      // act
      final result = await dataSource.getRandomNumberTrivia();
      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw ServerExeption when the responde code is 404 or other',
        () async {
      // arange
      setUpMockHttpClientFailure404();
      // act
      final call = dataSource.getRandomNumberTrivia;
      // assert
      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });
}
