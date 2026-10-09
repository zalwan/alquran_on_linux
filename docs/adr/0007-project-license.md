# ADR-0007: Project License (MIT vs. Apache-2.0)

- Status: proposed
- Date: 2026-10-09
- Deciders: product owner (pending approval)

## Context

Original project code license direction is MIT or Apache-2.0, pending final
selection (`PRD.md`). This covers our own code only — content, fonts, and
dependencies keep their own licenses (CC-BY 3.0 + custom terms for Tanzil text,
QuranEnc terms for translation, SIL OFL for fonts; see ADR-0001–0003).

## Options considered

1. MIT: minimal, permissive, widely understood; only requires preserving
   copyright + license notice. No explicit patent grant.
2. Apache-2.0: permissive with an explicit patent grant and retaliation clause;
   requires preserving notices and documenting changes to files.

## Decision

MIT is proposed for simplicity and lowest friction for a small community
reader app with no patent-sensitive contributions expected. Apache-2.0 remains
acceptable if the owner prefers the patent grant.

## Consequences

- On approval: add `LICENSE` (MIT text with copyright holder/year), set
  `license:` in `pubspec.yaml` metadata if desired, and keep a dependency/asset
  license record (required release criterion). License choice does not change
  any content obligations.
- Unresolved: copyright holder name/year for the LICENSE file — owner to
  confirm in Phase 1.

## Evidence

- No external evidence required beyond standard license texts
  (<https://opensource.org/licenses/MIT>,
  <https://www.apache.org/licenses/LICENSE-2.0>); content-license evidence is in
  ADR-0001–0003.
