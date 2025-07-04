# SpaceMate CMS Flutter App

A Flutter superapp that manages onboarding carousels with a local-first approach using SQLite. The app features multiple screens with features represented as card buttons, each leading to an onboarding carousel of 4 slides.

## Features

- **5 Main Screens**: Home, Transport, Access, Facilities, Discover
- **Feature Cards**: Each screen has 3-12 features arranged in a grid
- **Onboarding Carousels**: 4-slide carousels for each feature
- **Local-First Architecture**: SQLite for offline-first functionality
- **Multi-Platform**: Supports Android, iOS, Web, Windows, and macOS
- **State Management**: BLoC pattern for predictable state management
- **Dependency Injection**: GetIt for service location and dependency injection

## Project Structure

```
lib/
├── core/                 # Core functionality
│   ├── config/          # App configuration
│   ├── di/              # Dependency injection
│   ├── error/           # Error handling
│   ├── network/         # Network layer
│   ├── theme/           # App theming
│   └── utils/           # Utility functions
├── features/            # Feature modules
│   ├── carousel/        # Carousel functionality
│   ├── menu/            # Menu and navigation
│   └── onboarding/      # Onboarding carousels
└── main.dart           # App entry point
```

## Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/SpaceMate-XYZ/spacemate_cms.git
   cd spacemate_cms
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For development
   flutter run -d windows
   
   # For web
   flutter run -d chrome
   ```

## Database Setup

The app uses SQLite for local data storage. The database is automatically created and migrated when the app first runs.

### Database Schema
- **onboarding_carousel**: Stores onboarding slides for each feature
  - id: String (primary key)
  - feature_name: String
  - screen: String
  - title: String
  - image_url: String
  - header: String
  - body: String
  - button_label: String
  - cached_at: Integer (timestamp)

## Running Tests

```bash
# Run all tests
flutter test

# Run integration tests
flutter test integration_test/

# Run with coverage
flutter test --coverage
```

## Documentation

### Core Documentation
- **[Architecture](architecture.md)**: Overview of the system architecture, data flow, and design patterns
- **[How to Use](HOW_TO_USE.md)**: Comprehensive guide for developers including setup, development workflow, and testing
- **[Project Tasks](docs/project_tasks.md)**: Current and upcoming project tasks and milestones
- **[Top Priority Tasks](docs/top_priority_tasks.md)**: High-priority tasks that need immediate attention

### Development Guides
- **[Functional Programming Guidelines](docs/functional_programming_guidelines.md)**: Best practices for functional programming in the project
- **[Content Schemas](docs/content_schemas.md)**: Documentation of content schemas and data models
- **[Offline-First Content](docs/offline_first_content.md)**: Guide to implementing offline-first functionality

### Testing & Quality
- **[Test Plan](docs/test_plan.md)**: Testing strategy and test coverage goals
- **[Failing Tests](docs/failing_tests.md)**: List of currently failing tests that need attention
- **[Bugs](bugs.md)**: Known issues and bug tracking

### API & Integration
- **[Strapi Configuration](strapi_config.md)**: Configuration details for the Strapi CMS integration
- **[API Documentation](docs/GEMINI.md)**: API specifications and integration details

### Project Management
- **[Backlog](docs/backlog.md)**: Product backlog and feature requests
- **[Coder Tasks](docs/coder_tasks.md)**: Technical tasks for developers
- **[Image Issue Tracking](docs/image_issue.md)**: Known issues with image assets

---

4. **Generate code**
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## API Endpoints

The app uses two main Strapi endpoints:

1. **Menu Data**: `/api/screens?populate=*`
   - Fetches all menu categories and features
   - Used for the main menu grid

2. **Onboarding Data**: `/api/spacemate-placeid-features?filters[feature_name][$eq]=FeatureName&populate=*`
   - Fetches onboarding carousel data for specific features
   - Example: `filters[feature_name][$eq]=parking` for parking feature
   - Returns 4 slides per feature with images, text, and button labels

## Example API Calls

**Parking Onboarding:**
```
https://strapi.dev.spacemate.xyz/api/spacemate-placeid-features?filters[feature_name][$eq]=parking&populate=*
```

**Valet Parking Onboarding:**
```
https://strapi.dev.spacemate.xyz/api/spacemate-placeid-features?filters[feature_name][$eq]=valetparking&populate=*
```

## Architecture

- **State Management**: BLoC pattern with dartz for functional programming
- **Dependency Injection**: GetIt for service locator pattern
- **Network Layer**: Dio with interceptors for authentication and logging
- **Local Storage**: SQLite for caching menu data
- **Testing**: Comprehensive test suite with unit, widget, and integration tests

## Key Components

### Menu System
- **MenuBloc**: Manages menu state and data fetching
- **MenuGrid**: Displays feature cards in a responsive grid
- **FeatureCard**: Individual feature card with navigation to onboarding

### Onboarding System
- **OnboardingBloc**: Manages onboarding carousel state
- **OnboardingPage**: Displays 4-slide carousel with navigation
- **OnboardingSlide**: Individual slide with image, text, and button

### Data Models
- **Feature**: Represents a feature with onboarding data
- **OnboardingSlide**: Individual slide data
- **MenuItemModel**: Menu item with navigation properties

## Configuration

### Strapi URLs
- **Main Strapi URL**: `https://strapi.dev.spacemate.xyz`
- **Carousel Strapi URL**: `https://strapi.dev.spacemate.xyz`

### Collections
- **screens**: Menu data and feature categories
- **spacemate-placeid-features**: Onboarding carousel data

## Troubleshooting

### Common Issues
- **CORS Errors**: The app uses a proxy for development. Check `cors_config.dart` for configuration.
- **Image Loading**: Images are hosted on CDN. Check network connectivity and image URLs.
- **API Errors**: Verify Strapi endpoints and authentication tokens.
- **Build Errors**: Run `flutter clean` and `flutter pub get` before rebuilding.

### Debug Tips
- Check the console logs for API response details
- Verify environment variables are correctly set
- Ensure Strapi is running and accessible
- Check network connectivity for image loading

## Testing

Run the test suite:
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Coverage report
flutter test --coverage
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

All rights reserved.