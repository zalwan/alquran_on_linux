# ADR-0006: Flatpak Runtime and Build Strategy

- Status: proposed
- Date: 2026-10-09
- Deciders: product owner (pending approval)

## Context

First release is a Linux Flatpak, GNOME-first, offline-first, minimal permissions
(`architecture.md` §9). Flathub builds offline (`flatpak-builder --sandbox`),
so Flutter pub cache + SDK must be vendored as manifest sources.

## Options considered

1. `org.gnome.Platform`/`org.gnome.Sdk` runtime, flutter build via
   `flatpak-flutter` or `flutpak` generated manifests, minimal finish-args.
2. `org.freedesktop.Platform` base runtime with the same tooling.
3. Direct `flutter build linux` artifact distributed outside Flatpak.

## Decision

Option 1 is proposed (GNOME-first per product direction); option 2 is an
acceptable fallback. Option 3 does not satisfy the distribution requirement.

## Consequences

- Proposed finish-args: `--share=ipc`, `--socket=fallback-x11`,
  `--socket=wayland`, `--device=dri`. Omit `--share=network` (offline reader),
  home/host filesystem access, and sound/printing sockets until a feature
  requires them (use portals instead of blanket access where possible).
- App data lives in sandbox XDG dirs (`~/.var/app/<id>/`); no extra
  `--filesystem` args for normal operation.
- Confirm the exact runtime branch at manifest-authoring time; verify the
  offline `--sandbox` builder smoke test (including drift/sqlite3 hooks) before
  the Phase 1 exit. Flathub submission needs manifest + metainfo + desktop file
  + icons and must pass lint/AppStream validation.

## Evidence

- Sandbox permissions: <https://docs.flatpak.org/en/latest/sandbox-permissions.html>
- Runtimes: <https://docs.flatpak.org/en/latest/available-runtimes.html>
- flatpak-flutter: <https://github.com/TheAppgineer/flatpak-flutter>
- flutpak: <https://github.com/o-murphy/flutpak> (<https://pub.dev/packages/flutpak>)
- Flutter Linux building: <https://docs.flutter.dev/platform-integration/linux/building>
- Local Flutter/Flatpak present in dev env: Flutter 3.44.4, Flatpak 1.18.0
