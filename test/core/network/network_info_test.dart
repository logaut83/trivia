import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:triviaapp/core/network/network_info.dart';

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NetworkInfoImpl networkInfo;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    networkInfo = NetworkInfoImpl();
    mockNetworkInfo = MockNetworkInfo();
  });

  group('isConnected', () {
    test('[ONLINE TEST] should forward the call to networkInfo.isConnected',
        () async {
      // arange
      final tHasConnectionFuture = true;
      // act
      final result = await networkInfo.isConnected;
      // assert
      expect(result, equals(tHasConnectionFuture));
    });
    test(
        'should forward the call to networkInfo.isConnected and return false if not connected to api',
        () async {
      // arange
      final tHasConnectionFuture = false;
      when(mockNetworkInfo.isConnected).thenAnswer((_) => Future.value(false));
      // act
      final result = await mockNetworkInfo.isConnected;
      // assert
      expect(result, equals(tHasConnectionFuture));
    });
  });
}
