# Project Backlog

## High Priority
- **API Endpoint Verification**
  - Verify Strapi API endpoint: https://strapi.dev.spacemate.xyz/api/spacemate-placeid-features?populate=*
  - Test onboarding data retrieval for all features
  - Verify image loading from CDN URLs (all platforms)
  - Test error handling for invalid/missing feature names
- **Performance Optimization**
  - Implement image caching for onboarding slides
  - Optimize API response parsing
  - Implement lazy loading for menu items
- **Platform Testing**
  - Test app on Android, iOS, Web, Windows, macOS
  - Document and triage any platform-specific issues
- **Bug Fixes**
  - Fix CORS/image loading issues (especially on web)
  - Fix API 404 on `/api/menu-screens` if collection is missing or not public
  - Fix cache invalidation for menu data after backend changes
- **Documentation Updates**
  - Update all docs to reflect current architecture, features, and usage
  - Complete API documentation
  - Create/Update user guide, troubleshooting, and deployment docs

## Medium Priority
- **Advanced Features**
  - Implement offline mode with local data caching
  - Add push notifications for feature updates
  - Implement user preferences and settings (e.g., "Don't show again" onboarding)
  - Add analytics and user tracking
  - Implement A/B testing for onboarding flows
- **Security Enhancements**
  - Implement API rate limiting
  - Add request/response encryption
  - Implement secure token storage
  - Add input validation and sanitization
  - Implement security headers
- **Performance Monitoring**
  - Add performance monitoring and metrics (e.g., Flutter DevTools, Firebase Performance)
- **Testing**
  - Expand integration and widget tests for new features
  - Maintain >80% code coverage
  - Add platform-specific tests

## Low Priority / Nice-to-Have
- **Design System Enhancements**
  - Expand dynamic theming and custom theme support
  - Refine Material Design 3 integration
- **Developer Experience**
  - Add code style/linting automation
  - Add pre-commit hooks for formatting and tests
- **Ideas**
  - Explore additional onboarding flows for new features
  - Add deep linking and universal links support
  - Integrate with more third-party services (e.g., analytics, crash reporting)

## Ongoing
- Track and fix bugs (see `docs/bugs.md`)
- Update documentation as features evolve
- Regularly review and reprioritize backlog

---

**Legend:**
- High: Must-do for stability, correctness, or release
- Medium: Important for user experience, security, or growth
- Low: Nice-to-have, ideas, or polish

*Last updated: 2025-06-23* 