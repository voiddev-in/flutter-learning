# Flutter Project Structure — `lib/`, `android/`, `ios/`, `assets`, dependencies

A learning guide for the Flutter team. Examples come from our own app (`app2/`, package name `ecm`), so you can open the real files while reading.

**One picture to hold in your head:**

```text
your project/
├── lib/            ← YOUR Dart code. 95% of your work happens here
├── android/        ← Android shell that hosts your Flutter app
├── ios/            ← iOS shell that hosts your Flutter app
├── assets/         ← images, fonts, svgs, json bundled INTO the app
├── pubspec.yaml    ← the manifest: name, version, dependencies, assets list
└── pubspec.lock    ← exact versions that were resolved (auto-generated)
```

Flutter draws its own UI. `android/` and `ios/` are thin native "containers" that start the Flutter engine and run `lib/main.dart` inside it.

---

## Part 1 — `lib/` (your Dart code)

Everything you write lives here. The entry point is `lib/main.dart`, which calls `runApp(...)`.

### 1.1 Rules

- All Dart source for the app goes under `lib/`.
- Files inside `lib/` are imported with the package name:
  ```dart
  import 'package:ecm/config.dart';      // ecm = `name:` in pubspec.yaml
  ```
- Folder layout inside `lib/` is **our choice**. Flutter only requires `main.dart`.

### 1.2 How our `app2/lib/` is organised

| Path | What it holds |
|---|---|
| `main.dart` | Entry point, starts the app |
| `tapp.dart` | App root widget, routes, theme wiring |
| `config.dart` | Constants / environment config |
| `screens/` | One file or folder per screen (`login.dart`, `feed/`, `package/` …) |
| `widgets/` | Reusable UI pieces used by many screens |
| `models/` | Plain data classes (what an API response becomes in Dart) |
| `service/` | Talks to the outside: API calls, analytics, storage |
| `settings/` | Settings-related screens |
| `theme/` | Colors, text styles, `ThemeData` |
| `l10n/` | Translations (language files) |
| `common/`, `common_utils.dart` | Shared helpers |
| `firebase_config.dart`, `notification*.dart` | Firebase and push setup |

### 1.3 The mental model: three layers

```text
screens/ (what the user sees)
   ↓ calls
service/ (fetches / saves data)
   ↓ returns
models/ (typed data objects)
```

Keep UI out of `service/`, and API calls out of `screens/`. That makes both testable and easier to change.

### 1.4 Good habits

- One class per file where practical; file name = `snake_case.dart`.
- A screen that grows large → make a folder (we did this with `screens/feed/` and `feed/widgets/`).
- Put anything reused by 2+ screens in `widgets/` or `common/`.
- Don't put assets, JSON or images in `lib/`; that's what `assets/` is for.

---

## Part 2 — `android/`

The native Android project (Gradle). Flutter builds your Dart into it and produces an APK/AAB.

| Path | Purpose |
|---|---|
| `android/app/build.gradle(.kts)` | App id (`applicationId`), min/target SDK, signing, version wiring |
| `android/app/src/main/AndroidManifest.xml` | **Permissions** (camera, internet…), app name, launcher activity, deep-link intent filters |
| `android/app/src/main/res/` | Launcher icons, splash, native styles/strings |
| `android/app/src/main/kotlin/…/MainActivity.kt` | The Activity that hosts Flutter (rarely edited) |
| `android/app/google-services.json` | Firebase config for Android |
| `android/build.gradle`, `settings.gradle`, `gradle.properties` | Project-wide Gradle config |

**When you touch it**
- Adding a permission (camera, notifications, storage).
- Changing app id, app name, icon, splash.
- Deep links / app links (we recently added auto-redirect with deep links).
- Signing for Play Store release.
- Fixing a Gradle / SDK-version build error.

**Signing keys are secrets.** `upload-keystore.jks` and any `key.properties` must never be committed or shared.

---

## Part 3 — `ios/`

The native iOS project (Xcode). Same idea as `android/`.

| Path | Purpose |
|---|---|
| `ios/Runner/Info.plist` | **Permission descriptions** (camera usage text…), app display name, URL schemes |
| `ios/Runner/AppDelegate.swift` | App startup hook (rarely edited) |
| `ios/Runner/Assets.xcassets/` | App icon, launch image |
| `ios/Runner/GoogleService-Info.plist` | Firebase config for iOS |
| `ios/Runner/Runner.entitlements` | Capabilities: push notifications, Sign in with Apple, associated domains (universal links) |
| `ios/Podfile` | iOS dependency manager (CocoaPods) config, minimum iOS version |
| `ios/Runner.xcworkspace` | **Open this** in Xcode, not `Runner.xcodeproj` |

**When you touch it**
- Adding a permission: iOS **requires a text reason** in `Info.plist` or the app crashes / is rejected.
- Push notifications, Apple sign-in, universal links (entitlements).
- Bundle id, signing team, version/build number.
- `pod install` failures after adding a plugin.

---

## Part 4 — `assets/`

Files shipped **inside** the app: images, SVGs, fonts, JSON, etc.

### 4.1 Two steps are always required

**Step 1: put the file in the folder** (`assets/oops.png`).

**Step 2: declare it in `pubspec.yaml`:**

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/oops.png          # a single file
    - techlathon_asserts/      # a whole folder (trailing slash, not recursive)
```

Forget step 2 and you get a runtime error: *"Unable to load asset"*.

### 4.2 Using them

```dart
Image.asset('assets/oops.png')

// SVG needs flutter_svg
SvgPicture.asset('assets/forgot-password.svg')
```

### 4.3 Gotchas

- **Indentation in `pubspec.yaml` matters** (YAML). Use spaces, consistent indent.
- A folder entry (`assets/images/`) does **not** include sub-folders. List each one.
- After changing the assets list: stop and re-run the app (hot reload won't pick it up).
- Big images increase app size. Compress before adding.
- **Anything in assets is readable by anyone who unzips the app.** Never put secrets there.
  - Note for review: our `pubspec.yaml` lists `.env` under assets. That bundles the file into the shipped app. Confirm it contains nothing secret (API keys, private tokens), since it can be extracted from the APK/IPA.
- Fonts are declared separately under `flutter: fonts:`.

---

## Part 5 — Dependencies (`pubspec.yaml`, `pubspec.lock`)

### 5.1 `pubspec.yaml` — the manifest

```yaml
name: ecm
version: 1.1.38+38          # 1.1.38 = version name, 38 = build number

environment:
  sdk: ">=3.10.0 <4.0.0"    # allowed Dart SDK range

dependencies:               # shipped with the app
  flutter:
    sdk: flutter
  dio: ^5.8.0+1
  provider: ^6.1.2
  firebase_core: ^4.3.0

dev_dependencies:           # only for development/testing
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

| Section | Meaning |
|---|---|
| `dependencies` | Packages your app needs at runtime |
| `dev_dependencies` | Test / lint / code-gen tools; not shipped |
| `dependency_overrides` | Force a version (use sparingly, temporary fixes) |

### 5.2 Version syntax

| Written | Means |
|---|---|
| `^5.8.0` | any `5.x.y` that is `>= 5.8.0` and `< 6.0.0` (the usual choice) |
| `5.8.0` | exactly this version |
| `>=5.0.0 <6.0.0` | explicit range |
| `any` | no constraint (avoid) |

### 5.3 `pubspec.lock`

- Auto-generated record of the **exact** versions chosen.
- **Commit it for apps** so everyone builds with identical versions.
- Never edit by hand.

### 5.4 Commands

```bash
flutter pub get          # download deps listed in pubspec.yaml
flutter pub add dio      # add a package and update pubspec.yaml
flutter pub remove dio   # remove it
flutter pub upgrade      # bump within allowed ranges (updates the lock)
flutter pub outdated     # see what has newer versions
flutter clean            # delete build/ and caches, then `pub get` again
```

### 5.5 Dependencies in our app (examples from `app2/pubspec.yaml`)

| Group | Packages | Why |
|---|---|---|
| State | `provider` | Share state across widgets |
| Networking | `dio`, `http` | API calls |
| Firebase | `firebase_core`, `firebase_auth`, `firebase_analytics`, `firebase_crashlytics`, `firebase_messaging` | Auth, analytics, crash reports, push |
| Security | `local_auth`, `encrypt`, `jwt_decoder` | Biometrics, encryption, token decoding |
| Device | `device_info_plus`, `package_info_plus`, `connectivity_plus`, `permission_handler`, `shared_preferences`, `path_provider` | Device info, network state, permissions, local storage |
| UI | `flutter_svg`, `carousel_slider`, `flutter_spinkit`, `visibility_detector` | SVGs, carousels, loaders, impression tracking |

The comment "UPGRADE TOGETHER" on the Firebase block is deliberate: Firebase packages depend on each other, so bump them as one set.

### 5.6 Plugin vs package

- **Package**: pure Dart (e.g. `intl`). Works everywhere with no native code.
- **Plugin**: Dart + native Android/iOS code (e.g. `camera`, `permission_handler`). May require edits in `android/` and `ios/` (permissions, min SDK, `pod install`).

This is why the folders are connected: **adding a plugin in `pubspec.yaml` often means touching `AndroidManifest.xml` and `Info.plist`.**

### 5.7 Choosing a package

Check on pub.dev: publisher verified, recent updates, platform support, popularity/likes, open issues, license. Fewer dependencies = fewer upgrade headaches and smaller app.

---

## Part 6 — How the pieces connect (worked example)

*"Add a camera feature."*

1. `pubspec.yaml`: add `camera: ^0.11.3`, run `flutter pub get`.
2. `android/app/src/main/AndroidManifest.xml`: add the camera permission.
3. `ios/Runner/Info.plist`: add `NSCameraUsageDescription` with a user-facing reason.
4. `lib/service/`: small wrapper around the camera API.
5. `lib/screens/`: the screen that uses it.
6. `assets/`: any icon needed → also list it in `pubspec.yaml`.
7. Stop, rebuild, run on a real device (camera doesn't work on all simulators).

---

## Part 7 — Other folders you will see

| Folder | Meaning |
|---|---|
| `test/` | Unit and widget tests |
| `build/` | Generated output. Gitignored. Safe to delete |
| `web/`, `windows/`, `linux/`, `macos/` | Same shell idea for the other platforms |
| `.dart_tool/` | Generated tooling cache. Ignore |
| `analysis_options.yaml` | Lint rules |
| `.gitignore` | What Git skips |

---

## Part 8 — Cheat sheet

| I want to… | Go to |
|---|---|
| Write screens, logic, API calls | `lib/` |
| Add a permission (Android) | `android/app/src/main/AndroidManifest.xml` |
| Add a permission (iOS) | `ios/Runner/Info.plist` |
| Change app icon / splash | `android/…/res/`, `ios/Runner/Assets.xcassets/` |
| Change app id / version | `pubspec.yaml` (version), `build.gradle`, Xcode |
| Add an image or font | `assets/` **and** `pubspec.yaml` |
| Add a library | `pubspec.yaml` → `flutter pub get` |
| Fix "Unable to load asset" | Check the path and the `pubspec.yaml` entry, then restart |
| Fix odd build errors | `flutter clean` → `flutter pub get` → rebuild |
| Fix iOS pod errors | `cd ios && pod install` |

---

## Part 9 — Common mistakes

| Mistake | Fix |
|---|---|
| Added an asset but didn't list it in `pubspec.yaml` | Add it, then fully restart the app |
| Folder in assets list doesn't load sub-folders | List each sub-folder |
| YAML indentation wrong | Use consistent spaces, no tabs |
| Added a plugin, app crashes on device | Check native setup: permissions, min SDK, `pod install` |
| iOS camera/location crash | Missing usage-description key in `Info.plist` |
| Secrets in `assets/` or committed keystore | Move to secure config; rotate anything exposed |
| Upgrading one Firebase package alone | Upgrade the whole Firebase set together |
| Editing `pubspec.lock` by hand | Don't. Change `pubspec.yaml` and run `pub get` |
| Business logic inside screen widgets | Move to `service/` |

---

## Part 10 — Practice questions

1. Which folder holds the Dart code you write most often?
2. You added `assets/logo.png` but get "Unable to load asset". What did you probably forget?
3. What does `^5.8.0` allow?
4. Which two native files need edits when adding a camera permission?
5. Why can't a real secret live in `assets/`?
6. What is the difference between `dependencies` and `dev_dependencies`?

**Answers**

1. `lib/`.
2. Declaring it under `flutter: assets:` in `pubspec.yaml` (and restarting).
3. Any version from `5.8.0` up to, but not including, `6.0.0`.
4. `AndroidManifest.xml` (Android) and `Info.plist` (iOS).
5. Assets are packed into the APK/IPA, and anyone can unzip the app and read them.
6. `dependencies` ship with the app; `dev_dependencies` are only for development and testing.
