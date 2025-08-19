# Prioritized Fix List

This document lists the highest-impact bugs and small improvements to address before a production release. Each item includes a short description, reproduction / verification steps, a proposed fix, priority, owner (assign when creating the issue/PR), and a small estimate.

## 1 — Web runtime: `dart:io` / Platform usage (BLOCKER)
- Priority: P0
- Symptom: App crashes on web with `Unsupported operation: Platform._operatingSystem`.
- Repro steps: Build/run app on web and exercise any code touching `DatabaseHelper` or other `dart:io` APIs.
- Proposed fix:
  1. Audit files that import `dart:io` (e.g., `lib/core/database/database_helper.dart`) and guard platform-specific code with `kIsWeb` or `Platform.isX` behind `!kIsWeb`.
  2. Replace direct `Platform` usage with `package:flutter/foundation.dart` checks where possible.
- Verification: App runs on web without throwing; database features are no-op or gracefully degraded on web.
- Estimate: 1–2 dev days

## 2 — CORS & image loading on Web (HIGH)
- Priority: P0/P1
- Symptom: Images fail to load on web due to CORS or non-CDN URLs.
- Repro steps: Open onboarding/menu pages on web and observe failed image network calls in devtools.
- Proposed fix:
  1. Ensure images are served from Cloudflare CDN with proper CORS headers.
  2. Add a development CORS proxy for local dev (documented) and use `kIsWeb` guards for fallback assets.
  3. Add retry and placeholder flows in image loading utilities.
- Verification: Images load on web without CORS errors; unit/integration test uses a test CDN URL.
- Estimate: 2–3 dev days

## 3 — API 404 handling and endpoint verification (HIGH)
- Priority: P1
- Symptom: API return 404 when Strapi collection missing or private.
- Repro steps: Call `/api/menu-screens` or onboarding endpoints with missing collections or invalid tokens.
- Proposed fix:
  1. Add defensive parsing and explicit error mapping in remote data sources.
  2. Add health-check endpoints in docs and integration tests against a staging Strapi instance.
- Verification: App surfaces a friendly error and retries/backoff; integration tests cover missing collection case.
- Estimate: 1–2 dev days

## 4 — Image caching (performance) (MEDIUM)
- Priority: P2
- Symptom: Repeated image downloads; UX lag on slow networks.
- Proposed fix: Use `cached_network_image` with explicit disk cache configuration; ensure images cached after first load on all platforms.
- Verification: Network panel shows cached responses after first load; manual QA on Android/iOS/web.
- Estimate: 1–2 dev days

## 5 — Coverage & CI (measurements and guard) (HIGH)
- Priority: P1
- Symptom: Current `coverage/lcov.info` shows low line coverage (~28%) and missing function/branch data.
- Proposed fix:
  1. Add GitHub Actions workflow: analyze → test (with coverage) → lcov upload / report.
  2. Re-run full test suite locally/CI to regenerate a complete `lcov.info` (use `flutter test --coverage`).
  3. Fail CI if line coverage drops below target (e.g., 75% for now).
- Verification: CI uploads coverage and shows accurate line/function/branch metrics; thresholds enforced.
- Estimate: 1–2 dev days

## 6 — Cache invalidation for menu data (MEDIUM)
- Priority: P2
- Symptom: Local cache stale after backend changes.
- Proposed fix: Add versioning/etag or timestamp-based invalidation; add manual refresh control in UI.
- Verification: When backend changes, UI refreshes after invalidation or manual refresh succeeds.
- Estimate: 1–2 dev days

## 7 — Platform init for sqflite ffi (LOW / cleanup)
- Priority: P3
- Symptom: Build failures for desktop due to platform constants or missing init.
- Proposed fix: Apply guarded init for `sqflite_ffi` behind desktop platform checks and ensure imports are platform-aware.
- Verification: Desktop builds succeed; CI matrix includes desktop target if needed.
- Estimate: 0.5–1 day

---
How to use
- Create one GitHub Issue per bullet (use the `Priority: P#` label).
- Attach a short PR that references the issue and follows the PR template in `.github/PULL_REQUEST_TEMPLATE.md`.
- Prefer small, focused PRs that fix one item at a time.

Last updated: 2025-08-19
