import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

String handleError(Exception error) {
  var errorDescription = '';
  if (error is DioError) {
    switch (error.type) {
      case DioErrorType.cancel:
        errorDescription = 'Request to API server was cancelled';
        break;
      case DioErrorType.connectTimeout:
        errorDescription = 'Connection timeout with API server';
        break;
      case DioErrorType.other:
        errorDescription =
            'Connection to API server failed due to internet connection';
        break;
      case DioErrorType.receiveTimeout:
        errorDescription = 'Receive timeout in connection with API server';
        break;
      case DioErrorType.response:
        errorDescription =
            'Received invalid status code: ${error.response?.statusCode}';
        break;
      case DioErrorType.sendTimeout:
        errorDescription = 'Send timeout in connection with API server';
        break;
    }
  } else if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'user-not-found':
        errorDescription = 'User does not exist.';
        break;
      case 'wrong-password':
        errorDescription = 'Incorrect password.';
        break;
    }
  } else {
    errorDescription = 'Unexpected error occured';
  }
  return errorDescription;
}
