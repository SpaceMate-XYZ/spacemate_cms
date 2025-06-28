**Project Tasks: Onboarding Carousel for Flutter Superapp**
===========================================================

This document outlines the detailed tasks required to implement an onboarding carousel in a Flutter superapp. The carousel will dynamically load its content from a Strapi CMS, utilize the flutter\_onboarding\_slider package, and include a "Don't show again" option for first-time users.

**Current Project Context:**

*   The application already has a menu system with card buttons implemented, which fetch text and icons from Strapi CMS.
    
*   All necessary dependencies (flutter\_onboarding\_slider, shared\_preferences, cached\_network\_image) are already included in the pubspec.yaml, along with dio for networking, go\_router for navigation, flutter\_bloc for state management, get\_it for dependency injection, and fpdart for functional programming.
    
*   The Git remote URL for the project is https://github.com/SpaceMate-XYZ/spacemate\_cms.
    
*   A significant amount of existing code is present, and new implementations should consider and integrate with the current architecture.
    

**1\. Project Setup & Initial Code Review**
-------------------------------------------

*   **1.1. Project Initialization & Git Setup:**
    
*   Confirm navigation to the existing Flutter project root.
    
*   Verify the existing Git repository configuration.
    
*   Ensure .gitignore is properly configured.
    
*   **1.2. Dependencies Verification:**
    
*   Confirm that flutter\_onboarding\_slider, shared\_preferences, dio, go\_router, flutter\_bloc, get\_it, fpdart, and cached\_network\_image are correctly listed in pubspec.yaml and flutter pub get has been run.
    
*   **1.3. Strapi API Endpoint Verification:**
    
*   Verify the Strapi API endpoint: https://strapi.apps.rredu.in/api/spacemate-placeid-features?populate=\*
    
*   Thoroughly understand the structure of the JSON payload, specifically the data array and its attributes (e.g., name, onboarding\_carousel).
    
*   Identify the fields within onboarding\_carousel that will be used for the slides, based on the provided structure: id, feature, screen, title, imageURL, header, body, button\_label.
    
*   **1.4. Existing Codebase Review:**
    
*   **Identify existing menu/feature card implementation:** Locate the code responsible for rendering the feature card buttons and their onTap handlers. This is where the onboarding carousel invocation logic will be integrated.
    
*   **Review existing network layer:** Understand how current API calls are made using dio. This will inform the StrapiService implementation.
    
*   **Review existing navigation:** Understand the current navigation patterns using go\_router to seamlessly integrate the OnboardingScreen.
    
*   **Review existing state management:** Understand how BLoC is currently used for state management and how new BLoCs/Cubit can be integrated.
    
*   **Review existing dependency injection:** Understand how get\_it is used for service location and dependency injection.
    

**2\. Data Model Definition (Dart)**
------------------------------------

*   **2.1. Create/Update Dart Models:**
    
*   Define/update a Dart model for the main Strapi response (SpacematePlaceidFeaturesResponse).
    
*   Define a Feature model to parse data items, including their id and attributes.
    
*   Define an OnboardingCarousel model nested within FeatureAttributes to represent the carousel data.
    
*   **Crucially, define an OnboardingSlide model to accurately reflect the new provided structure for each slide:**
    
*   id: The unique identifier for the slide.
    
*   feature: The name of the feature this slide belongs to.
    
*   screen: The screen number for this specific slide within the feature's carousel.
    
*   title: Text to be displayed in the App bar of the slide.
    
*   imageURL: The CDN URL of the image.
    
*   header: Text to be placed just below the image.
    
*   body: Text to be placed just below the header.
    
*   button\_label: Label for the button on the _last_ screen of the carousel.
    
*   Implement fromJson factory constructors for all models to easily parse JSON responses, paying close attention to nested paths for fields like imageURL.
    

// Example (simplified and updated):class SpacematePlaceidFeaturesResponse {  final List data;  // ... other metadata  SpacematePlaceidFeaturesResponse.fromJson(Map json)      : data = (json\['data'\] as List)          .map((e) => Feature.fromJson(e as Map))          .toList();}class Feature {  final int id;  final FeatureAttributes attributes;  Feature.fromJson(Map json)      : id = json\['id'\] as int,        attributes = FeatureAttributes.fromJson(json\['attributes'\] as Map);}class FeatureAttributes {  final String name;  final OnboardingCarousel? onboardingCarousel; // Nullable if not always present  FeatureAttributes.fromJson(Map json)      : name = json\['name'\] as String,        onboardingCarousel = json\['onboarding\_carousel'\] != null            ? OnboardingCarousel.fromJson(json\['onboarding\_carousel'\] as Map)            : null;}class OnboardingCarousel {  final List slides;  OnboardingCarousel.fromJson(Map json)      : slides = (json\['slides'\] as List)          .map((e) => OnboardingSlide.fromJson(e as Map))          .toList();}// Updated OnboardingSlide structureclass OnboardingSlide {  final int id;  final String feature;  final int screen;  final String title; // For App bar  final String imageUrl; // CDN URL  final String header; // Below image  final String body; // Below header  final String? buttonLabel; // Optional, only for last slide  OnboardingSlide.fromJson(Map json)      : id = json\['id'\] as int,        feature = json\['feature'\] as String,        screen = json\['screen'\] as int,        title = json\['title'\] as String,        imageUrl = json\['image'\]\['data'\]\['attributes'\]\['url'\] as String, // Verify this path with actual payload        header = json\['header'\] as String,        body = json\['body'\] as String,        buttonLabel = json\['button\_label'\] as String?; // Nullable}

**3\. Strapi Integration (API Service)**
----------------------------------------

*   **3.1. Create/Update an API Service Class:**
    
*   Leverage the existing dio instance or create a new one, configured with the base URL and any necessary interceptors (e.g., for logging, authentication).
    
*   Create/update a dedicated service class (e.g., StrapiService) for handling API calls specific to onboarding data. Register this service with get\_it.
    
*   Define a method fetchFeaturesWithOnboarding() that makes the HTTP GET request using dio to the Strapi endpoint.
    
*   **Implement error handling using fpdart:** Return Either (or Failure, Success types defined in fpdart) to explicitly handle success or failure states. This will provide a more robust and functional approach to error management.
    
*   Parse the JSON response into the defined Dart models.
    
*   Return a Future\>> or a more specific Either object.
    
*   **3.2. Error Handling & Loading States with BLoC and fpdart:**
    
*   Implement try-catch blocks within the StrapiService for dio errors, mapping them to custom Failure types (e.g., NetworkFailure, ParsingFailure).
    
*   When calling the StrapiService from a BLoC/Cubit, use fpdart's fold method to handle the Either result, emitting appropriate states (e.g., OnboardingLoading, OnboardingLoaded, OnboardingError).
    

**4\. Onboarding Carousel Implementation**
------------------------------------------

*   **4.1. Onboarding Screen Widget (OnboardingScreen):**
    
*   Create a new Flutter StatefulWidget (e.g., OnboardingScreen).
    
*   This widget will ideally be wrapped in a BlocProvider or consume the relevant BLoC to fetch and manage its List data.
    
*   Initialize flutter\_onboarding\_slider with the dynamic slide data obtained from the BLoC state.
    
*   For each slide, construct the UI using the updated OnboardingSlide fields:
    
*   title for the App bar.
    
*   imageURL for CachedNetworkImage (since cached\_network\_image is already present).
    
*   header and body for text content.
    
*   Implement loading indicators while the BLoC is in a loading state or while image assets are being fetched (e.g., CachedNetworkImage's placeholder and errorWidget).
    
*   **4.2. "Don't Show Again" Checkbox & Button Logic:**
    
*   **UI:** On the _last_ slide of the flutter\_onboarding\_slider, display the button with button\_label from the OnboardingSlide data. Alongside or within the button area, add a Checkbox and Text for "Don't show this again".
    
*   **State Management:** Maintain a bool state variable (e.g., \_dontShowAgain) for the checkbox within the OnboardingScreen's state.
    
*   **Persistence:**
    
*   When the user taps the final button (with button\_label) on the last slide:
    
*   Check the \_dontShowAgain state.
    
*   If checked, use shared\_preferences to save a boolean flag (e.g., SharedPreferences.setBool('hasSeenOnboarding\_', true) - consider per-feature flags based on the feature field from OnboardingSlide).
    
*   Trigger navigation using go\_router to pop the onboarding screen or navigate to the feature's main route.
    
*   **4.3. First-Time User Logic (BLoC and go\_router integration):**
    
*   **BLoC for Feature Taps:** Create a BLoC/Cubit (e.g., FeatureOnboardingCubit) that is responsible for determining if onboarding is needed for a specific feature.
    
*   **onTap Handler:** Modify the onTap handler of the existing feature card buttons to dispatch an event or call a method on the FeatureOnboardingCubit (retrieved via get\_it or BlocProvider.of). Pass the feature's name/ID.
    
*   **Cubit Logic:**
    
*   In the FeatureOnboardingCubit, retrieve the SharedPreferences instance (via get\_it).
    
*   Check shared\_preferences for the relevant flag (e.g., SharedPreferences.getBool('hasSeenOnboarding\_')).
    
*   If null or false:
    
*   Call the StrapiService (via get\_it) to fetchFeaturesWithOnboarding() for the specific feature.
    
*   Handle the Either result using fold.
    
*   If successful, emit a state containing the List.
    
*   If an error occurs, emit an error state.
    
*   If true:
    
*   Emit a state indicating that onboarding is not needed and the user should proceed to the feature.
    
*   **BlocListener for Navigation:** In the widget displaying the feature cards, use a BlocListener to listen to states from FeatureOnboardingCubit.
    
*   When the BLoC emits a state indicating onboarding data is ready, navigate to the OnboardingScreen using context.go('/onboarding', extra: slidesData) (or context.push).
    
*   When the BLoC emits a state indicating onboarding is not needed, navigate directly to the feature's main route using context.go('/feature\_main\_route/').
    

**5\. UI Integration**
----------------------

*   **5.1. Feature Card Button Integration:**
    
*   As described in 4.3, modify the onTap handler of the existing feature card buttons to dispatch events to the FeatureOnboardingCubit.
    
*   Ensure the correct feature name/ID is passed to the cubit.
    
*   **5.2. Loading States & Fallbacks for Carousel Content:**
    
*   Within the OnboardingScreen (and potentially the feature card parent widget), use BlocBuilder to react to loading states emitted by the FeatureOnboardingCubit or the OnboardingScreen's own BLoC. Display loading indicators as appropriate.
    
*   Provide a graceful fallback UI or an informative error message if data fetching fails, reacting to error states from the BLoC.
    
*   Handle cases where a feature might not have an onboarding\_carousel defined in Strapi by either skipping the onboarding or showing a generic message based on the BLoC state.
    

**6\. Testing**
---------------

*   **6.1. Unit Tests:**
    
*   Test Dart models' fromJson parsing logic with example Strapi payloads, including the new OnboardingSlide structure.
    
*   Test StrapiService methods using mock dio instances to verify successful data fetching and correct fpdart Either results for success and various failure scenarios.
    
*   Test FeatureOnboardingCubit/BLoC logic:
    
*   Verify correct state transitions for loading, loaded, and error states.
    
*   Test the shared\_preferences check within the cubit (mock SharedPreferences).
    
*   Test how the cubit interacts with StrapiService (fpdart Either handling).
    
*   **6.2. Widget Tests:**
    
*   Test OnboardingScreen widget:
    
*   Wrap the widget in BlocProviders and GoRouter context as needed.
    
*   Verify correct display of slides with dynamic content using the new fields (title, header, body, imageURL).
    
*   Test the "Don't show again" checkbox interaction.
    
*   Verify the final button with button\_label is displayed correctly on the last slide.
    
*   Test navigation after completing the carousel via the button using go\_router mock.
    
*   Test the feature card parent widget:
    
*   Test onTap logic, dispatching events to the FeatureOnboardingCubit and verifying navigation via go\_router.
    
*   Verify loading and error UI states.
    
*   **6.3. Integration Tests:**
    
*   Test the end-to-end flow using go\_router's testing utilities: Tapping a feature card -> FeatureOnboardingCubit determines if onboarding is needed -> fetching data via StrapiService -> displaying OnboardingScreen -> checking "Don't show again" via the final button -> shared\_preferences persistence -> subsequent taps bypassing onboarding and navigating directly to the feature.
    
*   Ensure shared\_preferences persistence works across app restarts (simulated).
    

**7\. Deployment Considerations**
---------------------------------

*   **7.1. Performance Optimization:**
    
*   Explicitly use cached\_network\_image for all image loading in the OnboardingScreen.
    
*   **Implement lazy background loading:** Utilize flutter\_onboarding\_slider's capabilities or a custom PageView.builder combined with CachedNetworkImage pre-caching to load images/content for adjacent slides (e.g., next and previous) immediately after the current slide is visible. This ensures a smooth swiping experience without delays.
    
*   Ensure smooth animations and transitions for the flutter\_onboarding\_slider.
    
*   Profile the app to identify and resolve any performance bottlenecks related to data fetching or UI rendering.
    
*   **7.2. Release Build:**
    
*   Perform thorough testing on release builds (Android & iOS) to ensure stability and performance.
    
*   Ensure all pubspec.yaml dependencies are correctly resolved.