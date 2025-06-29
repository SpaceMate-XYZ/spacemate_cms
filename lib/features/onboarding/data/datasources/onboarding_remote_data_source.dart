import 'package:dartz/dartz.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/core/network/dio_client.dart';
import 'package:spacemate/features/onboarding/data/models/feature.dart';
import 'package:spacemate/features/onboarding/data/models/onboarding_carousel.dart';
import 'package:spacemate/features/onboarding/data/models/onboarding_slide.dart';
import 'package:spacemate/features/onboarding/data/models/spacemate_placeid_features_response.dart';
import 'dart:developer' as developer;

abstract class OnboardingRemoteDataSource {
  Future<Either<Failure, List<Feature>>> getFeatures();
  Future<Either<Failure, Feature>> getFeatureByName(String featureName);
  Future<Either<Failure, List<OnboardingSlide>>> getOnboardingCarousel(String featureName);
  Future<Either<Failure, SpacematePlaceidFeaturesResponse>> fetchFeaturesWithOnboarding();
}

class OnboardingRemoteDataSourceImpl implements OnboardingRemoteDataSource {
  final DioClient dioClient;

  OnboardingRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, List<Feature>>> getFeatures() async {
    try {
      developer.log('OnboardingRemoteDataSource: Fetching all features');
      final response = await dioClient.get(
        '/api/screens',
        queryParameters: {
          'populate': '*',
        },
      );
      
      developer.log('OnboardingRemoteDataSource: Response status: ${response.statusCode}');
      developer.log('OnboardingRemoteDataSource: Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final featuresResponse = SpacematePlaceidFeaturesResponse.fromJson(response.data);
        developer.log('OnboardingRemoteDataSource: Parsed ${featuresResponse.data.length} features');
        for (final feature in featuresResponse.data) {
          developer.log('OnboardingRemoteDataSource: Feature: ${feature.attributes.name}, onboarding slides: ${feature.attributes.onboardingCarousel?.length ?? 0}');
        }
        return Right(featuresResponse.data);
      } else {
        return Left(ServerFailure('Failed to load features'));
      }
    } catch (e) {
      developer.log('OnboardingRemoteDataSource: Error in getFeatures: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Feature>> getFeatureByName(String featureName) async {
    try {
      developer.log('OnboardingRemoteDataSource: Getting feature by name: $featureName');
      final response = await dioClient.get(
        '/api/spacemate-placeid-features',
        queryParameters: {
          'filters[feature_name][\$eq]': featureName,
          'populate': '*',
        },
      );

      developer.log('OnboardingRemoteDataSource: Response status: ${response.statusCode}');
      developer.log('OnboardingRemoteDataSource: Response data: ${response.data}');

      if (response.statusCode == 200) {
        final featuresResponse = SpacematePlaceidFeaturesResponse.fromJson(response.data);
        developer.log('OnboardingRemoteDataSource: Found ${featuresResponse.data.length} features for $featureName');
        
        if (featuresResponse.data.isNotEmpty) {
          final feature = featuresResponse.data.first;
          developer.log('OnboardingRemoteDataSource: Returning feature: ${feature.attributes.name}');
          return Right(feature);
        } else {
          developer.log('OnboardingRemoteDataSource: No feature found for: $featureName');
          return Left(NotFoundFailure('Feature not found'));
        }
      } else {
        developer.log('OnboardingRemoteDataSource: API call failed with status: ${response.statusCode}');
        return Left(ServerFailure('Failed to load feature'));
      }
    } catch (e) {
      developer.log('OnboardingRemoteDataSource: Error in getFeatureByName: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OnboardingSlide>>> getOnboardingCarousel(String featureName) async {
    try {
      developer.log('OnboardingRemoteDataSource: Getting onboarding carousel for: $featureName');
      final response = await dioClient.get(
        '/api/spacemate-placeid-features',
        queryParameters: {
          'filters[feature_name][\$eq]': featureName,
          'populate': '*',
        },
      );

      developer.log('OnboardingRemoteDataSource: Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final featuresResponse = SpacematePlaceidFeaturesResponse.fromJson(response.data);
        developer.log('OnboardingRemoteDataSource: Found ${featuresResponse.data.length} features for $featureName');
        
        if (featuresResponse.data.isNotEmpty) {
          final feature = featuresResponse.data.first;
          developer.log('OnboardingRemoteDataSource: Feature has ${feature.attributes.onboardingCarousel?.length ?? 0} slides');
          
          if (feature.attributes.onboardingCarousel != null) {
            return Right(feature.attributes.onboardingCarousel!);
          } else {
            developer.log('OnboardingRemoteDataSource: No onboarding carousel found for feature');
            return Left(NotFoundFailure('Onboarding carousel not found for feature'));
          }
        } else {
          developer.log('OnboardingRemoteDataSource: No feature found for: $featureName');
          return Left(NotFoundFailure('Feature not found'));
        }
      } else {
        developer.log('OnboardingRemoteDataSource: API call failed with status: ${response.statusCode}');
        return Left(ServerFailure('Failed to load onboarding carousel'));
      }
    } catch (e) {
      developer.log('OnboardingRemoteDataSource: Error in getOnboardingCarousel: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SpacematePlaceidFeaturesResponse>> fetchFeaturesWithOnboarding() async {
    try {
      final response = await dioClient.get(
        '/api/screens',
        queryParameters: {
          'populate': '*',
        },
      );
      
      if (response.statusCode == 200) {
        final featuresResponse = SpacematePlaceidFeaturesResponse.fromJson(response.data);
        return Right(featuresResponse);
      } else {
        return Left(ServerFailure('Failed to load features with onboarding'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
