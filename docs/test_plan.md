# Test Plan

## Overview
This document outlines the testing strategy for the Spacemate CMS Flutter application, focusing on ensuring the quality, functionality, and performance of the application.

## Testing Levels

### 1. Unit Tests
**Purpose:** To validate individual functions, classes, and business logic in isolation.
**Tools:** `flutter_test`, `mockito`, `bloc_test`
**Coverage Focus:**
*   **Data Layer:**
    *   `OnboardingRemoteDataSourceImpl`: Verify successful data fetching and correct error handling (e.g., `ServerException`, `NetworkFailure`).
    *   `MenuRemoteDataSourceImpl`: Verify successful data fetching and correct error handling.
    *   Model `fromJson` and `toJson` methods (`Feature`, `OnboardingCarousel`, `OnboardingSlide`, `SpacematePlaceidFeaturesResponse`, `MenuItemModel`, `ScreenModel`).
*   **Domain Layer:**
    *   Entities (`MenuItemEntity`, `MenuCategory`): Verify value equality and correct property access.
    *   Use Cases (`GetFeaturesWithOnboarding`, `GetMenuItems`): Verify correct interaction with repositories and return types (e.g., `TaskEither`).
*   **Application Layer (BLoC/Cubit):**
    *   `MenuBloc`: Verify state transitions for loading, success, and failure, and correct handling of `LoadMenuEvent` and `RefreshMenuEvent`.
    *   **`FeatureOnboardingCubit` (NEW):**
        *   Verify `checkOnboardingStatus` logic:
            *   Correctly identifies if onboarding is needed based on `shared_preferences`.
            *   Fetches and filters `onboardingSlides` correctly from `GetFeaturesWithOnboarding`.
            *   Emits `onboardingNeeded` or `onboardingNotNeeded` states with correct data/navigation target.
            *   Handles API failures by emitting `error` state.
*   **Core Utilities:**
    *   `ThemeService`: Verify theme initialization, toggling, and persistence.

### 2. Widget Tests
**Purpose:** To verify the UI components and their interactions in isolation or in small groups.
**Tools:** `flutter_test`
**Coverage Focus:**
*   `HomePage` (Menu Page):
    *   Display of loading indicators, menu items, and error messages.
    *   Correct rendering of `CarouselWidget` and `MenuGrid`.
    *   Interaction with `MenuBottomNavBar` and page view transitions.
*   `MenuGridItem`:
    *   Correct display of label, icon, and badge count.
    *   `onTap` callback functionality.
*   `MenuBottomNavBar`:
    *   Correct display of all menu categories and their icons.
    *   `onItemSelected` callback functionality and highlighting of selected items.
*   **`OnboardingScreen` (NEW/IMPROVED):**
    *   Verify correct rendering of slides with dynamic content (title, header, body, imageURL).
    *   Test "Don't show again" checkbox interaction and state management.
    *   Verify final button display and `onPressed` functionality.
    *   Ensure proper navigation upon completion or skipping.
*   `FeatureCardWithOnboarding`:
    *   Verify that tapping the card correctly triggers `FeatureOnboardingCubit`'s `checkOnboardingStatus`.
    *   Verify that it correctly listens to `FeatureOnboardingState` and navigates accordingly (to `/onboarding` or `navigationTarget`).

### 3. Integration Tests
**Purpose:** To verify end-to-end user flows and interactions between different parts of the application, including API calls and navigation.
**Tools:** `integration_test`
**Coverage Focus:**
*   **Menu Loading and Navigation:**
    *   App starts, menu loads and displays correctly.
    *   Tapping a menu item navigates to the expected screen.
    *   Menu updates correctly when permissions or data change (if applicable).
    *   Theme changes are reflected across the app.
*   **Onboarding Flow (NEW):**
    *   **Scenario 1: First-time user:**
        *   Tapping a feature card triggers the onboarding screen.
        *   User completes the onboarding carousel.
        *   "Don't show again" checkbox state is persisted.
        *   User is navigated to the feature's main page.
    *   **Scenario 2: Returning user (onboarding seen):**
        *   Tapping a feature card directly navigates to the feature's main page (bypassing onboarding).
    *   **Scenario 3: Feature with no onboarding:**
        *   Tapping a feature card with no associated onboarding directly navigates to the feature's main page.
    *   **Error Scenario:**
        *   Simulate API failure during onboarding data fetch and verify appropriate error display/fallback.

## How to Run Tests
*   **Unit and Widget Tests:**
    ```bash
    flutter test
    ```
*   **Integration Tests:**
    ```bash
    flutter test integration_test
    ```

## Reporting
*   All failing tests are logged in `docs/failing_tests.md`.
*   Bugs and issues are tracked in `docs/bugs.md`.

## Test Data Management
*   Use `test/fixtures/` for mock JSON responses for API calls.
*   Use `shared_preferences` mock for testing persistence logic.

## Code Coverage
*   Aim for at least 80% code coverage for critical business logic and UI components.
*   Use `flutter test --coverage` to generate coverage reports.