# Strapi Configuration

## Overview

This document describes the Strapi CMS configuration for the SpaceMate Flutter app. The app uses Strapi to manage menu data and onboarding carousel content.

## Base URLs

- **Main Strapi URL**: `https://strapi.dev.spacemate.xyz`
- **API Prefix**: `/api`

## Collections

### 1. screens
- **Purpose**: Menu data and feature categories
- **Content**: Menu screens with their associated features
- **Usage**: Main menu grid display

### 2. spacemate-placeid-features
- **Purpose**: Onboarding carousel data
- **Content**: Feature-specific onboarding slides
- **Usage**: 4-slide carousels for each feature

## API Endpoints

### Menu Data
- **Endpoint**: `/api/screens`
- **Method**: GET
- **Query Parameters**: `populate=*`
- **Description**: Fetches all menu items with their features

### Onboarding/Carousel Data
- **Endpoint**: `/api/spacemate-placeid-features`
- **Method**: GET
- **Query Parameters**: 
  - `filters[feature_name][$eq]=FeatureName` (where FeatureName is the specific feature like "parking", "valetparking", etc.)
  - `populate=*`
- **Description**: Fetches onboarding carousel data for a specific feature

## Example API Calls

### Menu Data
```
GET https://strapi.dev.spacemate.xyz/api/screens?populate=*
```

### Onboarding Data for Parking
```
GET https://strapi.dev.spacemate.xyz/api/spacemate-placeid-features?filters[feature_name][$eq]=parking&populate=*
```

### Onboarding Data for Valet Parking
```
GET https://strapi.dev.spacemate.xyz/api/spacemate-placeid-features?filters[feature_name][$eq]=valetparking&populate=*
```

## Data Structure

### Menu Response (screens collection)
The `/api/screens` endpoint returns menu categories and their features.

### Onboarding Response (spacemate-placeid-features collection)
The `/api/spacemate-placeid-features` endpoint returns onboarding carousel data with:
- Feature information
- Onboarding slides (title, imageURL, header, body, button_label)
- Each slide has 4 screens (slides 1-4)

## Authentication

The app supports optional API token authentication:
- Set `STRAPI_API_TOKEN` in environment variables
- Token is automatically included in request headers

## CORS Configuration

For development, the app uses a proxy to handle CORS issues:
- Proxy URL: `https://api.allorigins.win/raw?url=`
- Automatically prepended to image URLs in development mode

## Error Handling

Common error responses and their meanings:
- 200: Success
- 400: Bad request (check filter parameters)
- 401: Unauthorized (check API token)
- 404: Not found (check endpoint and feature name)
- 500: Server error

## Configuration

The app uses environment variables for the Strapi base URL:
- `STRAPI_BASE_URL`: Base URL for Strapi API
- `CAROUSEL_STRAPI_BASE_URL`: Base URL for carousel-specific API calls

## Development Notes

- All API calls include `populate=*` to fetch related data
- Feature names are case-sensitive in filter parameters
- Images are hosted on CDN and referenced by URL
- The app caches menu data locally for offline functionality
