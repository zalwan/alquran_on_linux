# Arabic Rendering Spike (R3)

Purpose: empirically validate Uthmani shaping, harakat, and RTL behavior in
Flutter on Linux before the Phase 2 reader — per `architecture.md` §7 and
ADR-0002. Follow-up: `REPORT.md` (verdict + goldens for human review).

## Text sample provenance (read carefully)

- Source: Tanzil Quran Text, Uthmani, v1.1 (Feb 2021), acquired 2026-10-09 via
  `https://tanzil.net/pub/download/index.php?quranType=uthmani&outType=txt-2`
  (full-file sha256 `6933e133…c5f`,lej. `docs/data-sources.md` §2.1).
- Retained here: **Surah Al-Fatihah only (7 verses)** in
  `samples/fatihah-uthmani.txt` (sha256
  `2b4ebd31d35971806ac30d72eca8dd992bc13fa330a86bbec9726c2638dc57ee`),
  extracted verbatim (`grep -E "^1\|"`) — no character changed, added, or
  removed. The full download was shredded immediately after extraction.
- Terms compliance: Tanzil permits verbatim copies in applications with source
  indication + link to tanzil.net (see `docs/data-sources.md`). This sample is
  an **evaluation fixture only — it is NOT wired into the app, NOT listed in
  `pubspec.yaml` assets, and MUST NOT ship in any release package**. The
  Phase 2 content pipeline re-acquires and re-validates approved editions
  from scratch.

## Fonts

| File | Source | License |
| --- | --- | --- |
| `Amiri-Regular.ttf` | google/fonts `ofl/amiri` (Amiri Project) | SIL OFL 1.1 (`OFL-Amiri.txt`) |
| `ScheherazadeNew-Regular.ttf` | google/fonts `ofl/scheherazadenew` (SIL Global) | SIL OFL 1.1 (`OFL-ScheherazadeNew.txt`) |
| `NotoNaskhArabic[wght].ttf` | google/fonts `ofl/notonaskharabic` (Noto Authors) | SIL OFL 1.1 (`OFL-NotoNaskhArabic.txt`) |

Fonts here are spike fixtures, not app assets. The Phase 2 font choice still
requires the ADR-0002 spike verdict plus license audit.

## Running

```sh
flutter test test/arabic_rendering_spike_test.dart
```

Regenerating reference images (only after reviewing diffs):

```sh
flutter test --update-goldens test/arabic_rendering_spike_test.dart
```
