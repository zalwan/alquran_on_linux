# Architecture Decision and Design

## Project: Alquran

-   **Status:** Proposed architecture; decisions require Phase 0
    validation
-   **Primary platform:** Linux desktop / Flatpak
-   **Future platform:** Android
-   **Framework:** Flutter
-   **Design posture:** GNOME-first, offline-first

## 1. Architectural principles

1.  Content provenance and integrity are first-class architectural
    concerns.
2.  Keep Quran content separate from executable application code.
3.  Keep domain logic independent of Flutter widgets and platform APIs.
4.  Local reading must work without a network connection.
5.  Platform-specific integrations sit behind narrow interfaces.
6.  Use the least Flatpak permissions possible.
7.  Avoid speculative abstractions; introduce interfaces where they
    protect domain rules, data sources, persistence, or platform
    boundaries.
8.  Never silently transform or auto-translate Quranic text.

## 2. Proposed logical layers

``` text
┌─────────────────────────────────────────────────────┐
│ Presentation                                        │
│ Home · Surah index · Reader · Bookmarks · Settings  │
├─────────────────────────────────────────────────────┤
│ Application / Use cases                             │
│ OpenSurah · SaveBookmark · RestoreLastRead          │
├─────────────────────────────────────────────────────┤
│ Domain                                              │
│ Surah · Ayah · Translation · Bookmark · ReadingPos  │
├─────────────────────────────────────────────────────┤
│ Data                                                │
│ Repositories · Local DB · Content manifest          │
├─────────────────────────────────────────────────────┤
│ Platform adapters                                   │
│ Filesystem · Packaging · Optional audio/notifications│
└─────────────────────────────────────────────────────┘
```

Dependencies should point inward. Domain entities and use cases must not
import Flutter UI packages, SQLite implementation types, or Linux-only
APIs.

## 3. Proposed repository layout

``` text
alquran/
├── AGENTS.md
├── README.md
├── LICENSE
├── pubspec.yaml
├── analysis_options.yaml
├── lib/
│   ├── app/
│   │   ├── app.dart
│   │   ├── router.dart
│   │   └── theme/
│   ├── core/
│   │   ├── database/
│   │   ├── errors/
│   │   ├── localization/
│   │   └── platform/
│   ├── domain/
│   │   ├── entities/
│   │   ├── repositories/
│   │   └── usecases/
│   ├── data/
│   │   ├── datasources/
│   │   ├── models/
│   │   └── repositories/
│   └── features/
│       ├── home/
│       ├── surah_index/
│       ├── quran_reader/
│       ├── bookmarks/
│       └── settings/
├── assets/
│   ├── fonts/
│   └── icons/
├── data/
│   └── manifest/
├── test/
│   ├── unit/
│   ├── widget/
│   └── integration/
├── integration_test/
├── linux/
├── android/                 # generated/maintained when Android work begins
├── packaging/
│   └── flatpak/
└── docs/
    ├── adr/
    ├── data-sources.md
    └── release-process.md
```

This is a target layout, not a command to generate it during Phase 0.
Flutter conventions and generated platform files should be respected
when implementation is approved.

## 4. Domain model (proposed)

-   `Surah`: stable surah number, source identifiers, names, verse count
    and any validated metadata.
-   `Ayah`: stable key `(surahNumber, ayahNumber)`, canonical Arabic
    text reference, and optional validated navigation metadata.
-   `Translation`: translation edition ID, language,
    translator/publisher attribution and license metadata.
-   `AyahTranslation`: ayah key, translation edition ID, text and
    optional footnote references.
-   `Bookmark`: ayah key, creation timestamp, optional user note
    (deferred unless needed).
-   `ReadingPosition`: last-read ayah key and updated timestamp.
-   `ContentManifest`: source, edition/version, checksum, acquisition
    method, license evidence and validation report reference.

Do not assume a particular Arabic text variant, verse segmentation, or
identifier convention until the source dataset is selected and reviewed.

## 5. Repository interfaces (conceptual)

-   `QuranContentRepository`: retrieves surahs, ayahs, and validated
    translations.
-   `BookmarkRepository`: creates, removes, and lists local bookmarks.
-   `ReadingProgressRepository`: reads and updates last-read location.
-   `PreferencesRepository`: stores theme, font size, and display
    preferences.

Repository contracts should use domain types. Concrete SQLite/Drift
models stay in the data layer.

## 6. Persistence

SQLite is the leading candidate for local structured data. Drift is a
candidate convenience layer, but both must be checked against Linux
support, packaging, migration needs, and future Android behavior before
selection.

Separate immutable or versioned Quran content from mutable user state: -
Quran content and translation records are governed by source and content
version. - User state includes bookmarks, last-read position, and
preferences. - Schema migrations must be tested. - Backups/export should
not be part of MVP unless required by the product decision. - Content
installation/update must be atomic or recoverable to avoid partially
applied updates.

Do not package any third-party content until the license and acquisition
method explicitly allow it.

## 7. Arabic rendering

Phase 0 must test: - Arabic shaping and joining forms -
Harakat/diacritics and combining marks - Right-to-left text and mixed
Arabic/Latin labels - Line wrapping, punctuation, verse markers, and
selection behavior - Font license and permission to redistribute the
font - Text scaling and rendering at different desktop window sizes

Do not manually normalize or rewrite text to fix a display problem
without a documented, validated transformation policy and content-owner
approval.

## 8. Offline-first data strategy

Offline-first describes user-visible behavior, not permission to copy
content.

Evaluate at least: 1. A static dataset whose license explicitly permits
redistribution and local bundling. 2. A provider-supported content-sync
mechanism whose terms permit offline storage and define refresh
obligations. 3. A separately licensed content package from a publisher
or rights holder.

For each option, document acquisition, versioning, correction delivery,
attribution, checksums, storage duration, offline behavior and
redistribution rights. The project must not treat ordinary API responses
as freely redistributable data.

If the chosen provider requires periodic synchronization, the
architecture must account for that obligation while still making
previously approved local content readable during connectivity outages,
subject to the applicable terms.

## 9. Linux / Flatpak boundary

-   Use the official Flutter Linux build target.
-   Package through a Flatpak manifest and a declared runtime/SDK.
-   Store user data under application-specific writable storage.
-   Start with minimum sandbox permissions.
-   Add network permission only if a documented feature needs it.
-   Add audio or desktop integration permissions only when the
    corresponding feature is approved.
-   Test in a clean Flatpak sandbox, not only with `flutter run`.
-   Document required runtime, architecture, build inputs, and
    reproducibility limitations.
-   Confirm current Flathub submission and branding requirements before
    publishing.

## 10. Android later

Android is explicitly not the first release target. Preserve portability
by keeping: - Domain and repository contracts platform-neutral - Content
manifest and schema format stable where practical - Local persistence
behind repository interfaces - UI layout adaptive rather than desktop
assumptions in domain logic

Before Android implementation, perform a separate platform review for
lifecycle, file storage, audio behavior, accessibility, screen sizes,
app signing, and store requirements. Do not promise identical plugin
behavior across Linux and Android.

## 11. Testing strategy

-   Unit tests: domain rules, navigation identifiers, bookmarks,
    last-read behavior.
-   Data tests: dataset completeness, duplicate/missing identifiers,
    checksum verification, migration behavior.
-   Widget tests: reader layout, text scaling, theme, keyboard focus.
-   Integration tests: offline launch, open surah, add bookmark,
    restart, restore state.
-   Packaging tests: install and launch Flatpak in a clean environment.
-   Manual content review: representative short/long surahs, diacritics,
    verse endings, translation attribution.

## 12. Architecture Decision Records required in Phase 0

Create an ADR for each decision: 1. Content source and offline rights.
2. Arabic text edition and rendering/font strategy. 3. Translation
edition and rights. 4. State management and routing. 5. SQLite/Drift or
alternative persistence. 6. Flatpak runtime and build strategy. 7.
License choice for original project code.

Each ADR must include context, options considered, decision,
consequences, evidence, unresolved questions, and status. Keep
unresolved decisions explicitly marked `proposed` or `blocked`; do not
present them as final.
