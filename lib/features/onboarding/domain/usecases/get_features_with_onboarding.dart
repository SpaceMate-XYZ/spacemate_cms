import 'package:fpdart/fpdart.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/core/usecases/usecase.dart';
import 'package:spacemate/features/onboarding/data/models/spacemate_placeid_features_response.dart';
import 'package:spacemate/features/onboarding/domain/repositories/onboarding_repository.dart';

class GetFeaturesWithOnboarding
    implements UseCase<SpacematePlaceidFeaturesResponse, NoParams> {
  final OnboardingRepository repository;

  GetFeaturesWithOnboarding(this.repository);

  @override
  TaskEither<Failure, SpacematePlaceidFeaturesResponse> call(NoParams params) {
    return TaskEither.tryCatch(
      () async => (await repository.getFeaturesWithOnboarding()).fold(
        (failure) => throw failure,
        (success) => success,
      ),
      (error, stackTrace) => error is Failure ? error : ServerFailure(error.toString()),
    );
  }
}
