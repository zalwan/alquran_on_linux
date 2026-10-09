# ADR-0004: Local Persistence Strategy

- Status: proposed
- Date: 2026-10-09
- Deciders: product owner (pending approval)

## Context

Local structured data (immutable/versioned Quran content vs. mutable user state:
bookmarks, last-read, preferences) with tested migrations
(`architecture.md` §6). Must work inside the Flatpak sandbox with no extra
filesystem permissions.

## Options considered

1. Drift (on `sqlite3` 3.x, bundled SQLite via build hooks) for content + user
   state, plus `shared_preferences` (new async API) for simple preferences and
   `path_provider` for database paths.
2. `sqflite_common_ffi` + `sqlite3` (sqflite-compatible API).
3. Raw `sqlite3` package without an ORM layer.
4. JSON files only, no database.

## Decision

Option 1 is proposed. Drift is actively maintained (2.35.2, Oct 2026, MIT),
badged Linux + Android, and since 2.32/`sqlite3` 3.x needs no
`sqlite3_flutter_libs` or system `libsqlite3`. Option 2 stays a fallback if the
team prefers the sqflite API. Options 3–4 are rejected (migration/type-safety
and query cost for 6,236+ verses plus translations).

## Consequences

- Separate versioned content tables from user-state tables; atomic/recoverable
  content installs; migration tests including failure-without-corruption.
- Store under app-specific XDG locations (`path_provider`), which map to
  `~/.var/app/<id>/` in Flatpak — no `--filesystem` permission needed.
- Must smoke-test drift/`sqlite3` build hooks under `flatpak-builder --sandbox`
  (offline build) before locking the choice in Phase 1.

## Evidence

- Drift: <https://pub.dev/packages/drift>, VM platform notes: <https://drift.simonbinder.eu/platforms/vm/>
- sqlite3: <https://pub.dev/packages/sqlite3>
- shared_preferences: <https://pub.dev/packages/shared_preferences>
- path_provider: <https://pub.dev/packages/path_provider>
- Flatpak sandbox paths: <https://docs.flatpak.org/en/latest/sandbox-permissions.html>
