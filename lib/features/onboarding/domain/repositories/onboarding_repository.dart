import 'package:dartz/dartz.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/features/onboarding/data/datasources/onboarding_remote_data_source.dart';
import 'package:spacemate/features/onboarding/data/models/feature.dart';
import 'package:spacemate/features/onboarding/data/models/onboarding_carousel.dart';
import 'package:spacemate/features/onboarding/data/models/onboarding_slide.dart';

abstract class OnboardingRepository {
  /// Fetches all features from the remote data source
  /// 
  /// Returns [List<Feature>] on success or [Failure] on error
  Future<Either<Failure, List<Feature>>> getFeatures();

  /// Fetches a specific feature by name
  /// 
  /// [featureName] - The name of the feature to fetch
  /// Returns [Feature] on success or [Failure] on error
  Future<Either<Failure, Feature>> getFeatureByName(String featureName);

  /// Fetches the onboarding carousel for a specific feature
  /// 
  /// [featureName] - The name of the feature to get onboarding for
  /// Returns [List<OnboardingSlide>] on success or [Failure] on error
  Future<Either<Failure, List<OnboardingSlide>>> getOnboardingCarousel(String featureName);
}

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
