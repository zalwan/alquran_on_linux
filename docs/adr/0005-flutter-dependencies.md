# ADR-0005: State Management, Routing, and Flutter Dependencies

- Status: proposed
- Date: 2026-10-09
- Deciders: product owner (pending approval)

## Context

Every critical plugin must have verified Linux support before adoption
(`architecture.md`, Phase 0 gate). Matrix checked 2026-10-09 on pub.dev.

## Dependency compatibility matrix

| Package | Verdict | Version / activity | License | Linux | Android | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| go_router | proposed | 18.0.2, ~2026-09-29, flutter.dev, Favorite | BSD-3 | yes | yes | Pure Dart, no native deps |
| riverpod (+ flutter_riverpod) | proposed | 3.4.3, ~2026-09-04, Favorite | MIT | yes | yes | Pure Dart; pick ONE of riverpod/bloc |
| bloc + flutter_bloc | alternative | 9.2.1 / 9.1.1, MIT | MIT | yes | yes | Pure Dart; acceptable if team prefers |
| drift | proposed | 2.35.2, ~2026-10-07 | MIT | yes | yes | Needs sandbox-build smoke test (see ADR-0004) |
| sqlite3 (via drift) | proposed (transitive) | 3.7.0, ~2026-10-01 | MIT | yes | yes | Bundled SQLite via hooks, no system lib needed |
| sqflite_common_ffi | fallback only | 2.4.3, ~2026-09-11 | BSD-2 | yes | yes | Only if sqflite API is required |
| shared_preferences | proposed | 2.5.6, ~2026-10-06, flutter.dev | BSD-3 | yes | yes | Use new `SharedPreferencesAsync`/`WithCache` APIs |
| path_provider | proposed | 2.1.6, ~2026-07, flutter.dev | BSD-3 | yes | yes | No native build config |
| url_launcher | proposed (optional) | 6.3.3, ~2026-10-03, flutter.dev | BSD-3 | yes | yes | Only if "open source link" ships; test under sandbox |
| audioplayers | deferred | 6.8.1, ~2026-07 | MIT | yes | yes | Do NOT add in Phase 0/1; needs pulseaudio + likely network |
| google_fonts | dev-convenience only | 9.0.0, flutter.dev | BSD-3 (fonts OFL) | yes | yes | Do NOT runtime-fetch in offline MVP; bundle fonts instead |

## Decision

Proposed stack: `go_router` + `riverpod` + `drift`/`sqlite3` + `shared_preferences`
+ `path_provider`. `url_launcher` only if a link-opening feature ships. Audio and
runtime font fetching are explicitly excluded until their milestones.

## Consequences

- No runtime dependency may be added in Phase 0. Phase 1 locks versions and
  records the final matrix with a sandbox-build smoke test.
- Keep domain logic free of widget/plugin imports per `architecture.md`.

## Evidence

- All package pages: <https://pub.dev/packages/<name>> for each row above.
- Flutter Linux setup: <https://docs.flutter.dev/platform-integration/linux/setup>
- Supported platforms: <https://docs.flutter.dev/reference/supported-platforms>
