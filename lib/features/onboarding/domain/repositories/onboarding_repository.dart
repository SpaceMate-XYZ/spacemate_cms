import 'package:fpdart/fpdart.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/core/network/network_info.dart';
import 'package:spacemate/features/onboarding/data/datasources/onboarding_remote_data_source.dart';
import 'package:spacemate/features/onboarding/data/models/spacemate_placeid_features_response.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, SpacematePlaceidFeaturesResponse>>
      getFeaturesWithOnboarding();
  
  Future<Either<Failure, SpacematePlaceidFeaturesResponse>>
      getFeatureByName(String featureName);
}

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OnboardingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, SpacematePlaceidFeaturesResponse>>
      getFeaturesWithOnboarding() async {
    if (await networkInfo.isConnected) {
      return await remoteDataSource.fetchFeaturesWithOnboarding();
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, SpacematePlaceidFeaturesResponse>>
      getFeatureByName(String featureName) async {
    if (await networkInfo.isConnected) {
      return await remoteDataSource.fetchFeatureByName(featureName);
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
