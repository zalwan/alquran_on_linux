# Content Sources and Offline Rights

> Phase 0 discovery output. Status: research only — no dataset has been
> downloaded, bundled, or validated. All source checks dated 2026-10-09
> unless noted. This document informs ADR-0001, ADR-0002, and ADR-0003.

## 1. Decision summary

| Need | Recommended path | Status |
| --- | --- | --- |
| Arabic text + surah/ayah metadata | Tanzil Quran Text, Uthmani, v1.1 (Feb 2021), verbatim | Proposed — grant verified, integrity validation still required |
| Indonesian translation | QuranEnc Indonesian edition (exact key/version to confirm at acquisition) | Proposed — republication grant verified, edition identity still required |
| Quran Foundation API content | Do NOT bundle; runtime Content Sync only, needs network + 7-day sync | Blocked for MVP offline bundle under standard terms |
| KFGQPC-derived verse text | No public redistribution grant found | Blocked without written permission |
| Kemenag/LPMQ 2019 text direct | All Rights Reserved, no bundling grant found | Blocked without written permission |

## 2. Source comparison

### 2.1 Tanzil Project — Arabic text (primary candidate)

- Publisher: Tanzil Project. URLs: <https://tanzil.net/download/>,
  <https://tanzil.net/docs/text_license>, <https://tanzil.net/docs/uthmani>.
- Dataset: "Tanzil Quran Text", latest release v1.1, February 2021. Types include
  Uthmani ("a Unicode encoding of Medina Mushaf"). Formats: plain text (with or
  without aya numbers), XML, MySQL dump.
- License/terms: copyright notice "Copyright (C) 2007-2021 Tanzil Project,
  License: Creative Commons Attribution 3.0" plus Terms of Use. Key term (quote):
  "Permission is granted to copy and distribute verbatim copies of this text,
  but CHANGING IT IS NOT ALLOWED."
- Display in app: allowed ("used in any website or application") with source
  indicated and a link to tanzil.net.
- Offline storage / Flatpak bundling: permitted for verbatim copies, provided the
  copyright notice is included in all verbatim copies and reproduced in files
  derived from or containing a substantial portion of the text.
- Sync obligation: none with a fixed interval; project asks users to check
  <http://tanzil.net/updates/> and link back so users can track changes.
- Attribution: retain copyright notice + link to tanzil.net.
- Updates: mailing list + updates page + changelog.
- Uncertainty: the page names both CC-BY 3.0 and custom Terms of Use; treat the
  stricter custom conditions (verbatim, no-change, link) as controlling. Footer
  year (2007–2026) differs from license header (2007–2021); reproduce the header
  notice exactly as shipped with the acquired file and record which was used.

### 2.2 Quran Foundation API (api.quran.com)

- Publisher: Quran Foundation, Inc. URLs:
  <https://api-docs.quran.foundation/legal/developer-terms/> (last updated
  2026-10-04, verified 2026-10-09),
  <https://api-docs.quran.foundation/docs/tutorials/content-sync/getting-started/>.
- Dataset: API-returned "QF Content" (text, translations, metadata, audio).
- Key terms (quotes): "Cache or store QF Content longer than 1 week" is forbidden
  except via Content Sync or the fonts/images exception; "The Content Sync storage
  exception does not itself authorize distributing a prepackaged database or
  build-time bundle".
- Display in app: allowed for end-user display; Quran text "not modified in any
  way"; content "not sold, sublicensed, or redistributed, except as expressly
  permitted".
- Offline storage: only via Content Sync, with a next sync at least every 7 days
  when connectivity permits; previously synced copy may be used during outages.
- Flatpak bundling: NOT permitted under standard terms — a prepackaged database
  or build-time bundle requires a separate written commercial license
  (contact developers@quran.com).
- Fonts/Mushaf images exception: font files and Mushaf images from QF APIs/CDN
  may be cached or bundled with an active Developer Console account + QF credit,
  distributed only as an integrated part of the app.
- Consequence: QF content is blocked as the MVP offline data source. It remains a
  candidate only as (a) a runtime-synced source (conflicts with offline-first and
  minimal-permission goals — needs product decision), or (b) under a commercial
  license (not pursued in Phase 0).

### 2.3 KFGQPC / Madani mushaf transcription

- Rights holder: King Fahd Glorious Quran Printing Complex, Madinah.
  URLs: <https://qurancomplex.gov.sa/>, fonts at `fonts.qurancomplex.gov.sa`.
- Finding: no official open verse-array dataset found; official electronic
  distribution is publishing software, fonts, and PDFs/images. The only public
  grant found is the font EULA (use/copy/distribute the font; no sale,
  modification, or reverse engineering).
- Third-party mirrors (e.g. risan/quran-json) carry their own repo licenses, not
  rights from KFGQPC. Treat a KFGQPC-derived transcription as All Rights Reserved.
- Consequence: blocked without written permission (info@qurancomplex.gov.sa).
  Not pursued further in Phase 0.

### 2.4 Indonesian translation — Kemenag/LPMQ direct

- Publisher: Lajnah Pentashihan Mushaf Al-Qur'an, Kementerian Agama RI.
  URLs: <https://quran.kemenag.go.id/>, <https://quranindonesia.kemenag.go.id/>.
- Edition: "Al-Qur'an dan Terjemahannya Edisi Penyempurnaan 2019".
- Terms: site footer "Copyright © 2022 – All Rights Reserved – LPMQ". No public
  license permitting app bundling was found; the ministry has publicly tightened
  copyright supervision of Quran translations (Dec 2025).
- Consequence: blocked without written permission. Parallel action: request
  written permission from LPMQ; do not ship the 2019 text without it.

### 2.5 Indonesian translation — Tanzil hosted files

- Page: <https://tanzil.net/trans/> (verified 2026-10-09). Indonesian entries:
  `id.indonesian` (Indonesian Ministry of Religious Affairs),
  `id.muntakhab` (Quraish Shihab et al.), `id.jalalayn` (Indonesian rendering of
  Tafsir al-Jalalayn).
- Terms (quote): "The translations provided at this page are for non-commercial
  purposes only." More than three translations in one app requires a link back;
  "Redistributing the following list in another website is not allowed, unless
  direct permission is granted."
- Assessment: whether shipping one translation file inside a free-software
  Flatpak counts as permitted non-commercial use vs. restricted redistribution is
  ambiguous, and the underlying Kemenag copyright compounds the doubt for
  `id.indonesian`. The Jalalayn file is a tafsir rendering, not a plain
  translation — do not substitute it for the MVP translation requirement.
- Consequence: not the primary path; usable only with direct translator/publisher
  permission.

### 2.6 Indonesian translation — QuranEnc (primary candidate)

- Publisher: Rowwad Translation Center / QuranEnc (quranenc.com). URLs:
  <https://quranenc.com/en/home>, API at <https://quranenc.com/en/home/api/>.
- Grant (verified 2026-10-09 via site Terms and Policies): "Contents of the
  translations can be downloaded and re-published" subject to seven conditions:
  (1) no modification/addition/deletion; (2) credit publisher + source
  (QuranEnc.com); (3) state version number; (4) keep transcript info; (5) report
  notes to source; (6) update to latest version from source; (7) no inappropriate
  ads alongside.
- Formats: PDF/EPUB/XML/CSV/Excel/SQLite/API; per-translation key, version, and
  last-update via the translations-list API.
- Remaining work before use: confirm the exact Indonesian translation key
  (Ministry vs. Complex edition), record its version number, acquire via a
  documented method, checksum the file, and define the update check honoring
  condition (6). The update condition implies the app should check for newer
  versions; the in-app copy remains readable offline between checks.
- Consequence: proposed primary translation path, pending edition confirmation.

### 2.7 Mirror datasets (not sources of rights)

- fawazahmed0/quran-api (Unlicense), risan/quran-json (CC-BY-SA-4.0), and similar
  mirrors license their own code/packaging — not upstream text/translation
  copyrights. The risan project itself deprecated old versions (2026-09-19) for
  shipping translations without redistribution rights. Never treat a mirror
  license as permission to bundle a translation; always verify the edition-level
  grant (Tanzil terms, QuranEnc terms, or written permission).

## 3. Content integrity and validation plan

Applies to whichever Arabic text + translation editions are approved. No claim of
verification may be made until the checks below are executed against the exact
packaged files and recorded in a validation report.

### 3.1 Structural checks (automated, reproducible)

1. Completeness: exactly 114 surahs; per-surah verse counts match the source's
   published metadata; total ayah count recorded.
2. Identifiers: stable `(surahNumber, ayahNumber)` keys, no missing/duplicate/
   reordered records; surah ordering 1–114.
3. Encoding: UTF-8 validity; no replacement characters; combining marks
   (harakat, superscript alef, waqf marks) preserved codepoint-for-codepoint
   against the downloaded file.
4. Edition identity: record file name, source URL, release version (e.g. Tanzil
   v1.1 Feb 2021), and SHA-256 of every content file.
5. Translation mapping: every translation row joins to an existing ayah key;
   orphan rows fail the build; footnote references (if any) resolve.
6. Metadata consistency: surah names (Arabic + Latin), revelation order fields
   (if shipped), and verse counts agree between content files and manifest.

### 3.2 Reference comparison

- Diff the acquired Arabic text against at least one independent rendering of the
  same edition claim (e.g. Tanzil plain vs. Tanzil XML of the same release) to
  catch truncation or transformation bugs in our own pipeline.
- Scholarly/editorial verification is explicitly out of scope for automated
  checks: the report must distinguish "structural validation passed" from
  "scholarly review", and must make no claim of the latter unless a qualified
  review is performed and recorded with reviewer + date.

### 3.3 Manual review procedure

- Reviewers open representative surahs (short: Al-Kautsar; medium: Yasin; long:
  Al-Baqarah excerpt) in the packaged app on Linux, checking shaping, diacritics,
  verse markers, RTL/LTR mixing, and translation attribution display.
- Record reviewer, date, app commit, dataset checksums, and pass/fail per item.
  Any rendering fix must not normalize or rewrite text without a documented,
  content-owner-compatible transformation policy.

### 3.4 Content manifest and updates

- Ship a `ContentManifest` (see `architecture.md` §4) with: source, edition/
  version, acquisition method + date, SHA-256 per file, license evidence
  reference, validation report reference.
- Content installation/update must be atomic or recoverable (no partially applied
  updates). Quran content records are versioned; user state (bookmarks,
  last-read, preferences) is stored separately and migrations must not corrupt it.
- Upstream corrections: re-acquire from source, re-run the full validation plan,
  bump the manifest version. For QuranEnc translations, honor the "update to
  latest version" condition with a documented check cadence.

## 4. What Phase 0 did NOT do

- No full corpus was downloaded or bundled; only terms/index pages were read.
- No scholarly verification is claimed. No API behavior, license grant, or
  validation result is asserted beyond what the linked sources state.
