import 'dart:convert';

import 'package:rogueteam/core/error/exceptions.dart';
import 'package:rogueteam/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint
  ///
  /// Throw a [ServerExecption] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint
  ///
  /// Throw a [ServerExecption] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl extends NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({@required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) =>
      _getTriviaFromUrl(
          'https://cors-anywhere.herokuapp.com/http://numbersapi.com/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() => _getTriviaFromUrl(
      'https://cors-anywhere.herokuapp.com/http://numbersapi.com/random');

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    Uri uri = Uri.parse(url);
    final response =
        await client.get(uri, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
