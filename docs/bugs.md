# Bugs & Known Issues

This document tracks known bugs and their status in Spacemate CMS.

---

## [Date: 2025-06-23]

### 1. API 404 on `/api/menu-screens`
- **Description:** App shows 404 error if Strapi collection is not set up or public API access is disabled.
- **Workaround:** Ensure `menu-screens` collection exists and is public in Strapi admin.
- **Status:** Open

### 2. Cached data not updating after backend change
- **Description:** App may show stale menu data if cache is not invalidated.
- **Workaround:** Manually clear app cache or call `clearCachedMenuItems()`.
- **Status:** Open

---

Add new bugs as they are found. Remove or update bugs as they are fixed.
