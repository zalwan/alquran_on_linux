# Arabic Rendering Spike — Report (R3)

- Date: 2026-10-09
- Input: Tanzil Uthmani v1.1 Al-Fatihah sample (7 verses, verbatim — see
  `README.md` for provenance) + 3 SIL OFL candidate fonts
- Method: `test/arabic_rendering_spike_test.dart` — layout at 20/28/40sp with
  overflow assertions + golden screenshots at 28sp, human-reviewed below
- Engine: Flutter 3.44.4 Linux (tester rasterizer; on-device Flatpak check
  still pending — see §4)

## 1. Verdict: PASS for all three fonts

| Check | Amiri | Scheherazade New | Noto Naskh Arabic |
| --- | --- | --- | --- |
| Letter joining/shaping | correct | correct | correct |
| Harakat + shadda + maddah placement | correct | correct | correct |
| Superscript alef + tatweel (e.g. ٱلرَّحْمَـٰنِ) | correct | correct | correct |
| Verse-end marker ۝ + digits ١–٧ | ornate medallion | hexagonal ornament | rounded medallion |
| RTL alignment, marker at verse end (left) | correct | correct | correct |
| LTR header row alongside RTL verses | correct | correct | correct |
| No tofu / missing glyphs | none | none | none |
| No overflow at 20/28/40sp (`height` 2.0) | pass | pass | pass |
| Verse 7 two-line wrap with marker at end | correct | correct | correct |

Goldens: `test/goldens/arabic_{amiri,scheherazade,noto}.png` (800×1400 @1x).

## 2. Qualitative notes (non-binding for the font decision)

- Amiri: most classical naskh feel, prettiest ۝ medallion; matches a Madani
  aesthetic closest of the three.
- Scheherazade New: simplest strokes, slightly narrower; ornaments are plainer.
- Noto Naskh Arabic (variable wght): clean and neutral; default instance used.
- All three ship Latin glyphs, so mixed labels need no font fallback.

## 3. What this does NOT prove

- Only Al-Fatihah was tested. Densely marked passages (e.g. long Madani verses
  with waqf signs ۝ ۩) and sajdah/rub markers still need a glance in Phase 2
  with the approved full text — the automated overflow assertions cover sizes,
  not every mark combination.
- Tester rasterizer ≠ Impeller on-device output. A visual check inside the
  Flatpak sandbox remains (packages a font + sample page temporarily, never
  shipped).
- This is structural/rendering validation, not scholarly verification
  (`docs/data-sources.md` §3.2 still applies).

## 4. Follow-ups for Phase 2

1. Pick the font (recommendation: Amiri, pending taste confirmation) and bundle
   it per ADR-0002 (OFL.txt + `LicenseRegistry`).
2. Re-run this spike test against the approved full-text pipeline (offline,
   checksummed) and extend goldens with one long verse.
3. Repeat the visual check in the Flatpak sandbox on first packaging run.

## 5. Terms compliance note

Sample handling is documented in `README.md`: 7 verses retained verbatim with
attribution, full download shredded, fixture excluded from app assets and all
release packages. No Phase 2 content decision is pre-empted by this spike.
