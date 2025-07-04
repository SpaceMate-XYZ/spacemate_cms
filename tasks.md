# Project Tasks Breakdown

This document outlines the detailed tasks and sub-tasks for the SpaceMate Superapp development, along with their assigned agent roles and success criteria.

## Phase 1: Core Setup & Design System

### Task 1: Basic Project Setup
*   **Agent Role:** Coder
*   **Description:** Set up the basic Flutter project structure, including `pubspec.yaml` dependencies, and initial `main.dart`.
*   **Success Criteria:** The Flutter project is initialized, `pubspec.yaml` contains essential dependencies (Flutter SDK, `cupertino_icons`, `dynamic_color`, `flutter_bloc`, `get_it`, `dio`, `flutter_dotenv`, `shared_preferences`, `sqflite`, `path`, `uuid`, `equatable`, `json_annotation`, `logger`, `intl`), and the application successfully builds and runs on at least one platform (Web, Android, or Windows/macOS).

### Task 2: Define Design System
*   **Agent Role:** Architect (for proposal), Coder (for implementation)
*   **Description:** Propose and implement a comprehensive design system (color palette, typography, spacing, and common component styles) that supports both dark and light themes and utilizes `dynamic_color` for adaptive theming.
*   **Success Criteria:**
    *   `lib/core/theme/app_colors.dart` defines the color palette.
    *   `lib/core/theme/app_text_styles.dart` defines typography.
    *   `lib/core/theme/app_theme.dart` contains `ThemeData` for light and dark themes, incorporating `dynamic_color`.
    *   `lib/core/theme/theme_service.dart` provides methods for managing and toggling themes.
    *   A basic theme toggle mechanism is implemented (e.g., in `main.dart` or a simple settings screen).
*   **Status:** Completed

## Phase 2: Core Infrastructure

### Task 3: Dependency Injection Setup
*   **Agent Role:** Coder
*   **Description:** Implement `GetIt` for managing and injecting dependencies throughout the application.
*   **Success Criteria:** `lib/core/di/injection_container.dart` is set up, and a basic dependency (e.g., `DioClient`) is registered and can be resolved.
*   **Status:** Completed

### Task 4: Network Layer Setup
*   **Agent Role:** Coder
*   **Description:** Configure `dio` for making HTTP requests to the Strapi CMS, including interceptors for authentication and logging.
*   **Success Criteria:**
    *   `lib/core/network/dio_client.dart` is implemented with a `Dio` instance.
    *   `lib/core/network/interceptors/auth_interceptor.dart` handles token injection for authenticated requests.
    *   `lib/core/network/interceptors/logging_interceptor.dart` logs network requests and responses.
    *   Basic network calls can be made through `DioClient`.
*   **Status:** Completed

### Task 5: Error Handling
*   **Agent Role:** Coder
*   **Description:** Implement a robust error handling mechanism using custom exceptions and failures to provide clear and consistent error feedback.
*   **Success Criteria:**
    *   `lib/core/error/exceptions.dart` defines custom exceptions (e.g., `ServerException`, `CacheException`).
    *   `lib/core/error/failures.dart` defines `Failure` classes (e.g., `ServerFailure`, `CacheFailure`) for domain-level error representation.
    *   The network layer (e.g., `dio_client.dart` or data sources) catches exceptions and maps them to appropriate `Failure` types.
*   **Status:** Completed

## Phase 3: Feature Implementation (Iterative)

### Task 6: Onboarding Feature
*   **Agent Role:** Coder
*   **Description:** Implement the "Parking" onboarding carousel, fetching content from Strapi and linking it from the main menu.
*   **Success Criteria:**
    *   `flutter_onboarding_slider` package is integrated.
    *   Dart models for Strapi `spacemate-placeid-features` (specifically for "Parking") are created.
    *   Data source and repository for fetching onboarding content from Strapi are implemented.
    *   Onboarding BLoC is implemented for state management.
    *   Onboarding carousel UI is implemented using `flutter_onboarding_slider` and the provided design images.
    *   The "Parking" button in the main menu (Home screen & Transport screen) correctly navigates to the onboarding carousel.
    *   Relevant unit and widget tests are written for the onboarding feature.

# Tasks

## Completed
- Integrate onboarding carousel with main menu feature cards
- Implement 'Don't show again' logic per feature
- Fetch onboarding data from Strapi dynamically
- Modular navigation and error handling

## Next Steps
- Add/Update integration tests for onboarding and 'Don't show again' logic
- Manual QA for onboarding flows and edge cases
- Polish UI/UX as per latest designs

### ✅ Project Setup
*   Flutter project structure with clean architecture
*   BLoC pattern for state management
*   Dependency injection with GetIt
*   Network layer with Dio and interceptors
*   Error handling with custom exceptions and failures
*   Theme system with dynamic colors
*   Local storage with SQLite for caching

### ✅ Menu System
*   Menu data models and entities
*   Menu remote data source for Strapi integration
*   Menu local data source for SQLite caching
*   Menu repository with caching logic
*   Menu BLoC for state management
*   Menu grid widget with responsive design
*   Menu bottom navigation bar
*   Menu pages for all 5 categories (Home, Transport, Access, Facilities, Discover)
*   Feature card widgets with navigation
*   Menu integration tests

### ✅ Onboarding System
*   Onboarding data models and entities
*   Onboarding remote data source for Strapi integration
*   Onboarding repository with error handling
*   Onboarding BLoC for state management
*   Onboarding page with 4-slide carousel
*   Onboarding slide widgets with image, text, and button
*   Navigation from menu cards to onboarding carousels
*   Onboarding integration tests

### ✅ Carousel System
*   Carousel data models and entities
*   Carousel repository for Strapi integration
*   Carousel BLoC for state management
*   Carousel widgets with loading states
*   Carousel integration with onboarding system

### ✅ API Integration
*   Strapi API integration for menu data (`/api/screens?populate=*`)
*   Strapi API integration for onboarding data (`/api/spacemate-placeid-features?filters[feature_name][$eq]=FeatureName&populate=*`)
*   API error handling and retry logic
*   API response parsing and model mapping
*   API authentication with tokens

### ✅ UI/UX
*   Responsive design for multiple screen sizes
*   Material Design 3 components
*   Dynamic theming with light/dark mode support
*   Loading states and error handling in UI
*   Navigation between screens
*   Image loading with fallback placeholders

### ✅ Testing
*   Unit tests for all data models
*   Unit tests for all repositories
*   Unit tests for all BLoCs
*   Widget tests for all UI components
*   Integration tests for menu and onboarding flows
*   Test coverage above 80%

### ✅ Configuration
*   Environment variable configuration
*   Strapi base URL configuration
*   API token configuration
*   CORS proxy configuration for development
*   Build configuration for multiple platforms

## Current Tasks

### 🔄 API Endpoint Verification
*   Verify the Strapi API endpoint: https://strapi.dev.spacemate.xyz/api/spacemate-placeid-features?populate=*
*   Test onboarding data retrieval for different features
*   Verify image loading from CDN URLs
*   Test error handling for invalid feature names

### 🔄 Performance Optimization
*   Implement image caching for onboarding slides
*   Optimize API response parsing
*   Implement lazy loading for menu items
*   Add performance monitoring and metrics

### 🔄 Platform Testing
*   Test app on Android devices
*   Test app on iOS devices
*   Test app on web browsers
*   Test app on Windows desktop
*   Test app on macOS desktop

## Upcoming Tasks

### 📋 Advanced Features
*   Implement offline mode with local data caching
*   Add push notifications for feature updates
*   Implement user preferences and settings
*   Add analytics and user tracking
*   Implement A/B testing for onboarding flows

### 📋 Security Enhancements
*   Implement API rate limiting
*   Add request/response encryption
*   Implement secure token storage
*   Add input validation and sanitization
*   Implement security headers

### 📋 Documentation
*   Complete API documentation
*   Create user guide
*   Document deployment procedures
*   Create troubleshooting guide
*   Document testing procedures

## Known Issues

### 🐛 Image Loading
*   Some images may fail to load due to CORS issues in development
*   Workaround: Using proxy for development environment

### 🐛 API Response Parsing
*   Some API responses may have inconsistent structure
*   Workaround: Added robust error handling and fallback logic

### 🐛 Navigation
*   Deep linking may not work correctly in some cases
*   Workaround: Using standard navigation patterns

## Success Criteria

*   ✅ App loads menu data from Strapi successfully
*   ✅ App displays feature cards in grid layout
*   ✅ App navigates to onboarding carousel on feature card tap
*   ✅ App displays 4-slide onboarding carousel with images and text
*   ✅ App handles errors gracefully with user-friendly messages
*   ✅ App works on all target platforms (Android, iOS, Web, Windows, macOS)
*   ✅ App has comprehensive test coverage (>80%)
*   ✅ App follows Material Design 3 guidelines
*   ✅ App supports both light and dark themes
