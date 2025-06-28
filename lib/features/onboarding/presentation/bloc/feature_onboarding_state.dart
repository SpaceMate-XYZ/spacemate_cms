part of 'feature_onboarding_cubit.dart';

@freezed
class FeatureOnboardingState with _$FeatureOnboardingState {
  const factory FeatureOnboardingState.initial() = _Initial;
  const factory FeatureOnboardingState.loading() = _Loading;
  const factory FeatureOnboardingState.onboardingNeeded({
    required List<OnboardingSlide> slides,
  }) = _OnboardingNeeded;
  const factory FeatureOnboardingState.onboardingNotNeeded({String? navigationTarget}) = _OnboardingNotNeeded;
  const factory FeatureOnboardingState.error({
    required String message,
  }) = _Error;
}
