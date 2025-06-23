# How to Use Spacemate CMS

This guide explains how to set up, configure, and use the Spacemate CMS Flutter application.

## Prerequisites
- Flutter SDK (latest stable)
- Dart SDK
- Strapi backend running and accessible
- Node.js (for Strapi)
- Android Studio/Xcode for mobile builds

## Setup
1. **Clone the repository**
   ```bash
   git clone <repo-url>
   cd spacemate_cms
   ```
2. **Install dependencies**
   ```bash
   flutter pub get
   ```
3. **Configure Environment**
   - Copy `.env.example` to `.env` and fill in your API keys and endpoints.
   - Ensure your Strapi backend is running and accessible.

## Running the App
- **Web:**
  ```bash
  flutter run -d chrome
  ```
- **Android:**
  ```bash
  flutter run -d android
  ```
- **iOS:**
  ```bash
  flutter run -d ios
  ```

## Features
- Menu screen driven by Strapi CMS
- Offline caching of menu data
- Responsive UI for web and mobile
- Material UI & BLoC pattern

## API Integration
- The app fetches menu data from `/api/menu-screens` endpoint (Strapi).
- Ensure the Strapi collection is public or provide authentication.

## Environment Variables
- `API_BASE_URL`: Base URL for your Strapi backend
- `API_KEY`: (if required)

## Troubleshooting
- See `docs/bugs.md` and `docs/failing_tests.md` for known issues.
- For backend 404 errors, ensure Strapi collections are set up and public API access is enabled.

## Contribution
- Fork the repo, create a branch, submit a PR.
- Follow code style and commit guidelines in the README.
