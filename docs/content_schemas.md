# Content Schemas

This document provides **real sample data** and schema definitions for the two main content types in the SpaceMate CMS app:  
- **Screens (Menus)**
- **Placeid-Features (Onboarding Carousel)**

---

## 1. Screens (Menus) Collection

### Empty JSON Structure

```json
{
  "data": [],
  "meta": {
    "pagination": {
      "page": 1,
      "pageSize": 25,
      "pageCount": 0,
      "total": 0
    }
  }
}
```

### Strapi JSON Example

```json
{
  "data": [
    {
      "id": 1,
      "attributes": {
        "slug": "home",
        "title": "Home Screen",
        "createdAt": "2023-10-26T10:00:00.000Z",
        "updatedAt": "2023-10-26T10:00:00.000Z",
        "publishedAt": "2023-10-26T10:00:00.000Z",
        "locale": "en",
        "MenuGrid": {
          "id": 1,
          "title": "Main Menu",
          "createdAt": "2023-10-26T10:00:00.000Z",
          "updatedAt": "2023-10-26T10:00:00.000Z",
          "publishedAt": "2023-10-26T10:00:00.000Z",
          "menu_items": [
            {
              "id": 1,
              "label": "Dashboard",
              "icon": "dashboard",
              "order": 1,
              "isVisible": true,
              "isAvailable": true,
              "badgeCount": 0
            },
            {
              "id": 2,
              "label": "Settings",
              "icon": "settings",
              "order": 2,
              "isVisible": true,
              "isAvailable": true,
              "badgeCount": 0
            }
          ]
        }
      }
    }
  ],
  "meta": {
    "pagination": {
      "page": 1,
      "pageSize": 25,
      "pageCount": 1,
      "total": 1
    }
  }
}
```

### SQLite Schema

```sql
CREATE TABLE IF NOT EXISTS menu_items (
  id INTEGER PRIMARY KEY,
  slug TEXT NOT NULL,
  label TEXT NOT NULL,
  icon TEXT,
  "order" INTEGER NOT NULL,
  is_visible INTEGER NOT NULL,
  is_available INTEGER NOT NULL,
  badge_count INTEGER,
  cached_at INTEGER NOT NULL
);
```
- **Indexes:** On `slug` and `"order"`.

---

## 2. Placeid-Features (Onboarding Carousel) Collection

### Empty JSON Structure

```json
{
  "data": []
}
```

### Strapi JSON Example

```json
{
  "data": [
    {
      "id": 1,
      "attributes": {
        "feature_name": "Parking",
        "onboarding_carousel": [
          {
            "id": 1,
            "feature": "Parking",
            "screen": "1",
            "title": "Welcome to Parking",
            "imageURL": "https://example.com/image1.png",
            "header": "Find your perfect spot",
            "body": "Easily locate and reserve parking spaces.",
            "button_label": null
          }
        ]
      }
    },
    {
      "id": 2,
      "attributes": {
        "feature_name": "Another Feature",
        "onboarding_carousel": null
      }
    }
  ]
}
```

#### Onboarding Slide Example (`onboarding_slide.json`)

```json
{
  "id": 1,
  "feature": "Parking",
  "screen": "1",
  "title": "Welcome to Parking",
  "imageURL": "https://example.com/image1.png",
  "header": "Find your perfect spot",
  "body": "Easily locate and reserve parking spaces.",
  "button_label": null
}
```

#### Onboarding Carousel Example (`onboarding_carousel.json`)

```json
{
  "slides": [
    {
      "id": 1,
      "feature": "Parking",
      "screen": "1",
      "title": "Welcome to Parking",
      "imageURL": "https://example.com/image1.png",
      "header": "Find your perfect spot",
      "body": "Easily locate and reserve parking spaces.",
      "button_label": null
    },
    {
      "id": 2,
      "feature": "Parking",
      "screen": "2",
      "title": "Secure and Convenient",
      "imageURL": "https://example.com/image2.png",
      "header": "Your vehicle is safe with us",
      "body": "Advanced security features for peace of mind.",
      "button_label": "Get Started"
    }
  ]
}
```

### SQLite Schema

**Note:**  
Currently, onboarding carousel data is **not** cached in SQLite. Only `menu_items` are cached.  
If onboarding caching is needed, a new table must be created, for example:

```sql
CREATE TABLE IF NOT EXISTS onboarding_carousel (
  id INTEGER PRIMARY KEY,
  feature_name TEXT NOT NULL,
  screen TEXT,
  title TEXT,
  image_url TEXT,
  header TEXT,
  body TEXT,
  button_label TEXT,
  cached_at INTEGER NOT NULL
);
```

#### Model Note
- The `onboarding_carousel` field in the `FeatureAttributes` model is a `List<OnboardingSlide>`, parsed directly from the JSON.

---

## Summary Table

| Data Type         | Strapi JSON Key         | SQLite Table         | Notes                                 |
|-------------------|------------------------|----------------------|---------------------------------------|
| Menus/Screens     | `data[].attributes`    | `menu_items`         | Menu items are cached in SQLite       |
| Onboarding Slides | `onboarding_carousel`  | (not present)        | Not currently cached in SQLite        |

---

**This file contains real sample data and schema definitions from your project. You can use it as a reference for development, migration, or documentation—even if the Strapi server is unavailable.** 