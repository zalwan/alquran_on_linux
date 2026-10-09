# Content Validation Report — Tanzil Uthmani v1.1 (Arabic-only v1.0)

- Date: 2026-10-09
- Reviewer: automated suite (`test/unit/tanzil_seed_test.dart`) + human review
  of this report
- Scope: structural validation of the EXACT committed files. This is NOT a
  scholarly or editorial review — no claim of religious verification is made
  (`docs/data-sources.md` §3.2).

## Files under validation

| File | SHA-256 | Result |
| --- | --- | --- |
| `data/manifest/tanzil-uthmani-v1.1.txt` (1,396,087 bytes) | `6933e133…c5f` | matches download; identical hash to the independent Phase-1 spike fetch |
| `data/manifest/quran-data-v1.0.xml` (77,234 bytes) | `8867c1d8…5c7a` | matches download |
| `data/manifest/manifest.json` | — | parses; required keys present; translation trio all-null (Arabic-only) |

Acquisition: Tanzil download endpoint (`quranType=uthmani&outType=txt-2`,
marks/sajdah/tatweel on) and `quran-data.xml` v1.0, 2026-10-09. Terms:
verbatim copies with attribution + link (see `data/manifest/ATTRIBUTION.md`).

## Checks performed (all automated, all passing)

1. Hash check: committed bytes hash to the recorded manifest values.
2. Format: 6,266 file lines = 6,236 `sura|aya|text` verse lines + 28 `#`
   copyright header lines + 2 blanks. Zero malformed lines, zero empty
   verses, zero duplicate keys. Parser rejects corrupt input loudly
   (tested).
3. Completeness: surahs 1–114 gapless; per-surah verse counts from the text
   match the metadata `ayas` values with zero mismatches.
4. Totals: 6,236 verses.
5. Translation mapping: N/A (Arabic-only dataset; validator enforces the
   empty-translation path and the seeder skips translation inserts).
6. Serving order: seeded to in-memory DB, every surah reads back ayahs
   1..N in order; spot checks 1:1 and 114:6 resolve with non-empty text.
7. Manifest roundtrip: `ContentManifest.fromJson` accepts the committed
   `manifest.json`; `hasTranslation` is false.

## Corrections / updates

Upstream tracking: <http://tanzil.net/updates/>. Any re-acquisition repeats
this report and bumps `manifest.json` + app seed (atomic reseed preserves
user tables).

## Sign-off

- Automated structural validation: PASS (2026-10-09, suite green).
- Owner approval to bundle (Arabic-only v1.0): granted 2026-10-09
  ("oke lanjutkan" — Tanzil grant verified since Phase 0, ADR-0001).
- Remaining: translation clearance still gates v1.1
  (`docs/translation-clearance.md`).
