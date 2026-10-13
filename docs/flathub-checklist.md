# Flathub Submission Checklist

Target: public v1.0 (Arabic-only). Status as of 2026-10-13 — nothing below
is claimed done without evidence.

## Manifest & build

- [ ] `flutpak generate` (or flatpak-flutter) offline sources replace the
      build-time `flutter pub get` (Flathub forbids network at build time).
- [ ] `flatpak-builder --sandbox` full build green (sandbox proof; blocked
      locally by nested-sandbox limits, queued for CI).
- [ ] `flatpak-builder-lint` clean on the manifest.
- [ ] Re-pin `runtime-version` + Flutter SDK archive/sha256 at release time.

## Metadata (repo files, all present in draft form)

- [ ] Metainfo homepage URL: still `https://example.invalid/alquran` —
      **needs the real project URL from the owner**.
- [x] App ID `org.alquran.Reader` consistent (manifest, metainfo, desktop,
      `linux/CMakeLists.txt`).
- [x] Minimal finish-args (display + rendering only, no network/filesystem).
- [ ] 256×256 PNG icon (only SVG exists — Flathub minimum).
- [ ] `appstreamcli validate` clean on the metainfo.
- [ ] Screenshots of index/reader/settings in both themes.

## Content & legal (release gates, not packaging details)

- [ ] Project `LICENSE` file (MIT proposed in ADR-0007 — **needs owner
      approval** with holder name/year).
- [ ] Verify the Flatpak `/app` payload contains: Tanzil text + metadata +
      `ATTRIBUTION.md` + `manifest.json` + `OFL-Amiri.txt` (license audit
      §below), and NO translation files, NO spike fixtures, NO test fakes.
- [ ] Validation report signed for the exact shipped dataset
      (`docs/validation-reports/`).
- [ ] Release notes + known limitations published (README mirrors them).

## License audit (v1.0 payload, verified 2026-10-13)

| Item | License | Evidence |
| --- | --- | --- |
| App code | MIT (proposed, pending file) | ADR-0007 |
| Arabic text + metadata | CC-BY 3.0 + verbatim terms | `data/manifest/ATTRIBUTION.md`, in-app credits |
| Amiri font | SIL OFL 1.1 | `assets/fonts/OFL-Amiri.txt` + `LicenseRegistry` |
| Dart/Flutter deps | MIT/BSD (see lockfile) | `pubspec.lock`, ADR-0005 |
| Spike fixtures/fonts | never shipped | excluded from `assets:`, not referenced by code |
