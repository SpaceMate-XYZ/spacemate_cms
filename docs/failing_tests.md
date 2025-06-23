# Failing Tests

This document lists all currently failing or flaky tests in Spacemate CMS.

---

## [Date: 2025-06-23]

### 1. Widget: MenuGridItem - Image not rendering
- **Test:** `MenuGridItem displays image from network`
- **Error:** Image widget not found in widget tree
- **Suspected Cause:** Network image URL is null or invalid from API
- **Status:** Investigating

### 2. Integration: Offline cache fallback
- **Test:** `App loads cached menu items when offline`
- **Error:** Throws exception if cache is empty
- **Suspected Cause:** Cache not seeded in test setup
- **Status:** Pending fix

---

Update this file as new failing tests are discovered or resolved.
