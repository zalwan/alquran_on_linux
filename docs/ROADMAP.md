# Project Roadmap

## Guiding rule

**No feature implementation begins until Phase 0 validates content
rights, data integrity strategy, Linux packaging feasibility, and the
architecture.**

## Phase 0 --- Discovery and validation

**Goal:** Deliver a defensible go/no-go decision and an
implementation-ready plan without implementing product features.

Work: - Inspect official Flutter support and Linux build requirements. -
Define target Linux environments and the minimum Flatpak distribution
path. - Compare content sources for Arabic text, translation, metadata,
and optional audio. - Verify terms for display, local storage, offline
sync, bundling, redistribution, attribution, updates, and correction
handling. - Define a content integrity validation procedure. - Prototype
only if necessary to validate a technical risk; no production feature
implementation. - Compare critical packages for Linux support,
maintenance, licenses, and platform compatibility. - Write ADRs and
update PRD/architecture/acceptance criteria. - Record risks and a
go/no-go recommendation.

Deliverables: - `docs/data-sources.md` - `docs/adr/` - Updated
`PRD.md` - Updated `architecture.md` - `ACCEPTANCE_CRITERIA.md` -
Dependency compatibility matrix - Flatpak feasibility note - Go/no-go
report

Exit gate: - No unresolved high-severity data licensing or accuracy
risk. - Offline strategy is permitted by applicable terms. -
Linux/Flatpak technical path is credible. - MVP scope and tests are
agreed. - Product owner explicitly approves Phase 1.

## Phase 1 --- Linux technical foundation

**Goal:** Establish a minimal, testable Flutter Linux application and
packaging pipeline.

Work: - Create the Flutter project with Linux desktop support. - Add
formatting, static analysis, test conventions, and CI. - Add app shell,
routing, theme foundation, and persistence abstraction. - Build a
minimal Flatpak package. - Validate local data installation only after
content source approval. - Record platform and dependency decisions.

Exit gate: - Clean Linux build succeeds. - Flatpak installs and launches
in a sandbox. - Automated checks run in CI. - No unnecessary broad
permissions. - No unapproved Quran content included.

## Phase 2 --- MVP reader

**Goal:** Ship the core offline reading experience.

Work: - Surah index - Arabic reader - Approved Indonesian translation -
Ayah navigation - Bookmarks - Last-read persistence - Light/dark theme
and text scaling - Source/edition credits - Offline integration tests

Exit gate: - All MVP acceptance criteria pass. - Content validation
report is signed off. - Manual Arabic rendering review passes. - Flatpak
release candidate passes clean-install testing.

## Phase 3 --- Stabilization and initial release

**Goal:** Make the Linux app suitable for public use.

Work: - Accessibility and keyboard review - Performance profiling -
Error and migration handling - User-facing documentation - Release notes
and known limitations - License and attribution audit -
Packaging/repository submission preparation

Exit gate: - No open release-blocking defects. - Licensing, provenance,
and security review complete. - Reproducible release procedure
documented to the extent practical.

## Phase 4 --- Post-MVP improvements

Candidate features, in priority order: 1. Arabic and translation search
2. Juz/page navigation if approved metadata is available 3. Audio
recitation and cache management 4. Additional translations 5. Bookmark
import/export

Each feature requires its own scope, data/license review, and acceptance
criteria.

## Phase 5 --- Android discovery and delivery

Begin only after the Linux MVP is stable.

Work: - Reassess Flutter Android support and selected plugin
compatibility. - Define mobile navigation and responsive reader
behavior. - Validate local database migrations and content storage. -
Handle Android lifecycle and audio behavior if audio is included. - Add
Android CI, device testing, signing, and distribution plan.

Exit gate: - Android-specific acceptance criteria pass. - Offline
reading and user state survive process/app restarts. - No
platform-specific behavior breaks domain invariants.

## Indicative schedule

Planning estimate for one developer using coding assistance: - Phase 0:
1 week, potentially longer if rights or content validation is unclear -
Phase 1: 1 week - Phase 2: 2 weeks - Phase 3: 1 week - Phase 4:
iterative - Phase 5: separately estimated after Linux release

These are planning ranges, not commitments. Data licensing, scholarly
validation, and Flatpak compatibility can change the schedule
substantially.
