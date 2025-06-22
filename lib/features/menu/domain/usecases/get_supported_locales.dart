import 'package:fpdart/fpdart.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/core/usecases/usecase.dart';
import 'package:spacemate/features/menu/domain/repositories/menu_repository.dart';

/// Use case for getting supported locales for a place
class GetSupportedLocales implements UseCase<List<String>, GetSupportedLocalesParams> {
  final MenuRepository repository;

  const GetSupportedLocales(this.repository);

  @override
  TaskEither<Failure, List<String>> call(GetSupportedLocalesParams params) {
    return repository.getSupportedLocales(placeId: params.placeId);
  }
}

/// Parameters for the [GetSupportedLocales] use case
class GetSupportedLocalesParams {
  /// The ID of the place to get supported locales for
  final String placeId;

  const GetSupportedLocalesParams({required this.placeId});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetSupportedLocalesParams && other.placeId == placeId;
  }

  @override
  int get hashCode => placeId.hashCode;
}
