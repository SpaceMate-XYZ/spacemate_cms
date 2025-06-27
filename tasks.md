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
