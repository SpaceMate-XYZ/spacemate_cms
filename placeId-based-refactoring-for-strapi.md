# How-To Guide: Re-implementing placeId for Multi-Tenancy

## 1. Introduction

This document provides a comprehensive guide for re-introducing `placeId`-based multi-tenancy into the Spacemate Flutter application. The codebase was temporarily refactored to remove `placeId` to simplify the initial integration with a non-multi-tenant Strapi backend.

This guide details the necessary code changes across all application layers, explains the rationale behind them, and highlights key lessons learned and pitfalls to avoid. Following this guide will ensure a smooth and systematic re-implementation of multi-tenancy.

**Architectural Context**: The multi-tenancy strategy is based on a **subfolder approach**, where the `placeId` is part of the URL path (e.g., `/api/{placeId}/menu-screens`). This is documented in `strapi_config.md`.

## 2. Prerequisites

Before starting this refactoring, ensure the following backend and infrastructure requirements are met:

1.  **API Gateway (e.g., Nginx, Apache APISIX)**: A reverse proxy must be configured to handle requests to `/api/{placeId}/...` and route them to the appropriate Strapi instance or service.
2.  **Strapi Backend**: The Strapi CMS must be configured to handle requests based on the `placeId` passed from the gateway.

## 3. Step-by-Step Refactoring Guide

The following sections outline the required changes layer by layer, from the UI down to the data sources.

### 3.1. Data Layer

This is the foundation. We must first update the data contracts and implementations to handle `placeId`.

#### 3.1.1. Remote Data Source (`menu_remote_data_source.dart`, `menu_remote_data_source_impl.dart`)

*   **What to change**:
    1.  Update the `MenuRemoteDataSource` interface to include `placeId` in the `getMenuItems` method signature.
    2.  Update the `MenuRemoteDataSourceImpl` to accept `placeId` and use it to construct the dynamic API endpoint.
*   **Why**: The remote data source is responsible for making the actual API call. It needs the `placeId` to construct the correct URL for the multi-tenant backend.

    **`menu_remote_data_source.dart`:**
    ```diff
    - Future<List<MenuItemModel>> getMenuItems({ required String category, ... });
    + Future<List<MenuItemModel>> getMenuItems({ required String placeId, required String category, ... });
    ```

    **`menu_remote_data_source_impl.dart`:**
    ```diff
    - final response = await _dioClient.get('/api/menu-screens', ...);
    + final response = await _dioClient.get('/api/$placeId/menu-screens', ...);
    ```

#### 3.1.2. Local Data Source (`menu_local_data_source.dart`, `menu_local_data_source_sqflite.dart`)

*   **What to change**:
    1.  Update the `MenuLocalDataSource` interface to include `placeId` in `getCachedMenuItems`, `cacheMenuItems`, and `isCacheValid`.
    2.  Update the `MenuLocalDataSourceSqflite` implementation to use `placeId` in its database queries and cache key generation. This is critical to prevent data from different places from mixing in the local cache.
*   **Why**: The local cache must be multi-tenant aware. Each piece of cached data must be associated with the `placeId` it belongs to, ensuring that users only see data for the correct place.

    **`menu_local_data_source.dart`:**
    ```diff
    - Future<List<MenuItemModel>> getCachedMenuItems({ required String category });
    + Future<List<MenuItemModel>> getCachedMenuItems({ required String placeId, required String category });
    ```

    **`menu_local_data_source_sqflite.dart`:**
    *Note: This assumes you add a `placeId` column to your `menu_items` table schema.*
    ```diff
    // In getCachedMenuItems and cacheMenuItems
    - where: 'category = ?', whereArgs: [category]
    + where: 'placeId = ? AND category = ?', whereArgs: [placeId, category]
    ```

### 3.2. Domain Layer

The domain layer defines the business logic and contracts.

#### 3.2.1. Repository (`menu_repository.dart`, `menu_repository_impl.dart`)

*   **What to change**:
    1.  Update the `MenuRepository` interface to accept `placeId` in the `getMenuItems` method.
    2.  Update `MenuRepositoryImpl` to pass the `placeId` down to both the remote and local data sources.
*   **Why**: The repository acts as the single source of truth for the application's data. It needs to orchestrate data fetching for a specific `placeId`.

    **`menu_repository.dart`:**
    ```diff
    - TaskEither<Failure, List<MenuItemEntity>> getMenuItems({ required String category, ... });
    + TaskEither<Failure, List<MenuItemEntity>> getMenuItems({ required String placeId, required String category, ... });
    ```

#### 3.2.2. Use Cases (`get_menu_items.dart`)

*   **What to change**:
    1.  Create a `GetMenuItemsParams` class that includes `placeId`.
    2.  Update the `GetMenuItems` use case to accept these params and pass them to the repository.
*   **Why**: Use cases should encapsulate the parameters required for a specific business operation. This makes the BLoC layer cleaner and the use case more explicit.

    **`get_menu_items.dart`:**
    ```diff
    - class GetMenuItemsParams extends Equatable { final String category; ... }
    + class GetMenuItemsParams extends Equatable { final String placeId; final String category; ... }
    ```

### 3.3. BLoC Layer

The BLoC layer manages the application's state.

#### 3.3.1. Events & State (`menu_event.dart`, `menu_state.dart`)

*   **What to change**:
    1.  Add `placeId` to the `LoadMenuEvent`.
    2.  Add `placeId` to the `MenuState`.
*   **Why**: The BLoC needs to know which `placeId` it is currently handling to request the correct data and to store it in its state. This prevents stale data from being shown if the `placeId` changes.

    **`menu_event.dart`:**
    ```diff
    - class LoadMenuEvent extends MenuEvent { final String category; ... }
    + class LoadMenuEvent extends MenuEvent { final String placeId; final String category; ... }
    ```

    **`menu_state.dart`:**
    ```diff
    - class MenuState extends Equatable { ... }
    + class MenuState extends Equatable { final String? placeId; ... }
    ```

#### 3.3.2. BLoC Logic (`menu_bloc.dart`)

*   **What to change**:
    1.  Update the `MenuBloc` to handle the `placeId` from the event.
    2.  Pass the `placeId` to the `GetMenuItems` use case.
    3.  Store the `placeId` in the emitted state.
*   **Why**: This connects the UI's request for data for a specific place to the data-fetching logic.

### 3.4. UI Layer

The final step is to update the UI to provide the `placeId`.

#### 3.4.1. Pages & Screens (`menu_page.dart`, `menu_screen.dart`)

*   **What to change**:
    1.  Add a `placeId` parameter to the `MenuPage` widget.
    2.  Pass this `placeId` when creating the `MenuBloc` and dispatching the initial `LoadMenuEvent`.
    3.  Pass the `placeId` down to the `MenuScreen` if needed.
*   **Why**: The UI is the entry point. It must be able to specify which place's data it wants to display.

### 3.5. Entry Point (`main.dart`)

*   **What to change**:
    1.  When instantiating `MenuPage`, provide a `placeId`. This can come from a configuration file (`.env`), a user selection, or another source.
*   **Why**: This kickstarts the entire multi-tenant data flow for the application.

## 4. Problems Encountered & Solutions

*   **Problem**: `The Dart compiler exited unexpectedly.`
    *   **Solution**: This cryptic error was caused by a mismatch in the Dependency Injection container. The `MenuBloc`'s constructor was updated, but its registration in `get_it` was not. **Always update DI registrations when you change a class's constructor.**
*   **Problem**: Compilation errors about mismatched method signatures (`has fewer named arguments than those of overridden method`).
    *   **Solution**: This occurred because an interface (e.g., `MenuRemoteDataSource`) was updated, but the implementing class (`MenuRemoteDataSourceImpl`) was not. **Ensure that when you change an abstract class or interface, you update all implementing classes.**
*   **Problem**: `404 Not Found` API errors.
    *   **Solution**: This was expected. It confirmed the Flutter app was making the correct request, but the backend was not ready. The solution is to configure the Strapi collection and permissions correctly.

## 5. Pitfalls to Avoid

*   **Incomplete Refactoring**: Do not forget any layer. A single missed `placeId` parameter will break the chain and cause compilation or runtime errors.
*   **Cache Contamination**: Forgetting to make the local cache `placeId`-aware is a critical error that will lead to users seeing data from the wrong place.
*   **Hardcoding**: Avoid hardcoding the `placeId`. It should be a dynamic variable passed down from the top of the widget tree, originating from a configuration or user state.

## 6. Lessons Learned

*   **Layered Architecture is Key**: Our clean architecture (UI -> BLoC -> Domain -> Data) made this significant refactoring manageable. Changes were isolated to specific layers.
*   **Contracts are Crucial**: Using abstract classes as interfaces for repositories and data sources allowed us to identify exactly where changes were needed and enforced consistency.
*   **Document Architectural Decisions**: The `strapi_config.md` file was invaluable for remembering the "why" behind our multi-tenancy strategy. This new document serves a similar purpose for the "how".
