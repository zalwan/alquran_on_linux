# ADR-0001: Content Source and Offline Rights

- Status: proposed
- Date: 2026-10-09
- Deciders: product owner (pending approval)

## Context

The MVP is offline-first and ships as a Flatpak. Ordinary API access must not be
mistaken for redistribution rights. Evidence: `docs/data-sources.md` (checked
2026-10-09).

## Options considered

1. Tanzil Quran Text (Uthmani v1.1) bundled verbatim + QuranEnc Indonesian
   translation bundled under QuranEnc republication terms.
2. Quran Foundation API via Content Sync at runtime (no pre-bundled database).
3. KFGQPC-derived text or Kemenag 2019 text bundled directly.

## Decision

Option 1 is proposed. Option 2 is rejected for the MVP offline bundle under
standard QF terms (prepackaged databases require a separate commercial license;
Content Sync mandates connectivity plus 7-day sync). Option 3 is blocked without
written permission.

## Consequences

- Phase 1 must not bundle any Quran content. Phase 2 content work requires the
  confirmed translation key/version, checksums, and a signed validation report.
- Follow-ups: confirm QuranEnc Indonesian key/version; optionally request LPMQ
  permission in parallel; optionally request QF commercial terms if a QF-based
  future is ever wanted.

## Evidence

- Tanzil text license: <https://tanzil.net/docs/text_license>
- QF developer terms (2026-10-04): <https://api-docs.quran.foundation/legal/developer-terms/>
- QuranEnc terms: <https://quranenc.com/en/home> ("Terms and Policies")
- Tanzil translations terms: <https://tanzil.net/trans/>
