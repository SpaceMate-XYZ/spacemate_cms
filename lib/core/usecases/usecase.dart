import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../error/failures.dart';

/// Base class for all use cases
/// 
/// [Type] is the return type of the use case
/// [Params] is the parameter type that the use case accepts
abstract class UseCase<Type, Params> {
  /// Executes the use case with the given parameters
  TaskEither<Failure, Type> call(Params params);
}

/// A use case with no parameters
class NoParams extends Equatable {
  const NoParams();
  @override
  List<Object> get props => [];
}
