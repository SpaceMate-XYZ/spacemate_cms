import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spacemate/features/onboarding/data/models/onboarding_slide.dart';
import 'package:spacemate/features/onboarding/presentation/widgets/responsive_onboarding_slide.dart';
import 'dart:developer' as developer;

class ResponsiveOnboardingCarousel extends StatefulWidget {
  final List<OnboardingSlide> slides;
  final int initialSlideIndex;
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;
  final bool showSkipButton;
  final bool showProgressIndicator;
  final bool showDontShowAgain;
  final String? featureName;
  final String? category;

  const ResponsiveOnboardingCarousel({
    super.key,
    required this.slides,
    this.initialSlideIndex = 0,
    this.onComplete,
    this.onSkip,
    this.showSkipButton = true,
    this.showProgressIndicator = true,
    this.showDontShowAgain = true,
    this.featureName,
    this.category,
  });

  @override
  State<ResponsiveOnboardingCarousel> createState() => ResponsiveOnboardingCarouselState();
}

class ResponsiveOnboardingCarouselState extends State<ResponsiveOnboardingCarousel> {
  late PageController _pageController;
  late int _currentPage;
  bool _dontShowAgain = false;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialSlideIndex;
    _pageController = PageController(initialPage: _currentPage);
    developer.log('ResponsiveOnboardingCarousel: Initialized with ${widget.slides.length} slides, starting at slide $_currentPage');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App Bar with title and skip button
            _buildAppBar(context),
            
            // Progress indicator
            if (widget.showProgressIndicator) _buildProgressIndicator(),
            
            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: widget.slides.length,
                itemBuilder: (context, index) {
                  final slide = widget.slides[index];
                  final isLastSlide = index == widget.slides.length - 1;
                  
                  return ResponsiveOnboardingSlide(
                    slide: slide,
                    isLastSlide: isLastSlide,
                    onButtonPressed: isLastSlide ? _handleComplete : null,
                  );
                },
              ),
            ),
            
            // Bottom navigation
            _buildBottomNavigation(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Close button
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _handleClose,
          ),
          
          // Title
          Expanded(
            child: Text(
              widget.slides[_currentPage].title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Skip button
          if (widget.showSkipButton && _currentPage < widget.slides.length - 1)
            TextButton(
              onPressed: _handleSkip,
              child: const Text('Skip'),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: List.generate(
          widget.slides.length,
          (index) => Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: index < widget.slides.length - 1 ? 8 : 0),
              decoration: BoxDecoration(
                color: index <= _currentPage 
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Navigation buttons
          Row(
            children: [
              // Previous button
              if (_currentPage > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousPage,
                    child: const Text('Previous'),
                  ),
                ),
              
              if (_currentPage > 0) const SizedBox(width: 16),
              
              // Next/Complete button
              Expanded(
                child: ElevatedButton(
                  onPressed: _currentPage < widget.slides.length - 1 
                      ? _nextPage 
                      : _handleComplete,
                  child: Text(
                    _currentPage < widget.slides.length - 1 ? 'Next' : 'Get Started',
                  ),
                ),
              ),
            ],
          ),
          
          // Don't show again checkbox (only on last slide)
          if (widget.showDontShowAgain && _currentPage == widget.slides.length - 1) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _dontShowAgain,
                  onChanged: (value) {
                    setState(() {
                      _dontShowAgain = value ?? false;
                    });
                    developer.log('ResponsiveOnboardingCarousel: Dont show again changed to: $_dontShowAgain');
                  },
                ),
                const Expanded(
                  child: Text(
                    "Don't show again",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    developer.log('ResponsiveOnboardingCarousel: Page changed to $page');
    
    // Update URL to reflect current slide
    _updateUrlForCurrentSlide();
  }

  void _updateUrlForCurrentSlide() {
    try {
      if (widget.featureName != null) {
        // Convert 0-based index to 1-based slide number
        final slideNumber = _currentPage + 1;
        
        if (widget.category != null) {
          context.go('/category/${widget.category}/onboarding/${widget.featureName}/$slideNumber');
        } else {
          context.go('/onboarding/${widget.featureName}/$slideNumber');
        }
        developer.log('ResponsiveOnboardingCarousel: Updated URL for slide $slideNumber');
      }
    } catch (e) {
      developer.log('ResponsiveOnboardingCarousel: Failed to update URL: $e');
    }
  }

  void _nextPage() {
    if (_currentPage < widget.slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleComplete() {
    developer.log('ResponsiveOnboardingCarousel: Completing onboarding');
    if (widget.onComplete != null) {
      widget.onComplete!();
    }
  }

  void _handleSkip() {
    developer.log('ResponsiveOnboardingCarousel: Skipping onboarding');
    if (widget.onSkip != null) {
      widget.onSkip!();
    }
  }

  void _handleClose() {
    developer.log('ResponsiveOnboardingCarousel: Closing onboarding');
    try {
      // Try to go back to the previous page
      if (context.canPop()) {
        context.pop();
      } else {
        // If we can't pop, go to home
        context.go('/');
      }
    } catch (e) {
      developer.log('ResponsiveOnboardingCarousel: Error closing onboarding: $e');
      // Fallback navigation
      try {
        Navigator.of(context).pop();
      } catch (e2) {
        developer.log('ResponsiveOnboardingCarousel: Fallback navigation also failed: $e2');
      }
    }
  }

  bool get dontShowAgain => _dontShowAgain;
} 