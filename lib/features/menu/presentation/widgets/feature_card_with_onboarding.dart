import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spacemate/core/di/injection_container.dart';
import 'package:spacemate/core/utils/app_router.dart';
import 'package:spacemate/core/utils/feature_name_mapper.dart';
import 'package:spacemate/features/menu/domain/entities/menu_item_entity.dart';
import 'package:spacemate/features/menu/presentation/widgets/menu_grid_item.dart';
import 'package:spacemate/features/onboarding/presentation/bloc/feature_onboarding_cubit.dart';
import 'package:spacemate/features/onboarding/presentation/pages/onboarding_page.dart';
import 'dart:developer' as developer;

class FeatureCardWithOnboarding extends StatelessWidget {
  final MenuItemEntity item;
  final String? category;

  const FeatureCardWithOnboarding({
    super.key, 
    required this.item, 
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FeatureOnboardingCubit>(
      create: (context) => sl<FeatureOnboardingCubit>(),
      child: BlocListener<FeatureOnboardingCubit, FeatureOnboardingState>(
        listener: (context, state) {
          developer.log('FeatureCardWithOnboarding: State changed to ${state.runtimeType}');
          developer.log('FeatureCardWithOnboarding: Current item label: "${item.label}"');
          developer.log('FeatureCardWithOnboarding: Current item navigationTarget: "${item.navigationTarget}"');
          developer.log('FeatureCardWithOnboarding: Current category: "$category"');
          
          state.whenOrNull(
            loading: () {
              developer.log('FeatureCardWithOnboarding: Loading state - checking onboarding status');
            },
            onboardingNeeded: (slides) {
              developer.log('FeatureCardWithOnboarding: Onboarding needed for ${item.label} with ${slides.length} slides');
              // Use the new routing system for better deep linking
              final featureName = FeatureNameMapper.getFeatureNameFromLabel(item.label);
              developer.log('FeatureCardWithOnboarding: Mapped feature name: $featureName');
              
              if (featureName != null) {
                developer.log('FeatureCardWithOnboarding: Navigating to onboarding for feature: $featureName');
                try {
                  // Use category-aware navigation
                  AppRouter.navigateToOnboarding(context, featureName, category: category);
                  developer.log('FeatureCardWithOnboarding: Category-aware navigation completed');
                } catch (e) {
                  developer.log('FeatureCardWithOnboarding: Category-aware navigation failed: $e');
                  // Fallback to legacy navigation
                  try {
                    context.go('/onboarding', extra: slides);
                    developer.log('FeatureCardWithOnboarding: Legacy navigation completed');
                  } catch (e2) {
                    developer.log('FeatureCardWithOnboarding: Legacy navigation also failed: $e2');
                    // Last resort - try direct navigation
                    try {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OnboardingScreen(slides: slides),
                        ),
                      );
                      developer.log('FeatureCardWithOnboarding: Direct navigation completed');
                    } catch (e3) {
                      developer.log('FeatureCardWithOnboarding: All navigation methods failed: $e3');
                      // Show error to user
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Navigation failed: $e3'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              } else {
                developer.log('FeatureCardWithOnboarding: No feature mapping found, using legacy navigation');
                // Fallback to legacy navigation
                try {
                  context.go('/onboarding', extra: slides);
                  developer.log('FeatureCardWithOnboarding: Legacy navigation completed');
                } catch (e) {
                  developer.log('FeatureCardWithOnboarding: Legacy navigation error: $e');
                  // Show error to user
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Navigation failed: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            onboardingNotNeeded: (navigationTarget) {
              developer.log('FeatureCardWithOnboarding: Onboarding not needed for ${item.label}');
              if (navigationTarget != null && navigationTarget.isNotEmpty) {
                developer.log('FeatureCardWithOnboarding: Navigating to target: $navigationTarget');
                try {
                  context.go(navigationTarget);
                  developer.log('FeatureCardWithOnboarding: Target navigation completed');
                } catch (e) {
                  developer.log('FeatureCardWithOnboarding: Target navigation error: $e');
                  // Show error to user
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Navigation failed: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } else {
                // Navigate to feature page instead of home
                final featureName = FeatureNameMapper.getFeatureNameFromLabel(item.label);
                developer.log('FeatureCardWithOnboarding: Mapped feature name for feature page: $featureName');
                
                if (featureName != null) {
                  developer.log('FeatureCardWithOnboarding: Navigating to feature page: $featureName');
                  try {
                    AppRouter.navigateToFeature(context, featureName, category: category);
                    developer.log('FeatureCardWithOnboarding: Feature page navigation completed');
                  } catch (e) {
                    developer.log('FeatureCardWithOnboarding: Feature page navigation error: $e');
                    // Show error to user
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Navigation failed: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else {
                  developer.log('FeatureCardWithOnboarding: No feature mapping, going home');
                  try {
                    context.go('/');
                    developer.log('FeatureCardWithOnboarding: Home navigation completed');
                  } catch (e) {
                    developer.log('FeatureCardWithOnboarding: Home navigation error: $e');
                    // Show error to user
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Navigation failed: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            error: (message) {
              developer.log('FeatureCardWithOnboarding: Error - $message');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: $message'),
                  backgroundColor: Colors.red,
                ),
              );
            },
          );
        },
        child: BlocBuilder<FeatureOnboardingCubit, FeatureOnboardingState>(
          builder: (context, state) {
            return MenuGridItem(
              item: item,
              onTap: () {
                developer.log('FeatureCardWithOnboarding: Card tapped for "${item.label}"');
                developer.log('FeatureCardWithOnboarding: Item details - ID: ${item.id}, Label: "${item.label}", NavigationTarget: "${item.navigationTarget}"');
                developer.log('FeatureCardWithOnboarding: Category: "$category"');
                
                try {
                  // Pass the exact menu label for proper mapping
                  context.read<FeatureOnboardingCubit>().checkOnboardingStatus(item.label, item.navigationTarget);
                  developer.log('FeatureCardWithOnboarding: checkOnboardingStatus called successfully');
                } catch (e) {
                  developer.log('FeatureCardWithOnboarding: Error calling checkOnboardingStatus: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
