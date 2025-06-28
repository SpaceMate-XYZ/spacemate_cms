import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:spacemate/core/error/exceptions.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/core/network/dio_client.dart';
import 'package:spacemate/features/onboarding/data/models/spacemate_placeid_features_response.dart';

abstract class OnboardingRemoteDataSource {
  Future<Either<Failure, SpacematePlaceidFeaturesResponse>>
      fetchFeaturesWithOnboarding();
  
  Future<Either<Failure, SpacematePlaceidFeaturesResponse>>
      fetchFeatureByName(String featureName);
}

class OnboardingRemoteDataSourceImpl implements OnboardingRemoteDataSource {
  final DioClient dioClient;

  OnboardingRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Either<Failure, SpacematePlaceidFeaturesResponse>>
      fetchFeaturesWithOnboarding() async {
    try {
      final response = await dioClient.get(
        '/api/spacemate-placeid-features',
        queryParameters: {
          'populate': '*',
        },
      );
      
      if (response.statusCode == 200) {
        return Right(
            SpacematePlaceidFeaturesResponse.fromJson(response.data));
      } else {
        return Left(ServerFailure(
            'Failed to load onboarding data: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors first
      if (e.response != null) {
        final responseData = e.response?.data;
        String? errorMessage;
        
        if (responseData is Map) {
          errorMessage = responseData['error']?['message']?.toString();
        }
        
        return Left(ServerFailure(
          errorMessage ?? e.message ?? 'An unknown network error occurred',
        ));
      }
      return Left(ServerFailure(e.message ?? 'An unknown network error occurred'));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SpacematePlaceidFeaturesResponse>>
      fetchFeatureByName(String featureName) async {
    try {
      final response = await dioClient.get(
        '/api/spacemate-placeid-features',
        queryParameters: {
          'filters[feature_name][\$eq]': featureName,
          'populate': '*',
        },
      );
      
      if (response.statusCode == 200) {
        return Right(
            SpacematePlaceidFeaturesResponse.fromJson(response.data));
      } else {
        return Left(ServerFailure(
            'Failed to load onboarding data for $featureName: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors first
      if (e.response != null) {
        final responseData = e.response?.data;
        String? errorMessage;
        
        if (responseData is Map) {
          errorMessage = responseData['error']?['message']?.toString();
        }
        
        return Left(ServerFailure(
          errorMessage ?? e.message ?? 'An unknown network error occurred',
        ));
      }
      return Left(ServerFailure(e.message ?? 'An unknown network error occurred'));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
