import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:rogueteam/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:rogueteam/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(text: 'Test text', number: 1);

  test(
    'should be a subclass of number Trivia entity',
    () async {
      //assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group('fromJson', () {
    test('should return a valid model whene the json number is integer',
        () async {
      // arange
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));
      // act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // assert
      expect(result, tNumberTriviaModel);
    });

    test('should return a valid model whene the json number is a double',
        () async {
      // arange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));
      // act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // assert
      expect(result, tNumberTriviaModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // act
      final result = tNumberTriviaModel.toJson();
      // aseert
      final expectedMap = {"text": "Test text", "number": 1};
      expect(result, expectedMap);
    });
  });
}
