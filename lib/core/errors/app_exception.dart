class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException() : super('No internet connection');
}

class ServerException extends AppException {
  ServerException([String message = 'Server error']) : super(message);
}

class AuthException extends AppException {
  AuthException([String message = 'Authentication failed'])
    : super(message, statusCode: 401);
}

class ValidationException extends AppException {
  ValidationException([String message = 'Validation failed'])
    : super(message, statusCode: 400);
}
