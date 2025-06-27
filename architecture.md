# High-Level Architecture for SpaceMate Superapp

## 1. Introduction
This document outlines the high-level architecture for the SpaceMate Superapp, a white-labeled, multi-tenant, multi-platform application designed for property management. The app will integrate seamlessly with a Strapi Content Management System (CMS) to dynamically deliver content and features based on specific `placeId` (representing a building or property).

## 2. Core Principles
*   **Modularity:** Components are designed to be independent and reusable.
*   **Scalability:** The architecture supports easy expansion for new features and increased user load.
*   **Maintainability:** Clean code, clear separation of concerns, and adherence to best practices.
*   **Multi-Platform Compatibility:** Designed for Android, iOS, Web, Windows, and macOS.
*   **Dynamic Content:** Content and features are driven by Strapi CMS, allowing for white-labeling and tenant-specific experiences.

## 3. System Context Diagram

```mermaid
graph TD
    A[Flutter Superapp Client] -->|API Calls (HTTP/HTTPS)| B(Strapi CMS Backend)
    B -->|Database Interaction| C[Database (e.g., PostgreSQL)]
    A -->|Local Storage| D[Device Local Storage (e.g., SQLite, SharedPreferences)]
    A -->|Authentication| E[Authentication Service (e.g., Firebase Auth, Strapi Users & Permissions)]
    E --> B
```

## 4. Architectural Layers (Client-Side - Flutter App)

The Flutter application will follow a clean architecture pattern, separating concerns into distinct layers:

### 4.1. Presentation Layer (UI & State Management)
*   **Purpose:** Handles user interface rendering and user interactions. Manages UI state.
*   **Components:**
    *   **Widgets/UI Components:** Visual elements of the application.
    *   **Pages/Screens:** Compositions of widgets forming distinct views.
    *   **BLoC (Business Logic Component):** Manages the state of the UI, reacting to events and emitting new states. Interacts with the Domain Layer.
*   **Key Technologies:** Flutter Widgets, BLoC, `flutter_bloc`.

### 4.2. Domain Layer (Business Logic & Entities)
*   **Purpose:** Contains the core business logic and rules of the application. Independent of any framework.
*   **Components:**
    *   **Entities:** Plain Dart objects representing the core data structures (e.g., `User`, `Property`, `Announcement`, `MaintenanceRequest`).
    *   **Use Cases (Interactors):** Encapsulate specific business operations. Orchestrate interactions between repositories. (e.g., `LoginUser`, `GetAnnouncementsByPlaceId`, `SubmitMaintenanceRequest`).
    *   **Repositories (Abstract):** Define contracts for data operations. Implemented in the Data Layer.
*   **Key Technologies:** Pure Dart.

### 4.3. Data Layer (Data Sources & Repositories)
*   **Purpose:** Responsible for retrieving and storing data. Implements the repository contracts defined in the Domain Layer.
*   **Components:**
    *   **Repositories (Concrete Implementation):** Implement the abstract repository interfaces. Coordinate data from various sources.
    *   **Data Sources (Remote):** Interact with external APIs (e.g., Strapi REST API).
    *   **Data Sources (Local):** Interact with local storage (e.g., SQLite, SharedPreferences).
    *   **Models:** Data structures for serialization/deserialization from/to JSON (e.g., `UserModel`, `PropertyModel`). These are often extensions of Domain Entities.
*   **Key Technologies:** `dio` for HTTP requests, `json_serializable`, `sqflite`, `shared_preferences`.

## 5. Strapi CMS Backend

*   **Purpose:** Provides a flexible and extensible content management system.
*   **Key Features:**
    *   **Custom Content Types:** Define schemas for `Buildings`, `Units`, `Users`, `Announcements`, `MaintenanceRequests`, `Features`, etc.
    *   **Role-Based Access Control (RBAC):** Manage permissions for different user roles (Occupant, Property Manager, Builder).
    *   **API Endpoints:** Automatically generated RESTful or GraphQL APIs for content interaction.
    *   **Media Library:** Store and manage images, documents, and other assets.
    *   **Webhooks:** Potentially used for real-time updates or integrations.
*   **Data Structure for Multi-tenancy:** Each content type will likely have a `placeId` field to filter content specific to a building/property.

## 6. Cross-Cutting Concerns

*   **Dependency Injection (GetIt):** Manages dependencies throughout the application, ensuring loose coupling and testability.
*   **Error Handling:** Consistent error handling across all layers, mapping exceptions to `Failure` objects.
*   **Theming & Styling:** Centralized theme management (light/dark mode, dynamic colors) using `dynamic_color`.
*   **Navigation:** Robust routing solution (e.g., `go_router`) for deep linking and complex navigation flows.
*   **Internationalization (i18n):** Support for multiple languages.
*   **Environment Configuration:** Using `flutter_dotenv` for managing API keys, base URLs, etc.

## 7. Proposed Directory Structure

```
lib/
├───main.dart
├───core/
│   ├───config/             # Environment variables, app constants
│   ├───database/           # Local database helpers (SQLite)
│   ├───di/                 # Dependency Injection setup (GetIt)
│   ├───error/              # Custom exceptions and failures
│   ├───extensions/         # Dart/Flutter extensions
│   ├───network/            # Dio client, interceptors, network info
│   ├───theme/              # App themes, colors, text styles, theme service
│   ├───usecases/           # Base use case classes
│   └───utils/              # Utility functions (router, image, icon, screen utils)
├───features/
│   ├───<feature_name>/
│   │   ├───data/
│   │   │   ├───adapters/       # Data mapping (e.g., JSON to Entity)
│   │   │   ├───datasources/    # Remote/Local data sources
│   │   │   ├───models/         # Data models for serialization
│   │   │   └───repositories/   # Concrete repository implementations
│   │   ├───domain/
│   │   │   ├───entities/       # Core business entities
│   │   │   ├───repositories/   # Abstract repository interfaces
│   │   │   └───usecases/       # Business logic use cases
│   │   └───presentation/
│   │       ├───bloc/           # BLoC event, state, and bloc files
│   │       ├───pages/          # Full-screen pages
│   │       ├───screens/        # Reusable screen components
│   │       └───widgets/        # Reusable UI widgets
│   └───onboarding/
│       └───data/
│           └───models/
└───shared/
    ├───widgets/              # Widgets shared across multiple features
    └───constants/            # Global constants

```

## 8. Future Considerations
*   **Offline Support:** Robust caching mechanisms for offline access.
*   **Real-time Updates:** WebSockets or push notifications for instant content updates.
*   **Search:** Integration with Meilisearch for efficient content search.
*   **Augmented Reality (AR):** Potential AR features for property viewing.