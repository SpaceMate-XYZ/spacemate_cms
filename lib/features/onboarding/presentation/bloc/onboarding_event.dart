part of 'onboarding_bloc.dart';

@freezed
class OnboardingEvent with _$OnboardingEvent {
  const factory OnboardingEvent.fetchOnboardingData() = _FetchOnboardingData;
  const factory OnboardingEvent.onboardingCompleted() = _OnboardingCompleted;
}
