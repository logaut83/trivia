import 'dart:io';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  /* final DataConnectionChecker connectionChecker; */

  NetworkInfoImpl(/* this.connectionChecker */);

  @override
  Future<bool> get isConnected async {
    try {
      final result = await InternetAddress.lookup('numbersapi.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } on SocketException catch (_) {
      return Future.value(false);
    }
  }
}
