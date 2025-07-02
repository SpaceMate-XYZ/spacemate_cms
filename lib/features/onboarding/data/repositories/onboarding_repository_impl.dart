import 'package:dartz/dartz.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/features/onboarding/data/datasources/onboarding_remote_data_source.dart';
import 'package:spacemate/features/onboarding/data/models/feature.dart';
import 'package:spacemate/features/onboarding/data/models/onboarding_slide.dart';
import 'package:spacemate/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingRemoteDataSource remoteDataSource;

  OnboardingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Feature>>> getFeatures() async {
    return await remoteDataSource.getFeatures();
  }

  @override
  Future<Either<Failure, Feature>> getFeatureByName(String featureName) async {
    return await remoteDataSource.getFeatureByName(featureName);
  }

  @override
  Future<Either<Failure, List<OnboardingSlide>>> getOnboardingCarousel(String featureName) async {
    return await remoteDataSource.getOnboardingCarousel(featureName);
  }
} 