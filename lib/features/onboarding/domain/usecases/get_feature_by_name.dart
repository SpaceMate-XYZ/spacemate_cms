import 'package:dartz/dartz.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/core/usecases/usecase.dart';
import 'package:spacemate/features/onboarding/data/models/feature.dart';
import 'package:spacemate/features/onboarding/domain/repositories/onboarding_repository.dart';

class GetFeatureByName implements UseCase<Feature, GetFeatureByNameParams> {
  final OnboardingRepository repository;

  const GetFeatureByName(this.repository);

  @override
  Future<Either<Failure, Feature>> call(GetFeatureByNameParams params) async {
    return await repository.getFeatureByName(params.featureName);
  }
}

class GetFeatureByNameParams {
  final String featureName;

  GetFeatureByNameParams({required this.featureName});
} 