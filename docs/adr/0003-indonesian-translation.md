# ADR-0003: Indonesian Translation and Attribution

- Status: proposed
- Date: 2026-10-09
- Deciders: product owner (pending approval)

## Context

The MVP ships one Indonesian translation with verified distribution rights and
in-app attribution (`PRD.md` §6, `docs/data-sources.md` §2.4–2.6).

## Options considered

1. QuranEnc Indonesian edition under QuranEnc republication terms (no
   modification, credit publisher + source, state version, keep transcript info,
   report notes, update to latest, no inappropriate ads).
2. Tanzil `id.indonesian` (Kemenag) file under Tanzil non-commercial terms.
3. Kemenag/LPMQ 2019 text acquired directly.
4. Mirror datasets (fawazahmed0/quran-api, risan/quran-json).

## Decision

Option 1 is proposed, pending confirmation of the exact translation key and
version at acquisition. Option 2 is ambiguous for bundling (non-commercial grant
vs. redistribution restriction + underlying Kemenag copyright) — use only with
direct permission. Option 3 is blocked without LPMQ written permission
(parallel request recommended). Option 4 is rejected as a rights basis: mirror
licenses do not clear upstream translation copyrights.

## Consequences

- Phase 2 must record translation edition ID, version, checksum, attribution
  string, and license evidence in the content manifest and the in-app
  credits view. Tafsir renderings (e.g. Jalalayn Indonesian) must not be
  substituted as the plain translation.
- Honor QuranEnc condition (6) with a documented update-check cadence; the local
  copy stays readable offline between checks.

## Evidence

- QuranEnc: <https://quranenc.com/en/home>, API: <https://quranenc.com/en/home/api/>
- Tanzil translations: <https://tanzil.net/trans/>
- Kemenag: <https://quran.kemenag.go.id/>
