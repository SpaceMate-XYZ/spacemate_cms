import 'package:fpdart/fpdart.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/core/usecases/usecase.dart';
import 'package:spacemate/features/onboarding/data/models/spacemate_placeid_features_response.dart';
import 'package:spacemate/features/onboarding/domain/repositories/onboarding_repository.dart';

class GetFeatureByName implements UseCase<SpacematePlaceidFeaturesResponse, String> {
  final OnboardingRepository repository;

  GetFeatureByName(this.repository);

  @override
  TaskEither<Failure, SpacematePlaceidFeaturesResponse> call(String featureName) {
    return TaskEither.tryCatch(
      () async => (await repository.getFeatureByName(featureName)).fold(
        (failure) => throw failure,
        (success) => success,
      ),
      (error, stackTrace) => error is Failure ? error : ServerFailure(error.toString()),
    );
  }
} 