import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spacemate/core/di/injection_container.dart';
import 'package:spacemate/core/utils/app_router.dart';
import 'package:spacemate/core/utils/feature_name_mapper.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'package:spacemate/features/menu/presentation/widgets/menu_grid_item.dart';
import 'package:spacemate/features/onboarding/presentation/bloc/feature_onboarding_cubit.dart';
import 'dart:developer' as developer;

class FeatureCardWithOnboarding extends StatelessWidget {
  final MenuItemEntity item;

  const FeatureCardWithOnboarding({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FeatureOnboardingCubit>(
      create: (context) => sl<FeatureOnboardingCubit>(),
      child: BlocListener<FeatureOnboardingCubit, FeatureOnboardingState>(
        listener: (context, state) {
          developer.log('FeatureCardWithOnboarding: State changed to ${state.runtimeType}');
          
          state.whenOrNull(
            onboardingNeeded: (slides) {
              developer.log('FeatureCardWithOnboarding: Onboarding needed for ${item.label} with ${slides.length} slides');
              // Use the new routing system for better deep linking
              final featureName = FeatureNameMapper.getFeatureNameFromLabel(item.label);
              if (featureName != null) {
                developer.log('FeatureCardWithOnboarding: Navigating to onboarding for feature: $featureName');
                AppRouter.navigateToOnboarding(context, featureName);
              } else {
                developer.log('FeatureCardWithOnboarding: No feature mapping found, using legacy navigation');
                // Fallback to legacy navigation
                context.go('/onboarding', extra: slides);
              }
            },
            onboardingNotNeeded: (navigationTarget) {
              developer.log('FeatureCardWithOnboarding: Onboarding not needed for ${item.label}');
              if (navigationTarget != null && navigationTarget.isNotEmpty) {
                developer.log('FeatureCardWithOnboarding: Navigating to target: $navigationTarget');
                context.go(navigationTarget);
              } else {
                // Navigate to feature page instead of home
                final featureName = FeatureNameMapper.getFeatureNameFromLabel(item.label);
                if (featureName != null) {
                  developer.log('FeatureCardWithOnboarding: Navigating to feature page: $featureName');
                  AppRouter.navigateToFeature(context, featureName);
                } else {
                  developer.log('FeatureCardWithOnboarding: No feature mapping, going home');
                  context.go('/');
                }
              }
            },
            error: (message) {
              developer.log('FeatureCardWithOnboarding: Error - $message');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $message')),
              );
            },
          );
        },
        child: BlocBuilder<FeatureOnboardingCubit, FeatureOnboardingState>(
          builder: (context, state) {
            return MenuGridItem(
              item: item,
              onTap: () {
                developer.log('FeatureCardWithOnboarding: Card tapped for ${item.label}');
                // Pass the exact menu label for proper mapping
                context.read<FeatureOnboardingCubit>().checkOnboardingStatus(item.label, item.navigationTarget);
              },
            );
          },
        ),
      ),
    );
  }
}
