# Product Requirements Document (PRD)

## Project: Alquran

-   **Status:** Draft for Phase 0 validation
-   **Product type:** Open-source Quran reader
-   **Initial platform:** Linux desktop distributed as Flatpak
-   **Future platform:** Android
-   **Framework direction:** Flutter
-   **License direction:** MIT or Apache-2.0, pending final selection
-   **Product posture:** Offline-first, privacy-respecting,
    content-integrity-first

## 1. Product vision

Build a reliable, calm, accessible Quran reading application for Linux
desktops, designed with GNOME conventions in mind. Keep the domain model
and application logic portable so Android can be added later without
rewriting core behavior.

The app should prioritize reading and trustworthy content over accounts,
social features, monetization, or AI features.

## 2. Problem statement

Users need a dependable Quran reader that works without a continuous
internet connection, provides comfortable Arabic typography and
Indonesian translation, preserves local reading progress, and integrates
cleanly with Linux desktop distribution.

## 3. Goals

1.  Provide dependable offline reading for the validated Quran text and
    selected Indonesian translation.
2.  Make Arabic text legible and respectful of its script, marks, and
    shaping.
3.  Support navigation by surah and ayah, bookmarks, and last-read
    position.
4.  Deliver a usable Linux desktop experience and package it as Flatpak.
5.  Keep core domain rules and data contracts portable for a later
    Android client.
6.  Make content provenance, licensing, attribution, and validation
    traceable.
7.  Minimize permissions, telemetry, and collection of personal data.

## 4. Non-goals for MVP

-   User accounts or cloud sync
-   Social features, comments, sharing feeds, or community profiles
-   AI-generated Quran explanations or tafsir
-   Prayer times, Qibla, and broad Islamic lifestyle features
-   Audio recitation as a release blocker (may be evaluated for a later
    release)
-   iOS, web, Windows, or macOS releases
-   Remote backend maintained by this project
-   In-app purchases, ads, or analytics
-   User-editable Quran text

## 5. Target users

-   Linux desktop users who want a focused Quran reader
-   Indonesian readers who need a validated Indonesian translation
-   Users who value offline access and local data
-   Future Android users who expect a familiar reading experience

## 6. MVP scope and requirements

### P0 --- required

-   **Quran index:** Browse all 114 surahs with names and validated
    metadata.
-   **Reader:** Display the complete validated text for the selected
    surah and verse range.
-   **Arabic typography:** Support Arabic shaping, diacritics,
    bidirectional text, and line wrapping without clipping.
-   **Translation:** Display one Indonesian translation whose
    distribution rights and attribution requirements have been verified.
-   **Navigation:** Open a surah and navigate by ayah; show surah and
    ayah identifiers clearly.
-   **Bookmarks:** Add/remove local bookmarks for ayahs.
-   **Last read:** Persist the most recently read location across
    restarts.
-   **Offline behavior:** Reading, navigation, bookmarks, and last-read
    state work without network access after installation.
-   **Appearance:** Light and dark themes, readable spacing, and
    adjustable Arabic text size.
-   **Local persistence:** Store user preferences and reading state
    locally.
-   **Source information:** Provide an in-app content credits/about view
    that identifies the source and edition of the text and translation.
-   **Desktop basics:** Keyboard navigation where practical, resizable
    window, and sensible behavior at common desktop window sizes.

### P1 --- only after MVP validation

-   Search in Arabic and Indonesian translation
-   Additional translations, subject to license validation
-   Audio recitation and cache management
-   Juz/page navigation, if validated metadata and UX scope are ready
-   Export/import of local bookmarks using a documented format

### Explicitly deferred

-   Cross-device synchronization
-   Accounts and cloud storage
-   Tafsir collections
-   Reading goals and statistics
-   Android UI and store publication
-   Automatic background content synchronization, until its data source
    and policy are decided

## 7. UX principles

1.  Reading is the primary task; keep controls quiet and predictable.
2.  Respect GNOME desktop conventions without forcing a mobile-style
    navigation pattern onto desktop.
3.  Arabic text must remain the visual focus, with translation clearly
    differentiated.
4.  Prefer keyboard accessibility and a resizable layout.
5.  Avoid disruptive prompts, advertisements, or unnecessary
    notifications.
6.  Make source and edition information discoverable.
7.  Do not silently substitute, normalize, or modify Quran text.

## 8. Data integrity and provenance requirements

The project must not select a data source based only on convenience or
API availability.

For each proposed source, record: - Publisher and canonical source URL -
Exact text/translation edition and identifier - License or terms
applicable to display, local storage, bundling, redistribution, and
modification - Required attribution and branding - Update/correction
process - Format, encoding, verse identifiers, and metadata coverage -
Cryptographic checksums or reproducible validation method where
possible - Evidence of completeness and a comparison plan against an
authoritative reference

**Important:** Quran Foundation API terms distinguish displaying content
in an application from redistributing raw content or packaged datasets.
Its Content Sync documentation describes a specific route and ongoing
synchronization requirements for offline copies. Do not bundle or
persist Quran Foundation content unless the selected method and terms
explicitly permit the intended use. Phase 0 must confirm whether Content
Sync is compatible with a Flatpak-first offline product or identify an
independently redistributable dataset.

## 9. Quality attributes

-   **Correctness:** No missing, duplicated, reordered, or silently
    altered verses in the approved dataset.
-   **Offline reliability:** Core reading does not require network
    connectivity.
-   **Privacy:** No account, analytics, or network dependency for core
    reading.
-   **Performance:** Surah navigation should feel immediate on the
    agreed reference device; define a measurable budget during Phase 0.
-   **Accessibility:** Keyboard focus, contrast, scalable text, and
    screen-reader behavior assessed for the selected toolkit.
-   **Portability:** Core domain rules do not depend on Flutter widgets
    or Linux-only APIs.
-   **Maintainability:** Feature-oriented modules, automated tests, and
    documented data schemas.
-   **Packaging:** Flatpak runs with minimal permissions and persists
    data in app-specific storage.

## 10. Success measures for MVP

-   All approved content passes completeness and integrity checks.
-   Core reading flows pass offline tests.
-   Bookmarks and last-read state survive application restarts.
-   Linux release artifact installs and launches in a clean test
    environment.
-   No unresolved high-severity content licensing or accuracy issue
    remains.
-   Automated tests cover core domain rules and persistence.
-   No required network permission for basic reading, unless a Phase 0
    decision explicitly approves a narrowly scoped use.

## 11. Risks and mitigations

  -----------------------------------------------------------------------
  Risk                                Mitigation
  ----------------------------------- -----------------------------------
  Data license does not permit        Resolve before implementation;
  bundling                            select a permitted source or
                                      approved sync design

  Arabic font/shaping issues          Prototype representative Arabic
                                      text and verify on Linux

  Plugin lacks Linux support          Validate every critical plugin on
                                      Linux before adoption

  Flatpak permissions become too      Start from minimum permissions and
  broad                               justify each exception

  Data correction process is unclear  Record versioning, provenance, and
                                      update strategy

  Scope grows before MVP              Keep all P1 and deferred features
                                      out of the first release
  -----------------------------------------------------------------------

## 12. Phase 0 exit criteria

Phase 0 is complete only when: 1. Data source, edition, license,
attribution, offline storage and redistribution approach are documented
and approved. 2. Flutter/Linux/Flatpak feasibility and critical
dependencies are validated. 3. Architecture decisions and alternatives
are recorded in ADRs. 4. MVP scope and measurable acceptance criteria
are agreed. 5. High-severity risks have owners and mitigations. 6. A
go/no-go recommendation is delivered. 7. No application feature
implementation has started.
