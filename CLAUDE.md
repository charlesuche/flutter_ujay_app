# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

**UJ Campus Tour** — a Flutter mobile app for navigating the University of Jos (UNIJOS), Nigeria. Users sign in, see a home dashboard, and can explore an interactive satellite map with Points of Interest (POI) loaded from Firestore.

## Common Commands

```bash
flutter pub get          # install dependencies
flutter run              # run on connected device/emulator
flutter run -d chrome    # run web version (limited — Maps/Firebase need extra web config)
flutter build apk        # build Android APK
flutter build ios        # build iOS (macOS + Xcode required)
flutter test             # run all tests
flutter test test/widget_test.dart  # run a single test file
flutter analyze          # static analysis / lint
```

## Architecture

State management is **GetX** throughout. The three layers are controllers, views, and models.

### Boot sequence (`lib/main.dart`)
Firebase is initialized first (`firebaseCons.dart`), then `AuthController` is registered as a GetX singleton. `GetMaterialApp` uses named routes defined in `AppRoutes`.

### Auth flow (`lib/app/controllers/authController.dart`)
`AuthController` binds `FirebaseAuth.authStateChanges()` to a reactive `Rxn<User>`. The `ever()` listener on that stream calls `handleAuthChanged`, which navigates to `Start` (unauthenticated) or `HomePage` (authenticated) and also streams the Firestore user document into `firestoreUser`. Admin status is checked against a Firestore `admin` collection.

### Routes (`lib/routes/appRoutes.dart`)
| Route | Widget |
|---|---|
| `/` | `Splash` |
| `/signin` | `Login` |
| `/signup` | `SignUp` |
| `/home` | `HomePage` |

### Firestore collections
- `users/{uid}` — user profile (`UserModel`: uid, email, name)
- `POI` — Points of Interest on campus; each document has `name`, `searchKey`, `desc`, `imgUrl`, `location` (GeoPoint)
- `admin/{uid}` — existence of doc grants admin role

### Map screen (`lib/app/views/mapViews/mapScreen.dart`)
`MyLocation` widget loads all POI docs from Firestore on init and places them as `Marker`s on a satellite `GoogleMap`. Tapping a marker shows a `ModalBottomSheet` with image, name, description, and direction options. Search queries Firestore POI by `name` (range query) or by `searchKey` (first character, uppercase). Polyline routing calls the Google Directions API via `flutter_polyline_points`.

### Secrets (`lib/app/constants/secrets.dart`)
This file is **gitignored**. It exports `googleMapsApiKey` (used by `mapScreen.dart`). Copy `secrets.dart.example` to `secrets.dart` and fill in your key before building. The Google Maps API key also needs to be set in `android/app/src/main/AndroidManifest.xml` (meta-data `com.google.android.geo.API_KEY`) and in `ios/Runner/AppDelegate.swift` for native map tiles to work.

### Firebase config files
- `android/app/google-services.json` — Android Firebase config (already committed)
- iOS equivalent (`GoogleService-Info.plist`) goes in `ios/Runner/` and must be added manually for iOS builds

## Known Issues / In-Progress Areas

- Gallery, Audio Tour, VR Tour Guide, and AR Tour Guide tiles on `HomePage` are UI placeholders with no implementation.
- `mapScreen.dart` has a self-assignment bug on line 45: `_controller = _controller` (should assign the parameter `_cntlr`).
- `setPolylines()` is called in `initState` but `_currentPosition` and `destinationLocation` are `late` and uninitialized at that point — it will throw. Polyline drawing should be triggered only after a destination is chosen.
- Much commented-out code throughout; earlier iterations are left inline.
- Dart SDK constraint (`>=2.12.0 <3.0.0`) and Firebase BOM (`27.1.0`) are outdated.
