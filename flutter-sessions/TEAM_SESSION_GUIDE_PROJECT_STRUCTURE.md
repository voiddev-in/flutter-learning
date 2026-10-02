# Team Session Guide — Flutter Project Structure

How to run a team session on `lib/`, `android/`, `ios/`, `assets/` and dependencies.
Companion to [FLUTTER_PROJECT_STRUCTURE.md](FLUTTER_PROJECT_STRUCTURE.md) (the learning reference — read it first).
For the Dart-keywords session, see [TEAM_SESSION_GUIDE.md](TEAM_SESSION_GUIDE.md).

- **Duration:** 45 minutes (25 teach, 15 live walkthrough, 5 wrap-up/Q&A)
- **Audience:** Flutter developers of mixed experience, including newer joiners
- **Tools:** the repo open in an editor (`app2/`), a terminal, and the file tree visible on screen
- **Goal:** everyone can answer "where do I make this change?" for any task, without hunting

---

## Timeline

| Time | Block | What you do |
|---|---|---|
| 0:00–0:05 | Opening | Hook + the one-picture overview |
| 0:05–0:13 | `lib/` | Layers and our folder layout |
| 0:13–0:20 | `android/` and `ios/` | Native shells, permissions |
| 0:20–0:27 | `assets/` | The two-step rule |
| 0:27–0:33 | Dependencies | `pubspec.yaml`, lock, commands |
| 0:33–0:40 | Live walkthrough | "Add a camera feature" end to end |
| 0:40–0:45 | Wrap-up | Recap, quiz, commitments, Q&A |

---

## 1. How to START the session

### Opening script

> "Hi everyone. Today is about the map of a Flutter project. When you open our app you see `lib`, `android`, `ios`, `assets`, and a `pubspec.yaml`. Most of us know where our own screens live, but a lot of build problems and store rejections come from not knowing which file to change.
>
> By the end of this session, for any task, such as 'add a permission', 'add an image', 'add a library', or 'change the app icon', you'll know exactly which file to open and what else needs to change with it."

### Hook question (1 minute)

> "You add `assets/logo.png` and the app says *Unable to load asset*. What did you forget?"

Let two or three people answer. The answer (the `pubspec.yaml` entry) is the reason for the asset section later.

### The one-picture frame (2 minutes)

Draw or show:

```text
lib/        = our Dart code
android/    = Android container
ios/        = iOS container
assets/     = files shipped inside the app
pubspec.yaml = the manifest tying it together
```

> "Flutter draws its own screens. `android/` and `ios/` are just the native containers that launch Flutter. Keep that in mind and the rest follows."

### Housekeeping

- "Open `app2/` in your editor to follow along."
- "Questions anytime; long ones go to the end."

---

## 2. What to SAY in each part

### `lib/` (8 min)

- Say: "Everything we write day to day is in `lib/`. The entry is `main.dart`."
- Show our real folders in `app2/lib/`: `screens/`, `widgets/`, `models/`, `service/`, `theme/`, `l10n/`.
- Say the three-layer line: "Screens show, services fetch, models describe data. Don't mix them."
- Show how `screens/feed/` grew into its own folder with `widgets/` inside. Point out: "When a screen gets big, make a folder."
- Show one import: `package:ecm/...` and explain `ecm` comes from `pubspec.yaml`.
- Ask: "Where would a new API call go?" (`service/`.) "Where would a reusable button go?" (`widgets/`.)

### `android/` and `ios/` (7 min)

- Say: "We rarely touch these, but when we do it's for the same short list of reasons: **permissions, app id and version, icons and splash, deep links, signing, push.**"
- Show `AndroidManifest.xml` and point at a permission and the deep-link filter we recently added.
- Show `ios/Runner/Info.plist` and a usage-description key.
- Key line: **"iOS requires a written reason for every permission. No reason, the app crashes or is rejected."**
- Show `ios/Runner.xcworkspace` and say: "Open the workspace, not the project."
- Warn: "Keystores and signing keys are secrets. They never go in chat, tickets or commits."

### `assets/` (7 min)

- Say the rule slowly: **"Two steps, always. Put the file in. Declare it in `pubspec.yaml`."**
- Show the `flutter: assets:` block in `app2/pubspec.yaml`.
- Demo the failure live: reference an undeclared image, show the error, add the entry, restart, show it work.
- Mention: folders aren't recursive; hot reload won't pick up new assets; compress images.
- Security point (important): "Everything in assets can be unzipped by anyone. Our `pubspec.yaml` lists `.env` as an asset. Let's check together that it holds nothing secret." Do this **as a team action item**, not by opening the file on screen.

### Dependencies (6 min)

- Say: "`pubspec.yaml` is the shopping list, `pubspec.lock` is the receipt. The receipt guarantees we all build the same versions, so it's committed."
- Explain `^5.8.0` in one sentence: "5.8 or newer, but never 6."
- Run the commands and say what each does: `flutter pub get`, `pub add`, `pub outdated`, `flutter clean`.
- Point at the Firebase block and its "upgrade together" comment: "These move as a set."
- Explain package vs plugin: "A plugin has native code, so adding one can mean editing `android/` and `ios/`."
- Mention how to pick a package: verified publisher, recent updates, platform support, license.

### Live walkthrough (7 min): "Add a camera feature"

Narrate each step and say which folder you're in:

1. `pubspec.yaml`: add the package, `flutter pub get`.
2. `AndroidManifest.xml`: permission.
3. `Info.plist`: usage description.
4. `lib/service/`: wrapper.
5. `lib/screens/`: UI.
6. `assets/`: an icon, plus its `pubspec.yaml` entry.
7. Run on a real device.

> Tip: do this on a throwaway branch, or just walk through the files without committing. Prepare it beforehand so nothing surprising happens live. Don't run analyzer or lint passes during the demo.

---

## 3. How to END the session

### Recap (2 min), say this

> "Let's close with a quick map. **Code goes in `lib/`. Platform settings and permissions go in `android/` and `ios/`. Files we ship go in `assets/`, and they must be declared. Libraries go in `pubspec.yaml`.** And remember: adding a plugin often means touching both native folders too."

### Quick quiz (2 min)

1. "Where does an iOS camera permission reason go?" (`Info.plist`.)
2. "Why do we commit `pubspec.lock`?" (Same versions for everyone.)
3. "You changed the assets list. Hot reload or restart?" (Restart.)

### Commitments (30 seconds)

- Every new asset gets its `pubspec.yaml` entry in the same PR.
- Every new plugin PR lists the native changes it needs (Android and iOS).
- No secrets in `assets/`, and no keystores in the repo or chat.
- Upgrade Firebase packages as one set.

### Action items to assign

- One person verifies what the bundled `.env` contains and whether it should ship in the app.
- Everyone: find one folder or asset in the repo you didn't know the purpose of and share it in chat.

### Closing script

> "Thanks everyone. If you remember one thing: **ask 'which folder owns this?' before you start editing.** The reference doc is in `docs/flutter-learning/`. Post any questions in the team chat. Next session we can cover [state management with `provider` / API layer with `dio` / Firebase setup]."

---

## 4. Likely questions and short answers

| Question | Answer |
|---|---|
| "Do I ever edit `MainActivity` or `AppDelegate`?" | Rarely. Mostly plugins handle it. Only for advanced native hooks. |
| "Why did my new image not show?" | Not declared in `pubspec.yaml`, or you only hot-reloaded. Declare it and restart. |
| "What's the `+38` in the version?" | Build number. Stores need it to increase on every upload. `1.1.38` is the user-visible version. |
| "`flutter clean` fixed it. Why?" | It deletes stale build output and caches. Run `pub get` again afterwards. |
| "Can I put code outside `lib/`?" | Tests go in `test/`. App code belongs in `lib/`. |
| "Package or plugin?" | Package is pure Dart. Plugin has native code and may need `android/` and `ios/` setup. |
| "Why is the lock file committed?" | For apps, it makes builds reproducible across the team and CI. |
| "Why did iOS reject us for a permission?" | Missing or vague usage description in `Info.plist`. |

---

## 5. Facilitator checklist

**Before**
- [ ] Re-read the learning guide
- [ ] Open `app2/` and pick real examples: a permission in `AndroidManifest.xml`, a key in `Info.plist`, the `assets:` block, the Firebase block
- [ ] Rehearse the undeclared-asset demo and the camera walkthrough on a throwaway branch
- [ ] Don't open any `.env`, keystore, or `google-services` file on screen; point at paths only

**During**
- [ ] State the outcome at the start
- [ ] Always say which folder you're in while demoing
- [ ] Ask "where would this go?" after each section
- [ ] Watch the clock; park long questions

**After**
- [ ] Share the learning guide link
- [ ] Post the commitments and action items in chat
- [ ] Answer parked questions within a day

---

## 6. Slide outline (optional)

1. Title: "Anatomy of a Flutter Project"
2. Why this matters (the "Unable to load asset" story)
3. The one-picture map
4. `lib/`: layers and our folders
5. `android/`: what's inside and when you touch it
6. `ios/`: same, plus the permission-reason rule
7. `assets/`: the two-step rule
8. Assets gotchas (and the security warning)
9. `pubspec.yaml` anatomy
10. Version syntax (`^`)
11. `pubspec.lock` and the commands
12. Package vs plugin
13. Walkthrough: add a camera feature
14. "Where does it go?" cheat sheet
15. Commitments and action items
16. Quiz + Q&A
