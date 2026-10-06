# Hot Reload vs Hot Restart, and Build Modes (debug / profile / release)

A learning guide for the Flutter team. Examples use the counter app in `app/` (`app/lib/main.dart`), so you can try every step yourself.

**One picture to hold in your head:**

```text
                 how                 keeps state?  re-runs main()?  speed      use it for
Hot reload       r / save            YES           NO               < 1 s      UI tweaks, most code edits
Hot restart      R                   NO            YES              1–3 s      init code, globals, enums, generics
Full restart     q, then flutter run NO            YES              10 s–mins  native code, pubspec, assets*, plugins
```

\* New assets usually need at least a hot restart; new plugins or native changes always need a full rebuild.

And for build modes:

```text
debug    → for developing   (JIT, hot reload, asserts on, slow)
profile  → for measuring    (AOT, DevTools perf, no hot reload, real device only)
release  → for users        (AOT, fully optimised, no debugging)
```

---

## Part 1 — Hot reload (`r`)

### 1.1 What it does

Hot reload injects your **changed Dart source** into the running Dart VM, then Flutter **rebuilds the widget tree**. The app keeps running: same screen, same navigation stack, same `State` objects, same variable values.

Triggers:
- Save the file in VS Code / Android Studio (if "hot reload on save" is on)
- Press `r` in the terminal running `flutter run`
- The ⚡ button in the IDE

### 1.2 Try it with our app

1. `cd app && flutter run`
2. Tap **+** until the counter shows `5`.
3. In `app/lib/main.dart`, change `seedColor: Colors.deepPurple` to `Colors.green`. Save.
4. The toolbar turns green **and the counter is still `5`**.

That is the whole value of hot reload: you change UI without losing where you were in the app.

### 1.3 How it works (short version)

```text
you save → tool finds changed libraries → compiles them to kernel
        → sends them to the Dart VM on the device → VM swaps in new code
        → Flutter calls reassemble() → every build() runs again
```

Key point: **only `build()` methods re-run.** Code that already ran is not re-run.

### 1.4 When hot reload does NOT show your change

| You changed… | Why reload misses it | Do this |
|---|---|---|
| Code in `main()` or before `runApp()` | `main()` already ran | Hot restart |
| `initState()` | State already initialised; it won't run again | Hot restart |
| A global / `static` field initialiser | Already initialised; the old value is kept | Hot restart |
| `StatelessWidget` ↔ `StatefulWidget` | Widget type of existing elements changed | Hot restart |
| An `enum` ↔ regular class | Type shape changed | Hot restart |
| Generic type declarations (e.g. `class Box<T>`) | Not supported | Hot restart |
| Native code (`android/`, `ios/`), `pubspec.yaml`, a new plugin | Not Dart; needs a new build | Stop and `flutter run` again |
| There's a compile error | Reload is rejected; old code keeps running | Fix the error, reload again |

**Rule of thumb:** if the change "didn't show up", try `R`. If `R` doesn't work either, stop and run again.

### 1.5 Example: why `initState` changes don't reload

```dart
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _counter = 10; // add this, then hot reload → counter does NOT become 10
  }
}
```

`initState` only runs when the `State` is created. Hot reload keeps the existing `State`, so the new line never executes. Hot restart creates a fresh `State`, and the counter starts at `10`.

Same idea for field initialisers: changing `int _counter = 0;` to `int _counter = 100;` does nothing on hot reload, because the field already has its value.

---

## Part 2 — Hot restart (`R`)

### 2.1 What it does

Hot restart throws away **all Dart state** and re-runs your app from `main()`. It still reuses the already-installed native app and the running Flutter engine, so there is **no native rebuild**.

```text
hot reload   = swap code, keep state, re-run build()
hot restart  = swap code, reset Dart state, re-run main()
full restart = rebuild native app, reinstall, launch fresh process
```

### 2.2 What is lost on hot restart

- Every widget's `State` (counter goes back to `0`)
- Navigation stack (you're back on the first screen)
- In-memory globals, singletons, caches, `Provider`/`Bloc` state

What is **not** lost: anything saved to disk (SharedPreferences, databases, files), and native-side state (the native Activity / ViewController keeps running).

### 2.3 When you need a full stop and `flutter run`

- Edited anything in `android/` or `ios/` (manifest, Gradle, `Info.plist`, Kotlin/Swift)
- Added, removed or upgraded a **plugin** in `pubspec.yaml`
- Changed app icon, splash, app name or bundle id
- Changed Flutter SDK version
- Strange state that no reload fixes → `flutter clean && flutter pub get && flutter run`

### 2.4 Keyboard shortcuts (terminal `flutter run`)

| Key | Action |
|---|---|
| `r` | Hot reload |
| `R` | Hot restart |
| `q` | Quit |
| `d` | Detach (leave app running, stop the tool) |
| `p` | Toggle debug paint (layout guidelines) |
| `o` | Toggle platform (Android ↔ iOS look) |
| `w` | Dump widget tree to console |
| `v` | Open DevTools |
| `h` | Show all commands |

---

## Part 3 — Why hot reload exists: JIT vs AOT

Dart can compile in two ways:

| | **JIT** (Just-In-Time) | **AOT** (Ahead-Of-Time) |
|---|---|---|
| When it compiles | While the app runs | Before the app ships |
| Can swap code live? | **Yes** → hot reload | No |
| Startup and runtime speed | Slower | Fast |
| App size | Larger | Smaller |
| Used in | **Debug** mode | **Profile** and **Release** modes |

This is why **hot reload only works in debug mode.** Profile and release builds are compiled to native machine code and can't be patched at runtime.

---

## Part 4 — Build modes

### 4.1 Debug (default)

```bash
flutter run
```

- JIT compiled, hot reload and hot restart work
- `assert()` statements run
- Debug banner in the top-right corner
- Service extensions on (DevTools, widget inspector)
- **Slow and janky by design.** Never judge performance in debug mode.
- Works on emulators, simulators and real devices

### 4.2 Profile

```bash
flutter run --profile
```

- AOT compiled, close to release speed
- Keeps just enough tooling for **DevTools performance** (timeline, frame chart, CPU profiler)
- No hot reload, asserts off
- **Real device only** (not supported on emulators/simulators; their performance isn't representative anyway)
- Use it to answer "is this screen janky?" or "why is scrolling slow?"

### 4.3 Release

```bash
flutter run --release        # run on a connected device
flutter build apk            # Android APK
flutter build appbundle      # Android App Bundle (Play Store)
flutter build ipa            # iOS (App Store / TestFlight)
```

- AOT compiled, fully optimised, tree-shaken, smallest size
- No debugging, no DevTools, no asserts, no debug banner
- This is what users get. **Test in release before shipping**: some bugs only appear here (see Part 6).

### 4.4 Side-by-side

| | Debug | Profile | Release |
|---|---|---|---|
| Compilation | JIT | AOT | AOT |
| Hot reload / restart | ✅ | ❌ | ❌ |
| `assert()` runs | ✅ | ❌ | ❌ |
| DevTools | Full | Performance tools | ❌ |
| Performance | Slow | ≈ Release | Fastest |
| App size | Large | Medium | Smallest |
| Emulator / simulator | ✅ | ❌ | ✅ (Android emulator) / ❌ iOS sim |
| Use for | Building features | Measuring performance | Shipping, final QA |

### 4.5 Checking the mode in code

```dart
import 'package:flutter/foundation.dart';

if (kDebugMode)   { /* only in debug */ }
if (kProfileMode) { /* only in profile */ }
if (kReleaseMode) { /* only in release */ }
```

Typical uses:

```dart
// Verbose logging only while developing
if (kDebugMode) debugPrint('API response: $body');

// Don't send crash reports from developer machines
if (kReleaseMode) FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
```

These are compile-time constants, so the code inside a false branch is **removed** from the release build.

`assert()` is similar: it only runs in debug.

```dart
assert(items.isNotEmpty, 'items must not be empty'); // ignored in release
```

---

## Part 5 — Daily workflow

```text
writing UI / logic           → debug + hot reload (r)
changed init / globals       → hot restart (R)
changed native / pubspec     → q, then flutter run
"is this slow?"              → flutter run --profile on a real device + DevTools
before a PR touching perf    → profile check
before release / QA build    → flutter run --release, smoke-test key flows
```

---

## Part 6 — Common mistakes

| Mistake | Fix |
|---|---|
| "Hot reload doesn't work" after editing `initState` / `main()` | Use hot restart (`R`) |
| Added a plugin, then pressed `r` → `MissingPluginException` | Stop and `flutter run` again (native rebuild) |
| Judging scroll / animation performance in debug | Use `--profile` on a real device |
| Relying on `assert()` for real validation | Asserts vanish in release; use real `if` checks / exceptions |
| Logic inside `assert(...)` with side effects | It won't run in release; move it out |
| Printing secrets / tokens with `print()` | Wrap logs in `if (kDebugMode)`; never log secrets |
| Release-only crash: reflection / JSON missing fields | Test in release; check obfuscation / ProGuard rules on Android |
| "Works on emulator, slow on phone" | Emulator isn't representative; profile on a real, low-end device |
| Hot reload silently ignored | Check the terminal: a compile error rejects the reload |

---

## Part 7 — Cheat sheet

| I want to… | Do |
|---|---|
| See a UI change and keep app state | `r` / save |
| Re-run `main()` / `initState` / reset state | `R` |
| Apply native, plugin or `pubspec.yaml` changes | `q` → `flutter run` |
| Fix weird build state | `flutter clean && flutter pub get && flutter run` |
| Measure performance | `flutter run --profile` (real device) + DevTools |
| Try what users will get | `flutter run --release` |
| Build for Play Store | `flutter build appbundle` |
| Build for App Store | `flutter build ipa` |
| Run code only while developing | `if (kDebugMode) { ... }` |

---

## Part 8 — Practice questions

1. You changed a `Text` widget's string. Reload or restart?
2. You added `_counter = 10;` in `initState` and hot reloaded. The counter didn't change. Why?
3. You added the `camera` plugin and pressed `R`. The app throws `MissingPluginException`. What now?
4. Why doesn't hot reload work in release mode?
5. Your list scrolls badly in debug. Is there a performance problem?
6. Which build mode would you use with DevTools to find a janky frame?
7. You put `assert(user != null)` to protect a screen. Is the release app protected?

**Answers**

1. Hot reload. Only `build()` needs to re-run.
2. `initState` only runs when the `State` is created; hot reload keeps the existing `State`. Use hot restart.
3. Stop the app and `flutter run` again. Plugins add native code that needs a full rebuild.
4. Release is AOT-compiled to machine code; there is no JIT VM to swap code into.
5. Not necessarily. Debug is slow by design. Check in profile mode on a real device.
6. Profile.
7. No. Asserts are removed in release. Use a real check (`if (user == null) ...`).
