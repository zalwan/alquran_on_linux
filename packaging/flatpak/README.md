# Flatpak packaging

Phase 1 minimal package. App ID: `org.alquran.Reader` (matches
`APPLICATION_ID` in `linux/CMakeLists.txt`).

## Files

| File | Purpose |
| --- | --- |
| `org.alquran.Reader.yml` | Build manifest (GNOME 51 SDK, Flutter 3.47.7, minimal finish-args) |
| `alquran.sh` | Launcher for manifest `command: alquran` |
| `org.alquran.Reader.desktop` | Desktop entry |
| `org.alquran.Reader.metainfo.xml` | AppStream metadata (homepage URL is a placeholder) |
| `icons/.../org.alquran.Reader.svg` | Placeholder icon in theme greens |

## Local build (requires GNOME Sdk 51 + flatpak-builder)

```sh
flatpak-builder --force-clean build-dir packaging/flatpak/org.alquran.Reader.yml
flatpak-builder --run build-dir packaging/flatpak/org.alquran.Reader.yml alquran
```

Note: in restricted/nested containers, add `--disable-rofiles-fuse` if FUSE
mounts are denied, and `--disable-cache` if the ostree cache lives on another
filesystem (`renameat ... Invalid cross-device link`).

## Validation log (2026-10-09, dev machine)

- GNOME Platform/Sdk 51 + `org.flatpak.Builder` (1.4.9) installed from Flathub.
- Manifest iterated to a working state: Flutter 3.47.7 SDK downloads,
  sha256-verifies, and extracts; `flutter --version` and `flutter config`
  run inside the sandbox. Fixed along the way: archive sources arrive
  pre-extracted (`strip-components: 0` + copy), and each build-command runs
  in its own shell (absolute `/app/flutter/bin/flutter` paths).
- `flutter pub get` (and `--offline`) dies silently inside the nested
  sandbox here — reproduced 4× with zero output and no error, while the same
  SDK resolves the same lockfile cleanly on the host. Conclusion: environment
  limitation (nested bubblewrap), not a manifest defect.
- Remaining proof (compile + install + launch in sandbox, drift/sqlite3 hook
  check, `--sandbox` offline run, lint, AppStream validation) must run on an
  unrestricted machine or in CI before the Phase 1 exit is signed off.

## Before any release or Flathub submission

1. Regenerate offline module sources with `flutpak` or `flatpak-flutter`
   (vendored Flutter SDK + pub cache). The current manifest runs
   `flutter pub get` at build time, which Flathub forbids.
2. Re-pin `runtime-version` and the Flutter SDK archive + sha256.
3. Run `flatpak-builder --sandbox`, `flatpak-builder-lint`, and
   `appstreamcli validate`.
4. Replace the metainfo homepage URL and confirm `project_license` once
   ADR-0007 is approved.
5. Confirm no Quran content is bundled (Phase 1 ships none).

## Permissions

`finish-args` grants display + rendering only (`ipc`, Wayland with X11
fallback, `dri`). No network, filesystem, sound, or printing access —
see ADR-0006. Each future addition must be justified here.
