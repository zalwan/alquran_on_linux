# Phase 0 Report — Discovery and Validation

- Date: 2026-10-09
- Scope: discovery and validation only. No product implementation was started;
  no runtime dependencies were added; no dataset was downloaded or bundled.

## 1. Repository state discovered

- Default Flutter counter template (`lib/main.dart`) + `pubspec.yaml` (no
  product dependencies beyond `cupertino_icons`, `flutter_lints`).
- Planning pack in `docs/`: `PRD.md`, `architecture.md`, `ROADMAP.md`,
  `ACCEPTANCE_CRITERIA.md`, `prompts/phase-0-codex.md` — mutually consistent,
  no changes required in Phase 0.
- `docs/theme.md` (pre-existing design proposal for Phase 1+) — out of Phase 0
  scope, untouched.
- Toolchain present: Flutter 3.44.4 (stable), Flatpak 1.18.0.
- New Phase 0 files: `docs/data-sources.md`, `docs/adr/0001–0007`, 
  `docs/risk-register.md`, this report.

## 2. Files created/updated

- Created: `docs/data-sources.md` (source comparison + validation plan),
  `docs/adr/0001-content-source-and-offline-rights.md`,
  `docs/adr/0002-arabic-text-and-font.md`,
  `docs/adr/0003-indonesian-translation.md`,
  `docs/adr/0004-local-persistence.md`,
  `docs/adr/0005-flutter-dependencies.md`,
  `docs/adr/0006-flatpak-packaging.md`,
  `docs/adr/0007-project-license.md`,
  `docs/risk-register.md`, `docs/phase-0-report.md`.
- Updated: none of `PRD.md` / `architecture.md` / `ROADMAP.md` /
  `ACCEPTANCE_CRITERIA.md` — reviewed and found consistent with findings.

## 3. Main decisions and evidence

- Content: Tanzil Uthmani v1.1 (verbatim grant verified at
  <https://tanzil.net/docs/text_license>) + QuranEnc Indonesian edition
  (republication grant verified, key/version TBD) — both status proposed
  (ADR-0001, ADR-0003).
- QF API bundling rejected for MVP under standard terms (verified
  <https://api-docs.quran.foundation/legal/developer-terms/>, last updated
  2026-10-04): 1-week cache limit, Content Sync as sole offline path with 7-day
  sync, no prepackaged database without a commercial license.
- KFGQPC-derived text and direct Kemenag 2019 text: blocked without written
  permission. Mirror-dataset licenses do not clear upstream rights.
- Persistence: Drift + sqlite3 3.x + shared_preferences + path_provider,
  pending sandbox-build smoke test (ADR-0004).
- Dependencies: go_router + riverpod + drift stack proposed; audio and runtime
  font fetching excluded (ADR-0005).
- Flatpak: GNOME SDK, offline manifest tooling (flatpak-flutter/flutpak),
  minimal finish-args without network (ADR-0006).
- License: MIT proposed for original code (ADR-0007).

## 4. Dependency compatibility findings

All critical candidates badge Linux + Android support with permissive licenses
(go_router BSD-3, riverpod MIT, drift MIT, sqlite3 MIT, shared_preferences and
path_provider BSD-3). Two items need empirical confirmation: drift/sqlite3 build
hooks under `flatpak-builder --sandbox`, and Arabic shaping quality for dense
Uthmani marks. Full matrix: ADR-0005.

## 5. Content-source recommendation and license status

Proceed with Tanzil Arabic + QuranEnc Indonesian as proposed paths; translation
edition identity (key/version/checksum) is the remaining clearance item before
any bundling. QF/KFGQPC/direct-Kemenag paths are blocked as documented. No
verified content is claimed — structural validation must still run against the
exact packaged files per `docs/data-sources.md` §3.

## 6. Blocking questions

1. Exact QuranEnc Indonesian translation key + version, and its acquisition
   checksum (owner: product owner; blocks Phase 2 content).
2. LPMQ written-permission outcome if the QuranEnc path falls through.
3. Rendering-spike result (font choice + shaping sign-off).
4. Sandbox-build smoke test result (drift/sqlite3 + offline manifest).
5. LICENSE holder/year + final MIT confirmation.

## 7. Reference device and measurement methods (thresholds TBD in Phase 1)

- Reference device: to be declared in Phase 1 (suggested: clean Ubuntu 24.04 LTS
  x86_64 VM/container + Flatpak sandbox, specs recorded).
- Methods: cold launch timed from `flatpak run` to first painted frame;
  navigation latency measured opening Al-Baqarah (longest surah) averaged over 5
  runs; memory sampled via system monitor during long-surah scroll; package size
  from Flatpak bundle; keyboard coverage by checklist walkthrough; domain-logic
  coverage from `flutter test --coverage`. Numeric gates are set after baseline
  measurement — no invented targets.

## 8. Risk register summary

10 risks logged (`docs/risk-register.md`): 2 licensing blockers (R1 translation
rights, R2 QF bundling), 3 technical blockers with spikes (R3 shaping, R4 font
license, R5 native build hooks), plus permissions, scope, updates, system theme,
and performance risks with mitigations and owners.

## 9. Go/no-go recommendation: CONDITIONAL GO

- Phase 1 foundation (project setup, shell, theme foundation per `docs/theme.md`,
  persistence abstraction, Flatpak manifest smoke test — with NO Quran content
  bundled) may proceed after product-owner approval of the ADRs.
- Phase 2 content work must not begin until blocking questions 1–4 are resolved
  and the validation report for the exact packaged dataset is signed off.

## 10. Explicit confirmation

No product feature code was implemented, no production dependencies were added,
and no Quran corpus was downloaded or packaged during Phase 0. All external
claims above link to primary sources checked 2026-10-09; uncertainties are
marked as such in `docs/data-sources.md` and the ADRs.
