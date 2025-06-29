import 'package:dartz/dartz.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/core/usecases/usecase.dart';
import 'package:spacemate/features/onboarding/data/models/feature.dart';
import 'package:spacemate/features/onboarding/domain/repositories/onboarding_repository.dart';

class GetFeaturesWithOnboarding implements UseCase<List<Feature>, NoParams> {
  final OnboardingRepository repository;

  const GetFeaturesWithOnboarding(this.repository);

  @override
  Future<Either<Failure, List<Feature>>> call(NoParams params) async {
    return await repository.getFeatures();
  }
}
