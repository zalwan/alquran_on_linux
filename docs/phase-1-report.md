# Phase 1 Report — Linux Technical Foundation

- Date: 2026-10-09
- Scope: app shell, theme foundation, persistence abstraction, packaging
  authoring. No Quran content bundled, displayed, or stored.

## What was built

- App shell: `MaterialApp.router` + `go_router` (`/`, `/bookmarks`,
  `/settings`) with a GNOME-first `NavigationRail` shell
  (`lib/app/router.dart`, `lib/app/app.dart`).
- Theme foundation per `docs/theme.md`: `lib/app/theme/` (`app_colors.dart`,
  `app_typography.dart`, `app_theme.dart`). Demo purple seed removed; separate
  hand-built light/dark `ColorScheme`s. A test asserts no purple remains.
- Preferences: `PreferencesRepository` contract + `SharedPreferences`
  implementation + Riverpod settings (theme mode System/Light/Dark, Arabic size
  20–40sp with clamping and corrupt-value fallback). Persisted across restarts
  by design; covered by unit tests.
- Database skeleton: Drift `AppDatabase`, `schemaVersion` 1, in-memory
  open/query test. Content and user-state tables arrive in Phase 2.
- CI: `.github/workflows/ci.yaml` (format, analyze, test, Linux release build).
- Packaging: `packaging/flatpak/` — manifest (GNOME 51, Flutter 3.47.7 pinned
  with verified sha256, minimal finish-args), launcher, desktop entry,
  metainfo, icon, README. App ID `org.alquran.Reader`, also set as
  `APPLICATION_ID` in `linux/CMakeLists.txt`.

## Verification (local, 2026-10-09)

- `dart format`: clean. `flutter analyze`: 1 warning, only in drift-generated
  code (`unused_field` until Phase 2 tables land).
- `flutter test`: 11/11 pass (settings, theme tokens, database, app smoke in
  both flows).
- `flutter build linux --release`: succeeds (Flutter 3.44.4, system GTK 3.24).
- Release binary launches on the Linux desktop with no errors (benign
  ATK/cursor-theme warnings only).
- Manifest YAML parses; metainfo is well-formed XML; launcher syntax checked.

## Locked dependency versions (pubspec.lock)

go_router 18.x, flutter_riverpod/riverpod 3.x, drift 2.x, sqlite3 3.5.2,
shared_preferences 2.x, path_provider 2.x, drift_dev + build_runner (dev).
Full matrix and rationale: ADR-0005.

## Explicitly deferred (still open)

- Flatpak sandboxed build/install/launch: attempted 2026-10-09 (GNOME Sdk 51,
  Builder 1.4.9, manifest fixed up to `flutter pub get`), but `flutter pub`
  dies silently inside this machine's nested sandbox — reproduced 4× including
  `--offline`, while the pinned SDK 3.47.7 resolves the lockfile cleanly on
  the host. Environmental limitation, not a manifest defect; full sandbox
  proof, lint, and AppStream validation must run in CI / on an unrestricted
  machine before the Phase 1 exit is signed off. Detail:
  `packaging/flatpak/README.md`.
- Flathub offline-source regeneration (`flutpak`/`flatpak-flutter`), lint, and
  AppStream validation — documented in `packaging/flatpak/README.md`.
- Rendering spike for Uthmani shaping (R3) and drift-hook sandbox proof (R5).
- Reference-device performance baselines (method defined in phase-0-report §7).
- Phase 2 content work remains blocked until the Phase 0 translation clearance
  (QuranEnc key/version/checksum) is resolved.

## Confirmation

No Quran text, translation, or font is bundled or displayed. Placeholder
screens contain no verses by design.
