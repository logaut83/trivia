import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:triviaapp/core/error/failures.dart';

abstract class NetworkInfo {
  Future<Either<Failure, bool>> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl();

  @override
  Future<Either<Failure, bool>> get isConnected async {
    return Future.value(Right(true));
    // TODO unhandled error with InternetAdress.lookup
/*     try {
      String _adress = 'numbersapi.com';
      final result = await InternetAddress.lookup(_adress);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return Right(true);
      } else {
        return Right(false);
      }
    } catch (error) {
      return Left(ServerFailure());
    } */
  }
}
