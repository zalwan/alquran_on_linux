# Risk Register

> Phase 0 output, 2026-10-09. Severity: High/Medium/Low. Probability:
> High/Medium/Low. Owner = decision maker unless noted.

| # | Risk | Severity | Probability | Mitigation | Owner | Blocks implementation? |
| --- | --- | --- | --- | --- | --- | --- |
| R1 | Indonesian translation bundling rights unclear (Kemenag All Rights Reserved; Tanzil terms ambiguous) | High | Medium | Primary path: QuranEnc edition with recorded key/version; parallel LPMQ permission request; no bundling until confirmed | Product owner | Yes — blocks Phase 2 content work, not Phase 1 foundation |
| R2 | QF API content bundled by mistake (standard terms forbid prepackaged DB; 1-week cache limit) | High | Low | ADR-0001 + manifest review gate; never build offline copies from regular API responses; commercial license only via written agreement | Product owner | Yes — QF path blocked for MVP bundle |
| R3 | Arabic shaping/diacritic defects on Linux/Flatpak (unverified for Uthmani dense marks) | High | Medium | Rendering spike with candidate OFL fonts in Phase 1; manual review of short/medium/long surahs; bundled font pinned | Tech lead | Yes — blocks reader sign-off |
| R4 | Font redistribution breach (wrong font or missing OFL notice) | High | Low | Use SIL OFL fonts only; ship `OFL.txt`; register via `LicenseRegistry`; license audit at release | Tech lead | Yes — blocks release |
| R5 | drift/sqlite3 native hooks fail in offline Flatpak build | Medium | Low | Sandbox-build smoke test in Phase 1; fallback `sqflite_common_ffi`; no system-lib assumption | Tech lead | Yes — blocks Phase 1 exit until resolved |
| R6 | Flatpak permissions creep (network/audio/filesystem added casually) | Medium | Medium | Start minimal (ADR-0006); each addition justified in manifest review; Flathub lint gate | Tech lead | No (release gate instead) |
| R7 | Scope growth before MVP (search, audio, tafsir, sync) | Medium | Medium | PRD non-goals enforced; each P1 feature needs its own license/scope review | Product owner | No |
| R8 | Content correction/update path undefined at runtime | Medium | Medium | Manifest versioning + atomic updates; QuranEnc update-check cadence documented in Phase 2 | Tech lead | No |
| R9 | GNOME system-theme following inside Flatpak behaves unexpectedly | Low | Medium | Validate in Phase 1; ship explicit System/Light/Dark setting regardless | Tech lead | No |
| R10 | Performance on long surahs (navigation latency, memory) | Low | Low | Profile in Phase 3 against agreed reference device; thresholds set in Phase 0 report §7 | Tech lead | No |

## Notes

- R1/R2 are the licensing blockers behind the CONDITIONAL GO in
  `docs/phase-0-report.md`. R3–R5 are technical blockers with defined spikes.
- Severity High + unresolved = must be resolved before the gated milestone
  listed in the mitigation column.
