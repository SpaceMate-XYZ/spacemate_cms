import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spacemate/core/usecases/usecase.dart';
import 'package:spacemate/features/onboarding/data/models/feature.dart';
import 'package:spacemate/features/onboarding/data/models/onboarding_slide.dart';
import 'package:spacemate/features/onboarding/domain/usecases/get_features_with_onboarding.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';
part 'onboarding_bloc.freezed.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final GetFeaturesWithOnboarding getFeaturesWithOnboarding;

  OnboardingBloc({
    required this.getFeaturesWithOnboarding,
  }) : super(const OnboardingState.initial()) {
    on<_FetchOnboardingData>(_onFetchOnboardingData);
    on<_OnboardingCompleted>(_onOnboardingCompleted);
  }

  Future<void> _onFetchOnboardingData(
    _FetchOnboardingData event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(const OnboardingState.loading());
    final result = await getFeaturesWithOnboarding(const NoParams());
    result.fold(
      (failure) => emit(OnboardingState.error(message: failure.message)),
      (features) {
        // Filter out features without onboarding carousels and sort them by name
        final sortedFeatures = features
            .where((feature) => feature.attributes.onboardingCarousel != null)
            .toList()
            // Sort features by name in ascending order
            ..sort((a, b) => a.attributes.name.compareTo(b.attributes.name));
            
        // Expand the sorted features to get all slides
        final onboardingSlides = sortedFeatures
            .expand((feature) => feature.attributes.onboardingCarousel!)
            .toList();
            
        emit(OnboardingState.loaded(slides: onboardingSlides));
      },
    );
  }

  Future<void> _onOnboardingCompleted(
    _OnboardingCompleted event,
    Emitter<OnboardingState> emit,
  ) async {
    // TODO: Implement logic to save that onboarding is completed (e.g., using shared_preferences)
    // For now, we just transition to initial state or navigate away.
    emit(const OnboardingState.initial());
  }
}
