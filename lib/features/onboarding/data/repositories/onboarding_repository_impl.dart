import 'package:dartz/dartz.dart';
import 'package:spacemate/core/error/failures.dart';
import 'package:spacemate/features/onboarding/data/datasources/onboarding_remote_data_source.dart';
import 'package:spacemate/features/onboarding/data/datasources/onboarding_carousel_dao.dart';
import 'package:spacemate/features/onboarding/data/models/feature.dart';
import 'package:spacemate/features/onboarding/data/models/onboarding_slide.dart';
import 'package:spacemate/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:spacemate/core/network/network_info.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingRemoteDataSource remoteDataSource;
  final OnboardingCarouselDao carouselDao;
  final NetworkInfo networkInfo;

  OnboardingRepositoryImpl({
    required this.remoteDataSource,
    required this.carouselDao,
    required this.networkInfo,
  });

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
    try {
      // Try local cache first
      final localSlides = await carouselDao.getOnboardingSlides(featureName);
      if (localSlides.isNotEmpty) {
        // Start background fetch to update cache if network is available
        if (await networkInfo.isConnected) {
          remoteDataSource.getOnboardingCarousel(featureName).then((remoteResult) {
            remoteResult.fold((_) {}, (remoteSlides) async {
              await carouselDao.cacheOnboardingSlides(remoteSlides, featureName);
            });
          });
        }
        return Right(localSlides);
      }
      // Fallback to remote if needed
      if (await networkInfo.isConnected) {
        final remoteResult = await remoteDataSource.getOnboardingCarousel(featureName);
        return remoteResult.fold(
          (failure) => Left(failure),
          (remoteSlides) async {
            await carouselDao.cacheOnboardingSlides(remoteSlides, featureName);
            return Right(remoteSlides);
          },
        );
      }
      return const Left(CacheFailure('No onboarding carousel data available'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
} 