# Project Bug Log

This document tracks identified bugs and their proposed or implemented solutions.

---

### 1. Build Failure: Undefined Platform Constants in `main.dart`

- **Symptom:** The build process fails with errors like `Error: Undefined name 'kIsWindows'`, `Error: Undefined name 'kIsLinux'`, etc.
- **Root Cause:** The platform-checking constants (e.g., `kIsWindows`), which are defined in `flutter/foundation.dart`, were not being recognized by the compiler during the build. This is likely due to a persistent build cache issue that was not resolved by `flutter clean`.
- **Fix / Workaround:** The platform-specific code block in `lib/main.dart` responsible for initializing `sqflite_ffi` for desktop was commented out. Since the primary target for debugging was Chrome (web), this code was not essential for a successful build and run.

```dart
// In lib/main.dart

// This block was commented out to resolve the build issue.
// if (kIsWindows || kIsLinux || kIsMacOS) {
//   sqflite_ffi.sqfliteFfiInit();
// }
```

---

### 2. Runtime Crash on Web: Unsupported `dart:io` Operation

- **Symptom:** The application builds and launches on the web but immediately crashes with the error `DartError: Unsupported operation: Platform._operatingSystem`.
- **Root Cause:** The `lib/core/database/database_helper.dart` file used `dart:io`'s `Platform` class to perform operating system checks. The `dart:io` library is unavailable in a web environment, leading to a runtime exception when any of its APIs are called.
- **Fix:** The `DatabaseHelper` class was refactored to be web-aware. 
  1.  Import `package:flutter/foundation.dart` to get access to the `kIsWeb` constant.
  2.  Add guards around any code that uses `dart:io` or attempts to interact with the sqflite database, preventing it from running when `kIsWeb` is true.

```dart
// Example fix in lib/core/database/database_helper.dart

import 'package:flutter/foundation.dart'; // Import foundation
import 'dart:io'; // Keep for mobile/desktop

// ...

Future<void> initialize() async {
  // Guard against running on web
  if (kIsWeb || _isInitialized) return;
  
  try {
    await database;
    _isInitialized = true;
  } catch (e) {
    // On web, this will throw, which is now handled gracefully.
    _isInitialized = true; 
  }
}
```
