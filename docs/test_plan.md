# Test Plan

## Overview
This document outlines the testing strategy for Spacemate CMS.

## Testing Levels
- **Unit Tests**: Validate individual functions, classes, and BLoC logic.
- **Widget Tests**: Verify UI components and user interactions.
- **Integration Tests**: Ensure end-to-end flows (API + UI).

## Tools
- `flutter_test`
- `mockito`
- `bloc_test`
- `integration_test`

## Test Coverage Goals
- All business logic (BLoC, use cases) > 90%
- Core UI widgets > 80%
- Data sources and repositories > 90%

## How to Run Tests
```bash
flutter test
```
For integration tests:
```bash
flutter test integration_test
```

## Test Cases
- Fetch menu from Strapi and display in UI
- Handle empty/failed API responses
- Offline caching and retrieval
- Error display for network failures
- Responsive layout on different devices

## Reporting
- All failing tests are logged in `docs/failing_tests.md`
- Bugs and issues are tracked in `docs/bugs.md`
