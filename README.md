# Spacemate CMS

A Flutter application for managing and displaying menu content with Strapi backend integration.

## 🚨 CRITICAL SECURITY WARNING 🚨

**This project is temporarily configured to commit the `.env` file to version control.**

This is for development convenience ONLY. Before making this repository public or sharing it, you **MUST** add the `.env` file back to your `.gitignore` to prevent leaking sensitive information like API keys and configuration secrets.

To secure your project, add the following lines back to your `.gitignore` file:

```gitignore
# Local development secrets - DO NOT COMMIT
.env
.env.*
!.env.example
```

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Documentation](#documentation)
- [Development](#development)
- [Testing](#testing)
- [Deployment](#deployment)
- [Troubleshooting](#troubleshooting)

## Features

- Dynamic menu content management
- Strapi CMS integration
- Offline-first functionality
- Responsive design for multiple platforms
- Clean Architecture implementation
- BLoC state management

## Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (as per Flutter requirements)
- Strapi backend server
- Android Studio / Xcode (for mobile development)
- VS Code or Android Studio (recommended IDEs)

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Copy `.env.example` to `.env` and update with your configuration
4. Run `flutter run` to start the development server

## Project Structure

```
lib/
├── core/
│   ├── di/              # Dependency injection
│   ├── error/           # Error handling
│   ├── network/         # Network layer
│   └── utils/           # Utilities and helpers
├── features/            # Feature modules
│   └── menu/            # Menu feature
│       ├── data/        # Data layer
│       ├── domain/      # Business logic
│       └── presentation/ # UI layer
└── main.dart           # Application entry point
```

## Documentation

Detailed documentation is available in the `docs/` directory:

- [Architecture](docs/architecture.md) - System design and architecture decisions
- [How to Use](docs/how_to_use.md) - User guide and API documentation
- [Test Plan](docs/test_plan.md) - Testing strategy and coverage
- [Failing Tests](docs/failing_tests.md) - Currently failing tests and known issues
- [Bugs](docs/bugs.md) - Known bugs and workarounds

## Development

### Code Style

This project follows the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style) and uses `dart format` for code formatting.

### Git Workflow

1. Create a new branch for your feature/bugfix
2. Write tests for your changes
3. Ensure all tests pass
4. Open a pull request for review

## Testing

Run tests using:

```bash
flutter test
```

For test coverage:

```bash
flutter test --coverage
```

## Deployment

### Web

```bash
flutter build web
```

### Mobile

```bash
flutter build apk --release  # Android
flutter build ios --release  # iOS
```

## Troubleshooting

Common issues and solutions are documented in the relevant `docs/` files. For additional help, please open an issue.
