# Class Guide — Project Structure + Hot Reload & Build Modes

A single page to keep open **while teaching**. It covers both topics in one class.
Full reference notes: [FLUTTER_PROJECT_STRUCTURE.md](FLUTTER_PROJECT_STRUCTURE.md) · [HOT_RELOAD_AND_BUILD_MODES.md](HOT_RELOAD_AND_BUILD_MODES.md)

- **Duration:** ~75 min (two 30-min topics + live demos + 10 min wrap-up)
- **Have open before you start:** editor with `app/` (demo app) and `app2/` (real app), a terminal, a phone/emulator
- **Pre-run:** `cd app && flutter pub get` so the first `flutter run` is quick

**Symbols:** 🗣️ = say this · 🖥️ = show / do this · ❓ = ask the class · ⚠️ = point to stress

---

## Timeline

| Time | Block | Section |
|---|---|---|
| 0:00–0:05 | Opening + hook | [§0](#0--opening-5-min) |
| 0:05–0:12 | `lib/` | [§1](#1--lib-7-min) |
| 0:12–0:20 | `android/` + `ios/` | [§2](#2--android-and-ios-8-min) |
| 0:20–0:26 | `assets/` | [§3](#3--assets-6-min) |
| 0:26–0:33 | Dependencies | [§4](#4--dependencies-7-min) |
| 0:33–0:35 | ☕ Bridge | [§5](#5--bridge-2-min) |
| 0:35–0:45 | Hot reload vs restart (live) | [§6](#6--hot-reload-vs-hot-restart-10-min-live) |
| 0:45–0:55 | Build modes | [§7](#7--build-modes-10-min) |
| 0:55–1:02 | Logs in debug mode (live) | [§8](#8--seeing-logs-7-min-live) |
| 1:02–1:15 | Recap, quiz, Q&A | [§9](#9--wrap-up-10-min) |

---

## 0 — Opening (5 min)

🗣️ "Today has two halves. First: **where things live** in a Flutter project. Second: **how the app runs** while we develop and when we ship. By the end, for any task you'll know which file to open, and whether you need `r`, `R`, or a full rebuild to see it."

❓ **Hook:** "You add `assets/logo.png`, press save, and the app says *Unable to load asset*. What went wrong?"
→ Let 2–3 people answer. (Answer: not listed in `pubspec.yaml` **and** needs a restart, not a hot reload. This one question links both halves.)

🖥️ Draw / show the one picture:

```text
your project/
├── lib/            ← YOUR Dart code (95% of work)
├── android/        ← Android shell that hosts Flutter
├── ios/            ← iOS shell that hosts Flutter
├── assets/         ← images, fonts, json bundled INTO the app
├── pubspec.yaml    ← manifest: name, version, deps, assets
└── pubspec.lock    ← exact resolved versions (auto)
```

🗣️ "Flutter draws its own UI. `android/` and `ios/` are thin containers that start the engine and run `lib/main.dart`."

---

## 1 — `lib/` (7 min)

🖥️ Open `app2/lib/` and walk the folders.

| Folder | Holds |
|---|---|
| `main.dart` | Entry point → `runApp()` |
| `screens/` | One file/folder per screen |
| `widgets/` | Reusable UI used by 2+ screens |
| `models/` | Data classes (API response → Dart) |
| `service/` | API calls, storage, analytics |
| `theme/`, `l10n/`, `config.dart` | Styling, translations, constants |

🗣️ The 3-layer model:

```text
screens/  →  service/  →  models/
(what user sees) (fetch/save) (typed data)
```

⚠️ "No API calls inside screens. No UI inside services."
⚠️ Import with the package name: `import 'package:ecm/config.dart';`
⚠️ Flutter only *requires* `main.dart`. The folder layout is **our** convention.

---

## 2 — `android/` and `ios/` (8 min)

| Task | Android | iOS |
|---|---|---|
| **Permissions** | `android/app/src/main/AndroidManifest.xml` | `ios/Runner/Info.plist` (**must** add a usage reason text) |
| App id / bundle id | `android/app/build.gradle` | Xcode → Runner target |
| Icon / splash | `android/app/src/main/res/` | `ios/Runner/Assets.xcassets/` |
| Firebase config | `android/app/google-services.json` | `ios/Runner/GoogleService-Info.plist` |
| Capabilities (push, deep links) | Manifest intent filters | `Runner.entitlements` |
| Native deps | Gradle | `ios/Podfile` → `pod install` |

⚠️ iOS: open **`Runner.xcworkspace`**, not `.xcodeproj`.
⚠️ Missing `Info.plist` reason → app **crashes** or is **rejected**.
⚠️ Keystore (`.jks`) and `key.properties` are secrets. Never commit them.

🔗 Link to part 2: "Anything you change here is native, so hot reload **won't** apply it. Remember that."

---

## 3 — `assets/` (6 min)

🗣️ "Two steps, always."

1. Put the file in `assets/`
2. Declare it in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/oops.png        # one file
    - assets/images/         # folder (NOT sub-folders)
```

```dart
Image.asset('assets/oops.png');
SvgPicture.asset('assets/forgot-password.svg'); // needs flutter_svg
```

⚠️ YAML indentation = spaces only.
⚠️ Folder entry is **not recursive**. List each sub-folder.
⚠️ After editing the assets list → **restart** the app (reload isn't enough).
⚠️ Anyone can unzip the APK/IPA and read assets. **No secrets** (check that `.env`).

---

## 4 — Dependencies (7 min)

🖥️ Open `app2/pubspec.yaml`.

```yaml
version: 1.1.38+38     # versionName + buildNumber
dependencies:          # ships with app
  dio: ^5.8.0+1
dev_dependencies:      # dev/test only
  flutter_lints: ^5.0.0
```

| Syntax | Means |
|---|---|
| `^5.8.0` | ≥ 5.8.0 and < 6.0.0 (usual) |
| `5.8.0` | exact |
| `any` | avoid |

```bash
flutter pub get        # install
flutter pub add dio    # add + update pubspec
flutter pub upgrade    # bump within ranges
flutter pub outdated   # what's newer
flutter clean          # nuke build/, then pub get
```

⚠️ **Commit `pubspec.lock`** for apps. Never hand-edit it.
⚠️ Upgrade Firebase packages **together**.
⚠️ **Package** = pure Dart. **Plugin** = Dart + native code → may need Manifest / `Info.plist` / `pod install` **and a full rebuild**.

🖥️ **Worked example: "Add a camera feature"**
1. `pubspec.yaml` → `camera` → `flutter pub get`
2. `AndroidManifest.xml` → camera permission
3. `Info.plist` → `NSCameraUsageDescription`
4. `lib/service/` wrapper → `lib/screens/` UI
5. **Stop the app and `flutter run` again** ← this leads into part 2

---

## 5 — Bridge (2 min)

🗣️ "We just said 'stop and run again' after adding a plugin. Why can't we just save the file? That's the second half: how Flutter runs your code."

---

## 6 — Hot reload vs hot restart (10 min, LIVE)

```text
              how               keeps state?  re-runs main()?  speed
Hot reload    r / save          YES           NO               < 1 s
Hot restart   R                 NO            YES              1–3 s
Full restart  q → flutter run   NO            YES              10 s+
```

### 🖥️ Demo 1: reload keeps state
1. `cd app && flutter run`
2. Tap **+** until counter = **5**
3. `main.dart`: `Colors.deepPurple` → `Colors.green`, save
4. Toolbar is green, **counter still 5** ✅

### 🖥️ Demo 2: reload does NOT re-run init code
1. Change `int _counter = 0;` → `int _counter = 100;`, save → **nothing changes**
2. ❓ "Why?" → field already initialised; reload only re-runs `build()`
3. Press **`R`** → counter is **100**, back on first screen

### 🖥️ Demo 3 (optional): plugin needs full rebuild
Add a plugin, press `R` → `MissingPluginException` → `q` then `flutter run`.

| Change | Use |
|---|---|
| UI / `build()` / most logic | `r` |
| `main()`, `initState`, globals, static fields | `R` |
| Stateless ↔ Stateful, enums, generics | `R` |
| `android/`, `ios/`, plugin, pubspec, icon | `q` → `flutter run` |
| Reload "did nothing" | Check terminal for compile error, then try `R` |

🗣️ Rule: **"Didn't show? Try `R`. Still not? Stop and run again."**

Terminal keys: `r` reload · `R` restart · `q` quit · `v` DevTools · `p` debug paint · `w` widget tree · `h` help

---

## 7 — Build modes (10 min)

🗣️ "Hot reload only exists because debug uses **JIT**: the code is compiled while the app runs, so it can be swapped. Profile and release use **AOT**: compiled to machine code ahead of time. Fast, but nothing to swap."

| | Debug | Profile | Release |
|---|---|---|---|
| Command | `flutter run` | `flutter run --profile` | `flutter run --release` |
| Compile | JIT | AOT | AOT |
| Hot reload | ✅ | ❌ | ❌ |
| `assert()` | ✅ | ❌ | ❌ |
| DevTools | Full | Performance | ❌ |
| Speed | Slow (by design) | ≈ release | Fastest |
| Emulator | ✅ | ❌ real device only | ✅ Android |
| For | Building | **Measuring perf** | Shipping / final QA |

```bash
flutter build apk          # Android APK
flutter build appbundle    # Play Store
flutter build ipa          # App Store / TestFlight
```

```dart
import 'package:flutter/foundation.dart';
if (kDebugMode)   { ... }   // stripped from release
if (kReleaseMode) { ... }
assert(x != null);          // ignored in release!
```

⚠️ **Never judge performance in debug.** Use profile on a real (ideally low-end) device.
⚠️ `assert` is not validation. It disappears in release.
⚠️ Some bugs are release-only. **Test a release build before shipping.**

❓ "Your list scrolls badly in debug. Is it a real problem?" → Not necessarily. Check in profile.

---

## 8 — Seeing logs (7 min, LIVE)

| You ran via… | Logs appear in |
|---|---|
| `flutter run` | Same terminal |
| VS Code | **Debug Console** |
| Android Studio | **Run** tab / **Logcat** |
| Anywhere | **DevTools → Logging** (press `v`) |
| Already running | `flutter logs` in another terminal |

```dart
import 'dart:developer' as developer;

print('hi');                         // basic; long lines cut on Android
debugPrint('body: $body');           // ✅ preferred: throttled, no dropped lines
developer.log('Login failed', name: 'auth', error: e, stackTrace: st);
// ↑ shows in DevTools / IDE console, NOT the plain flutter run terminal
```

Native logs: `adb logcat -s flutter` (Android) · Xcode console / Console.app (iOS)
Network calls: DevTools → **Network** · Widget tree: DevTools → **Inspector**

🖥️ Add `debugPrint('tapped: $_counter');` in `_incrementCounter`, hot reload, tap, show the terminal, then press `v` and show the Logging tab.

⚠️ `print` / `debugPrint` **still run in release** and are readable via logcat. Wrap them: `if (kDebugMode) debugPrint(...)`. **Never log tokens or passwords.**

---

## 9 — Wrap-up (10 min)

### Recap (say it out loud)
1. `lib/` = our code, organised as screens → service → models.
2. Native changes go in `android/` + `ios/`. Permissions need **both** files.
3. Assets: file **plus** `pubspec.yaml` entry, then restart.
4. `^` versions, commit the lock, plugin ≠ package.
5. `r` keeps state, `R` re-runs `main()`, native/plugin changes need a full rerun.
6. Debug to build, profile to measure, release to ship.
7. `debugPrint` + DevTools for logs; guard them with `kDebugMode`.

### Quick quiz (ask, then reveal)

| # | Question | Answer |
|---|---|---|
| 1 | Where do screens go? | `lib/screens/` |
| 2 | "Unable to load asset". Two causes? | Not in `pubspec.yaml`; didn't restart |
| 3 | Camera permission: which two files? | `AndroidManifest.xml`, `Info.plist` |
| 4 | What does `^5.8.0` allow? | ≥ 5.8.0, < 6.0.0 |
| 5 | Edited `initState`, pressed `r`, no change. Why? | `initState` doesn't re-run; use `R` |
| 6 | Added plugin, pressed `R`, `MissingPluginException`. Fix? | `q` → `flutter run` |
| 7 | Why no hot reload in release? | AOT, no JIT VM to swap code |
| 8 | Which mode for finding jank? | Profile, on a real device |
| 9 | Is `assert(user != null)` safe protection? | No, it's stripped in release |
| 10 | Does `debugPrint` run in release? | Yes, wrap it in `kDebugMode` |

### Likely questions from the class

- **"Is hot reload on save safe?"** Yes. If there's a compile error, it's rejected and the old code keeps running.
- **"Why is the debug app so slow on my phone?"** JIT plus debug checks. Try `--profile` or `--release`.
- **"When do I run `flutter clean`?"** Odd build errors, after switching branches with native changes, or after an SDK upgrade. Then `pub get`.
- **"Can I hot reload on a real device?"** Yes, in debug mode over USB/Wi-Fi.
- **"Does hot restart clear SharedPreferences?"** No. Only in-memory Dart state is cleared; disk data stays.

### Closing line
🗣️ "Two questions to ask before any change: **which file?** and **reload, restart, or rebuild?** If you can answer both, you'll stop losing time to 'why isn't my change showing up?'"
