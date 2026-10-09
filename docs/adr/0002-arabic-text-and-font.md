# ADR-0002: Arabic Text Edition, Typography, and Font

- Status: proposed
- Date: 2026-10-09
- Deciders: product owner (pending approval)

## Context

Arabic text must remain the visual focus with correct shaping, harakat, and RTL
behavior on Linux (`architecture.md` §7). Font redistribution rights must be
cleared before bundling.

## Options considered

1. Tanzil Uthmani v1.1 text + bundled SIL OFL font (Amiri, Scheherazade New, or
   Noto Naskh Arabic), `fontFamily` pinned for Quran text.
2. System/GNOME host fonts via fontconfig fallback.
3. QF Mushaf fonts/images (bundling allowed with Developer Console account +
   credit, but ties text rendering to QF terms).

## Decision

Option 1 is proposed. Option 2 is rejected (host font set varies; Flatpak
sandbox does not guarantee it; fallback chains can silently swap glyph shapes).
Option 3 is deferred (revisit only if QF content path is ever licensed).

## Consequences

- Required before Phase 2: rendering spike on Linux + inside Flatpak with
  Al-Fatihah and heavily-voweled verses, comparing candidate fonts against a
  reference mushaf; checks for mark clipping, line height, and RTL/LTR mixing.
- Ship the chosen OFL `.ttf` in `assets/fonts/` with `OFL.txt` and register via
  `LicenseRegistry`; never rely on `google_fonts` runtime fetch for the
  offline MVP (it needs network permission).
- Never normalize or rewrite text to fix display without a documented policy.

## Evidence

- Tanzil Uthmani notes: <https://tanzil.net/docs/uthmani>
- Amiri (OFL-1.1): <https://github.com/aliftype/amiri>
- Scheherazade New (OFL-1.1): <https://software.sil.org/scheherazade/>
- Flutter internationalization/RTL: <https://docs.flutter.dev/ui/internationalization>

## Update 2026-10-09 (font decided)

Amiri (SIL OFL 1.1) selected per the spike verdict
(`spikes/arabic-rendering/REPORT.md`) and bundled at
`assets/fonts/Amiri-Regular.ttf` with `OFL-Amiri.txt`, registered via
`LicenseRegistry`, applied to verse text and Arabic names only.
