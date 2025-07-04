import 'package:flutter/material.dart';
import 'package:spacemate/features/onboarding/data/models/onboarding_slide.dart';
import 'package:spacemate/core/utils/image_utils.dart';
import 'package:spacemate/core/config/cors_config.dart';
import 'package:spacemate/features/onboarding/presentation/widgets/responsive_image_widget.dart';
import 'dart:developer' as developer;

class ResponsiveOnboardingSlide extends StatelessWidget {
  final OnboardingSlide slide;
  final VoidCallback? onButtonPressed;
  final bool isLastSlide;

  const ResponsiveOnboardingSlide({
    super.key,
    required this.slide,
    this.onButtonPressed,
    this.isLastSlide = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final imageHeight = screenSize.height * 0.4; // 40% of screen height
    
    return SingleChildScrollView(
      child: Column(
        children: [
          // Image Container (40% of screen height)
          _buildImageContainer(context, imageHeight),
          
          // Content Container
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 32),
                
                // Header Text
                _buildHeaderText(context),
                
                const SizedBox(height: 16),
                
                // Body Text
                if (slide.body != null && slide.body!.isNotEmpty)
                  _buildBodyText(context),
                
                const SizedBox(height: 24),
                
                // Button (only on last slide)
                if (isLastSlide && slide.buttonLabel != null && slide.buttonLabel!.isNotEmpty)
                  _buildButton(context),
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageContainer(BuildContext context, double imageHeight) {
    return SizedBox(
      height: imageHeight,
      width: double.infinity,
      child: ClipRect(
        child: OverflowBox(
          maxWidth: double.infinity,
          alignment: Alignment.center,
          child: _buildResponsiveImage(context, imageHeight),
        ),
      ),
    );
  }

  Widget _buildResponsiveImage(BuildContext context, double containerHeight) {
    return ResponsiveImageWidget(
      imageUrl: slide.imageUrl,
      containerHeight: containerHeight,
      errorWidget: (context, url, error) {
        developer.log('ResponsiveOnboardingSlide: Image failed to load: $url, error: $error');
        
        // Show detailed error information in development
        if (CorsConfig.isDevelopment) {
          return Container(
            height: containerHeight,
            color: Colors.red[50],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getFeatureIcon(slide.feature),
                    size: 80,
                    color: Colors.red[600],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Image Loading Failed',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'URL: $url',
                    style: TextStyle(fontSize: 12, color: Colors.red[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Error: $error',
                    style: TextStyle(fontSize: 10, color: Colors.red[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        
        return _buildFallbackImage(containerHeight);
      },
    );
  }

  Widget _buildFallbackImage(double containerHeight) {
    return SizedBox(
      height: containerHeight,
      child: ImageUtils.createFeaturePlaceholder(
        icon: _getFeatureIcon(slide.feature),
        title: slide.header,
        subtitle: slide.body,
      ),
    );
  }

  Widget _buildHeaderText(BuildContext context) {
    return Text(
      slide.header,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildBodyText(BuildContext context) {
    return Text(
      slide.body!,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w300,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onButtonPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          slide.buttonLabel!,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Get icon for a specific feature
  IconData _getFeatureIcon(String featureName) {
    switch (featureName.toLowerCase()) {
      case 'parking':
        return Icons.directions_car;
      case 'valetparking':
      case 'valet_parking':
        return Icons.local_parking;
      case 'evcharging':
      case 'ev_charging':
        return Icons.ev_station;
      case 'building':
        return Icons.location_city;
      case 'office':
        return Icons.apartment;
      case 'lockers':
        return Icons.grid_on;
      case 'meetings':
        return Icons.meeting_room;
      case 'visitors':
        return Icons.person_add;
      case 'requests':
        return Icons.psychology_alt;
      case 'desks':
        return Icons.desk;
      case 'shuttles':
        return Icons.airport_shuttle;
      case 'fooddelivery':
        return Icons.moped;
      case 'cafeteria':
        return Icons.fastfood;
      case 'vending':
        return Icons.coffee_maker;
      case 'fitness':
        return Icons.fitness_center;
      case 'sports':
        return Icons.directions_run;
      case 'games':
        return Icons.sports_esports;
      case 'doctor':
        return Icons.medical_services;
      case 'counselor':
        return Icons.psychology;
      case 'spa':
        return Icons.spa;
      case 'lobby':
        return Icons.door_front_door;
      case 'lift':
        return Icons.elevator;
      case 'printer':
        return Icons.print;
      case 'carpools':
        return Icons.diversity_1;
      case 'companycabs':
        return Icons.local_taxi;
      default:
        return Icons.featured_play_list;
    }
  }
} 