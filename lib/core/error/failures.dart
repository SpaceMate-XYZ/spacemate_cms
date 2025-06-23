import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error', int? statusCode])
      : super(statusCode: statusCode);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure([super.message = 'Invalid input']);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Unauthorized'])
      : super(statusCode: 401);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found'])
      : super(statusCode: 404);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Request timed out']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Unknown error occurred']);
}
