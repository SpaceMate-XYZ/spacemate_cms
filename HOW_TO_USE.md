# SpaceMate CMS - Developer Guide

This guide provides comprehensive information for developers working with the SpaceMate CMS Flutter application.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Database Operations](#database-operations)
- [Testing](#testing)
- [Code Generation](#code-generation)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (comes with Flutter)
- Android Studio / Xcode (for mobile development)
- VS Code (recommended) with Flutter extensions
- Git for version control

## Getting Started

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
   # For development on Windows
   flutter run -d windows
   
   # For web development
   flutter run -d chrome
   
   # For mobile (connect device or start emulator first)
   flutter run
   ```

## Development Workflow

### Project Structure

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

### Adding a New Feature

1. Create a new directory under `lib/features/` for your feature
2. Follow the feature structure:
   ```
   feature_name/
   ├── data/
   │   ├── datasources/
   │   ├── models/
   │   └── repositories/
   ├── domain/
   │   ├── entities/
   │   ├── repositories/
   │   └── usecases/
   └── presentation/
       ├── bloc/
       ├── pages/
       └── widgets/
   ```
3. Register dependencies in the appropriate injection container
4. Add routes in `lib/core/routes/app_router.dart`

## Database Operations

### SQLite Database

The app uses SQLite for local data storage. The database is automatically created when the app first runs.

#### Accessing the Database

```dart
// Get database instance
final db = await database;

// Query example
final List<Map<String, dynamic>> maps = await db.query('onboarding_carousel');

// Insert example
await db.insert(
  'onboarding_carousel',
  onboardingCarouselModel.toMap(),
  conflictAlgorithm: ConflictAlgorithm.replace,
);
```

#### Database Migrations

1. Update the database version in `lib/core/database/database.dart`
2. Add migration logic in the `_onUpgrade` method

## Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/onboarding/presentation/bloc/onboarding_bloc_test.dart

# Run integration tests
flutter test integration_test/

# Run with coverage
flutter test --coverage
```

### Writing Tests

#### Unit Tests
```dart
group('OnboardingBloc', () {
  late OnboardingBloc bloc;
  late MockOnboardingRepository mockRepository;

  setUp(() {
    mockRepository = MockOnboardingRepository();
    bloc = OnboardingBloc(repository: mockRepository);
  });

  test('initial state is OnboardingInitial', () {
    expect(bloc.state, equals(OnboardingInitial()));
  });
  
  // Add more test cases
});
```

#### Widget Tests
```dart
testWidgets('OnboardingScreen displays loading', (tester) async {
  // Build our app and trigger a frame.
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider(
        create: (_) => OnboardingBloc(mockRepository),
        child: const OnboardingScreen(),
      ),
    ),
  );
  
  // Verify loading indicator is shown
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

## Code Generation

The project uses several code generation tools. After making changes to the following files, run the appropriate commands:

```bash
# Generate freezed models and unions
flutter pub run build_runner build --delete-conflicting-outputs

# Generate dependency injection code
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes (during development)
flutter pub run build_runner watch --delete-conflicting-outputs
```

## Troubleshooting

### Common Issues

#### Database Locked
- **Symptom**: "database is locked" errors
- **Solution**: Ensure all database operations are properly awaited and connections are closed

#### Build Failures
- **Symptom**: Build fails after pulling new changes
- **Solution**:
  ```bash
  flutter clean
  flutter pub get
  flutter pub run build_runner build --delete-conflicting-outputs
  ```

#### Test Failures
- **Symptom**: Tests fail with "Bad state: No method stub was called"
- **Solution**: Ensure all mock expectations are properly set up in test files

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Code Style

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused
- Write tests for new features

### Commit Messages

Use the following format for commit messages:

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

**Types**:
- feat: A new feature
- fix: A bug fix
- docs: Documentation only changes
- style: Changes that do not affect the meaning of the code
- refactor: A code change that neither fixes a bug nor adds a feature
- test: Adding missing tests or correcting existing tests
- chore: Changes to the build process or auxiliary tools

Example:
```
feat(onboarding): add skip button to carousel

Adds a skip button to the onboarding carousel to allow users to skip the onboarding flow.

Closes #123
```
