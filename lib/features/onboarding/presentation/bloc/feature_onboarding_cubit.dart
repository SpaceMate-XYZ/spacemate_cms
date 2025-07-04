import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spacemate/core/utils/feature_name_mapper.dart';
import 'package:spacemate/features/onboarding/data/models/onboarding_slide.dart';
import 'package:spacemate/features/onboarding/domain/usecases/get_features_with_onboarding.dart';
import 'package:spacemate/features/onboarding/domain/usecases/get_feature_by_name.dart';
import 'dart:developer' as developer;

part 'feature_onboarding_cubit.freezed.dart';
part 'feature_onboarding_state.dart';

class FeatureOnboardingCubit extends Cubit<FeatureOnboardingState> {
  final GetFeaturesWithOnboarding getFeaturesWithOnboarding;
  final GetFeatureByName getFeatureByName;
  final SharedPreferences sharedPreferences;

  FeatureOnboardingCubit({
    required this.getFeaturesWithOnboarding,
    required this.getFeatureByName,
    required this.sharedPreferences,
  }) : super(const FeatureOnboardingState.initial());

  Future<void> checkOnboardingStatus(String menuLabel, String? navigationTarget) async {
    developer.log('FeatureOnboardingCubit: Checking onboarding status for menu label: $menuLabel');
    developer.log('FeatureOnboardingCubit: Navigation target: $navigationTarget');
    emit(const FeatureOnboardingState.loading());
    
    // Map the menu label to the feature name
    final featureName = FeatureNameMapper.getFeatureNameFromLabel(menuLabel);
    developer.log('FeatureOnboardingCubit: Mapped menu label "$menuLabel" to feature name: $featureName');
    
    if (featureName == null) {
      developer.log('FeatureOnboardingCubit: No feature mapping found for menu label: $menuLabel');
      developer.log('FeatureOnboardingCubit: This will cause navigation to default behavior');
      emit(FeatureOnboardingState.onboardingNotNeeded(navigationTarget: navigationTarget));
      return;
    }

    final hasSeenOnboarding = sharedPreferences.getBool('hasSeenOnboarding_$featureName') ?? false;
    developer.log('FeatureOnboardingCubit: Has seen onboarding for $featureName: $hasSeenOnboarding');

    if (hasSeenOnboarding) {
      developer.log('FeatureOnboardingCubit: User has already seen onboarding, navigating to target');
      emit(FeatureOnboardingState.onboardingNotNeeded(navigationTarget: navigationTarget));
    } else {
      developer.log('FeatureOnboardingCubit: User has not seen onboarding, fetching onboarding carousel for $featureName');
      try {
        // Use the repository's caching logic for onboarding slides
        final result = await getFeaturesWithOnboarding.repository.getOnboardingCarousel(featureName);
        result.fold(
          (failure) {
            developer.log('FeatureOnboardingCubit: Failed to load onboarding carousel: ${failure.message}');
            emit(FeatureOnboardingState.error(message: failure.message));
          },
          (slides) {
            if (slides.isNotEmpty) {
              developer.log('FeatureOnboardingCubit: Loaded ${slides.length} onboarding slides for $featureName');
              emit(FeatureOnboardingState.onboardingNeeded(slides: slides));
            } else {
              developer.log('FeatureOnboardingCubit: No onboarding slides found, navigating to target');
              emit(FeatureOnboardingState.onboardingNotNeeded(navigationTarget: navigationTarget));
            }
          },
        );
      } catch (e) {
        developer.log('FeatureOnboardingCubit: Unexpected error: $e');
        emit(FeatureOnboardingState.error(message: 'Unexpected error: $e'));
      }
    }
  }

  Future<void> setOnboardingCompleted(String featureName) async {
    developer.log('FeatureOnboardingCubit: Setting onboarding completed for $featureName');
    await sharedPreferences.setBool('hasSeenOnboarding_$featureName', true);
  }
}
