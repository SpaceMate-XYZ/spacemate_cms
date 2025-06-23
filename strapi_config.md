# Strapi Integration & Multi-Tenancy Architecture Guide

This document outlines the architectural decisions and implementation details for integrating the Flutter application with Strapi, focusing on the strategy for multi-tenancy.

---

## 1. Multi-Tenancy Strategy: Subdomain vs. Subfolder

To support multiple places or tenants, we considered two primary URL structures:

- **Subdomain Approach**: `https://{placeId}.spacemate.xyz/api/...`
- **Subfolder Approach**: `https://spacemate.xyz/api/{placeId}/...`

### Recommendation: Subfolder Approach

We have chosen the **subfolder approach** (`/api/{placeId}/...`) as the target architecture. It offers the best balance of simplicity, scalability, and operational ease.

**Advantages:**
- **Simplified SSL/TLS Management**: Avoids the complexity and cost of provisioning wildcard SSL certificates or individual certificates for each subdomain.
- **Easier DNS Configuration**: Does not require programmatic updates to DNS records for each new tenant.
- **Gateway-Friendly**: This pattern is idiomatic for API Gateways like Apache APISIX or Nginx, allowing for straightforward path-based routing and policy enforcement.
- **RESTful and Clean**: It provides a clean, hierarchical structure that is easy for developers to understand and work with.

---

## 2. Backend Setup: Strapi with a Reverse Proxy

To implement the subfolder strategy, a reverse proxy (e.g., Apache APISIX, Nginx) should be placed in front of your Strapi/NestJS backend.

### Conceptual Workflow

1.  **Incoming Request**: The Flutter app sends a request to `https://spacemate.xyz/api/a-real-place-id/menu-screens`.
2.  **API Gateway / Reverse Proxy**: The gateway receives the request.
3.  **Path-Based Routing**: It uses the `/api/{placeId}/` path to identify the target tenant.
4.  **URL Rewriting**: The gateway can rewrite the URL before forwarding it to the appropriate backend service. For instance, it could forward the request to a specific Strapi instance or a NestJS service responsible for that `placeId`.

**Example Nginx Configuration Snippet:**

```nginx
location ~ ^/api/([a-zA-Z0-9_-]+)/(.*)$ {
    # The first capture group ($1) is the placeId
    # The second capture group ($2) is the rest of the path
    
    # Example: Proxy to a NestJS service, passing placeId as a header
    set $placeId $1;
    proxy_set_header X-Place-ID $placeId;
    proxy_pass http://your-nestjs-backend-service/$2$is_args$args;
}
```

This setup keeps the Strapi instance itself simple, while the gateway handles the complexity of routing and tenancy.

---

## 3. Flutter Implementation Details

To align with this architecture, the Flutter application's data layer must construct the correct URL.

### Current (Simplified) Implementation

For initial development, we have temporarily removed the `placeId` to simplify the integration. The API call is currently hardcoded:

```dart
// in lib/features/menu/data/datasources/menu_remote_data_source_impl.dart

Future<List<MenuItemModel>> getMenuItems(...) async {
  // ...
  final response = await _dioClient.get(
    '/api/menu-screens', // No placeId
    queryParameters: queryParams,
  );
  // ...
}
```

### Target (Place-Aware) Implementation

To re-enable multi-tenancy in the future, the `getMenuItems` method should be updated to accept a `placeId` and construct the URL dynamically:

```dart
// in lib/features/menu/data/datasources/menu_remote_data_source_impl.dart

Future<List<MenuItemModel>> getMenuItems({
  required String placeId, // Re-introduce placeId
  // ...
}) async {
  // ...
  final response = await _dioClient.get(
    '/api/$placeId/menu-screens', // Use placeId as a subfolder
    queryParameters: queryParams,
  );
  // ...
}
```

This change will need to be propagated up through the repository, BLoC, and UI layers by re-introducing the `placeId` parameter where it was removed.

---

## 4. Strapi CMS Configuration

To make the Flutter app work, you must configure your Strapi backend to match the data structure the app now expects. Follow these steps precisely.

### Step 1: Create the 'Menu Grid' Component

First, we will create a reusable Component that defines the structure of a single menu item.

1.  **Go to the Content-Type Builder**: In your Strapi admin panel, navigate to `Plugins` > `Content-Type Builder`.
2.  **Create a New Component**:
    *   Click on **+ Create new component**.
    *   **Component name**: `MenuGrid`
    *   **Category**: `menu` (or a category of your choice)
    *   Leave the icon as the default.
3.  **Add Fields to the Component**:
    *   **`label`**: `Text` field (Short text).
    *   **`icon`**: `Text` field (Short text). This will store the icon name (e.g., "home", "settings").
    *   **`order`**: `Number` field (integer).
    *   **`isVisible`**: `Boolean` field (default to `true`).
    *   **`isAvailable`**: `Boolean` field (default to `true`).
4.  **Save** the component.

### Step 2: Create the 'Screen' Collection Type

Next, we will create the main Collection Type that will hold the screen data and use our new component.

1.  **Create a New Collection Type**:
    *   In the Content-Type Builder, click on **+ Create new collection type**.
    *   **Display name**: `Screen`
    *   The `API ID (Plural)` will be `screens` (e.g., `/api/screens`). This is critical.
2.  **Add Fields to the Collection Type**:
    *   **`name`**: `Text` field (Short text). This is for internal reference (e.g., "Home Screen").
    *   **`slug`**: `Text` field. **This is the most important field.**
        *   Go to the `Advanced` tab for this field and check **`Required field`** and **`Unique field`**.
        *   This `slug` will be used to fetch the screen (e.g., `home`, `settings-menu`).
    *   **`MenuGrid`**: `Component` field.
        *   Select **`Repeatable component`**.
        *   Under `Use an existing component`, select the `menu` category and choose the **`MenuGrid`** component you created.
3.  **Save** the Collection Type.

### Step 3: Add Content and Set Permissions

1.  **Create a 'Home' Screen Entry**:
    *   Go to `Content Manager` > `Screen`.
    *   Click **+ Create new entry**.
    *   Set **`name`** to `Home Screen`.
    *   Set **`slug`** to **`home`**. (This must match what the Flutter app requests initially).
    *   Click **`Add new MenuGrid`** to add your first menu item.
        *   **label**: `Explore`
        *   **icon**: `explore`
        *   **order**: `1`
        *   **isVisible**: `true`
        *   **isAvailable**: `true`
    *   Add a few more items as needed.
2.  **Save and Publish** the entry.
3.  **Set Public Permissions**:
    *   Go to `Settings` > `Roles` > `Public`.
    *   Under `Permissions`, find **`Screen`**.
    *   Check the boxes for **`find`** and **`findOne`**. This allows the public (your Flutter app) to read the screen data.
    *   **Save** the permissions.

Your Strapi backend is now fully configured. When you run the Flutter app, it will make a request to `/api/screens?filters[slug][$eq]=home`, and Strapi will return the menu items you just created.
