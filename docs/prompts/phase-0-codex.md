# Codex Prompt --- Phase 0: Discovery and Validation Only

## Role

Act as a principal engineer and technical researcher responsible for
preparing the Alquran project for implementation. Be rigorous about data
provenance, licensing, Linux packaging, and Arabic text integrity.

## Product context

We plan to build an open-source Quran reader: - Framework direction:
Flutter - First platform: Linux desktop distributed as Flatpak - UX
direction: GNOME-first - Product behavior: offline-first - Future
platform: Android, after the Linux MVP is stable - Project code license
direction: MIT or Apache-2.0, pending decision - MVP: Quran reader,
approved Indonesian translation, surah/ayah navigation, bookmarks,
last-read position, themes, local persistence - No accounts, cloud sync,
AI, analytics, ads, or backend in MVP

## Critical execution constraint

**This phase is discovery and validation only. Do not implement product
features. Do not create the Flutter application or add runtime
dependencies unless a tiny disposable prototype is explicitly necessary
to validate a material technical risk and the prototype is isolated and
documented.**

Do not treat the existence of an API as proof that its content can be
bundled or stored offline. Do not infer redistribution rights from the
terms "free," "open API," or "open source."

## First steps

1.  Inspect the repository and its current files. Do not overwrite
    existing work without understanding it.
2.  Identify the project state and report whether it is empty, partially
    initialized, or an existing application.
3.  Read and reconcile `PRD.md`, `architecture.md`, `ROADMAP.md`, and
    `ACCEPTANCE_CRITERIA.md` if present.
4.  Use current primary sources for platform support, data terms, and
    packaging. Prefer official documentation and rights-holder terms
    over blog posts.
5.  Record the date each material source was checked. Link to exact
    pages, and quote only short snippets when needed.

## Workstream A --- Quran content source research

Compare at least two realistic content-source strategies for: - Arabic
Quran text and its exact edition/variant - Surah and ayah metadata -
Indonesian translation and named translator/edition - Font files -
Optional future audio

For each source, document: - Publisher and official URL - Exact
dataset/resource/edition - License, terms, or written permission -
Whether app display is allowed - Whether offline storage is allowed -
Whether bundling data inside a Flatpak is allowed - Whether
redistributing data inside an app package is allowed - Whether local
caching is restricted - Whether synchronization or refresh is
mandatory - Attribution/branding requirements - Update and correction
mechanism - Known limitations and unresolved questions

Investigate Quran Foundation's official API and developer terms if
relevant. Pay special attention to the distinction between normal API
responses and any explicitly approved Content Sync mechanism. If the
required offline behavior conflicts with the terms, mark it as a blocker
and propose alternatives; do not work around the terms.

Do not download or bundle a full content corpus as part of Phase 0
unless the source's terms clearly permit it and the action is necessary
and approved. A small sample for evaluation must also comply with its
terms.

## Workstream B --- content integrity plan

Design a reproducible validation plan covering: - Completeness of the
114 surahs and expected verse counts - Stable surah/ayah identifiers -
Missing, duplicate, or reordered records - Unicode encoding and
combining marks - Arabic text variant/edition identification -
Translation-to-ayah mapping - Checksums and content version manifest -
Comparison with an authoritative reference - Manual review procedure and
reviewer record - Handling upstream corrections and version updates

Do not claim the text is verified unless the comparison and review have
actually been performed. Clearly distinguish automated structural
validation from scholarly or editorial validation.

## Workstream C --- Flutter and Linux/Flatpak feasibility

Research official Flutter documentation and validate: - Linux desktop
target support and build prerequisites - Supported architecture/OS scope
relevant to the likely release target - Flatpak runtime and SDK
candidates - Flatpak manifest/build approach - Minimal sandbox
permissions - Writable data locations and app-specific storage -
Build/release CI feasibility - Current packaging/distribution
constraints

Do not assume Flutter's desktop support means every plugin supports
Linux. Produce a dependency compatibility matrix for likely candidates,
including state management, routing, local database, Arabic
font/rendering, and any future audio needs. Mark candidates as proposed,
verified, or blocked, with evidence.

Do not select packages based only on popularity. Evaluate maintenance,
Linux support, Android support where relevant, license, native
dependencies, and migration risk.

## Workstream D --- architecture and ADRs

Review the proposed architecture and create or update concise
Architecture Decision Records for: 1. Quran content source and offline
rights 2. Text edition, typography, and font 3. Indonesian translation
and attribution 4. Local persistence strategy 5. State management and
routing 6. Flatpak runtime and build strategy 7. Original project code
license: MIT versus Apache-2.0

Every ADR must include: - Status: proposed, accepted, rejected, or
blocked - Context - Options considered - Decision or unresolved
question - Evidence and source links - Consequences and follow-up
actions

Do not mark a decision accepted when critical evidence is missing.

## Workstream E --- risks and acceptance criteria

Create a risk register with severity, probability, mitigation,
owner/decision maker, and whether the risk blocks implementation.

Refine the acceptance criteria so each criterion is testable and has
evidence. Set performance thresholds only after defining a reference
machine and measurement method; do not invent arbitrary benchmarks.

## Required deliverables

Create or update these files: - `PRD.md` - `architecture.md` -
`ROADMAP.md` - `ACCEPTANCE_CRITERIA.md` - `docs/data-sources.md` -
`docs/adr/0001-content-source-and-offline-rights.md` -
`docs/adr/0002-arabic-text-and-font.md` -
`docs/adr/0003-indonesian-translation.md` -
`docs/adr/0004-local-persistence.md` -
`docs/adr/0005-flutter-dependencies.md` -
`docs/adr/0006-flatpak-packaging.md` -
`docs/adr/0007-project-license.md` - `docs/risk-register.md` -
`docs/phase-0-report.md`

If the repository is not initialized, create only the documentation
structure and files. Do not run Flutter project generation.

## Quality bar

-   Every material external claim has a source link.
-   Prefer official documentation and rights-holder terms.
-   Separate facts, assumptions, and recommendations.
-   Record source-check dates.
-   Be explicit about uncertainty.
-   Do not invent permissions, license grants, API behavior, package
    capabilities, or content validation results.
-   Do not silently change product scope.
-   Do not add a backend, analytics, account system, or AI feature.
-   Do not commit secrets or credentials.
-   Do not implement features or add production dependencies.

## Final report format

At completion, summarize: 1. Repository state discovered 2. Files
created/updated 3. Main decisions and evidence 4. Dependency
compatibility findings 5. Content-source recommendation and license
status 6. Blocking questions 7. Risk register summary 8. Go/no-go
recommendation: GO, CONDITIONAL GO, or NO-GO 9. Explicit confirmation
that no product implementation was started

If content rights or offline redistribution remain unresolved, the
result must be CONDITIONAL GO or NO-GO, and Phase 1 must not begin until
the blocker is resolved.
