# Acceptance Criteria

## 1. Phase 0 --- discovery exit criteria

Phase 0 is accepted only when all applicable criteria are evidenced in
repository documentation.

### Content source and licensing

-   [ ] At least two viable source options have been compared, or the
    research record explains why fewer are viable.
-   [ ] The exact Quran text edition and identifier convention are
    documented.
-   [ ] The exact Indonesian translation edition and attribution are
    documented.
-   [ ] Terms covering display, offline storage, caching, bundling,
    redistribution, modifications, and updates have been reviewed.
-   [ ] If using Quran Foundation content, the selected Content Sync or
    separately licensed path and any periodic sync obligations are
    explicitly documented.
-   [ ] The proposed Flatpak bundle and offline behavior are permitted
    by the selected source's terms.
-   [ ] Font and icon licenses are recorded.
-   [ ] Unresolved rights questions are marked as blockers, not
    assumptions.

### Integrity and correctness

-   [ ] A reproducible validation plan exists for completeness,
    duplicates, ordering, identifiers, encoding, and metadata
    consistency.
-   [ ] A plan exists to compare the dataset against an authoritative
    reference.
-   [ ] The validation report format includes dataset version, source,
    checksums, test results, and reviewer/date.
-   [ ] The correction/update strategy is documented.
-   [ ] No unsupported claim of scholarly verification is made.

### Technical feasibility

-   [ ] Flutter Linux build prerequisites and supported target
    environment are recorded.
-   [ ] Flatpak runtime, SDK, manifest approach, and build inputs have
    been investigated.
-   [ ] Critical dependency candidates have documented Linux support and
    license status.
-   [ ] Arabic shaping, diacritics, RTL layout, and font redistribution
    risks have a validation plan.
-   [ ] Storage and sandbox permissions are specified minimally.
-   [ ] The future Android plan identifies platform-specific risks
    without requiring Android implementation now.

### Planning and governance

-   [ ] PRD, architecture, roadmap, and acceptance criteria agree with
    each other.
-   [ ] ADRs exist for material decisions and identify their status.
-   [ ] Risks have severity, mitigation, and an owner/decision maker.
-   [ ] A go/no-go recommendation is documented.
-   [ ] No product feature code has been implemented.
-   [ ] Product owner approval is recorded before Phase 1 starts.

## 2. MVP functional acceptance criteria

### Quran index and reader

-   [ ] The app displays all 114 surahs present in the approved dataset.
-   [ ] Surah ordering, verse counts, and identifiers match the approved
    source.
-   [ ] Opening a surah displays its approved Arabic text in the correct
    order.
-   [ ] Ayah navigation does not skip, duplicate, or reorder verses.
-   [ ] Arabic shaping and diacritics remain legible at supported text
    sizes.
-   [ ] RTL Arabic and LTR interface labels coexist without confusing
    ordering.
-   [ ] Long surahs and small window sizes do not make navigation
    inaccessible.
-   [ ] Translation text is associated with the correct ayah and
    edition.
-   [ ] Source and edition credits are accessible in the application.

### Offline operation

-   [ ] After installation and content provisioning, the user can launch
    and read without network connectivity.
-   [ ] Surah navigation works offline.
-   [ ] Bookmarks and last-read position work offline.
-   [ ] No network request is required for the core reading path.
-   [ ] Missing optional network features do not block reading.
-   [ ] If the approved content strategy requires synchronization, its
    behavior follows the relevant terms and the app remains usable
    during permitted offline periods.

### Bookmarks and progress

-   [ ] A user can add and remove a bookmark.
-   [ ] Bookmarks identify the correct surah and ayah.
-   [ ] Last-read location updates according to the documented
    interaction rule.
-   [ ] Bookmarks and last-read state survive app restart.
-   [ ] Database migration failure is handled without silently
    corrupting user state.

### Appearance and desktop usability

-   [ ] Light and dark themes are available.
-   [ ] Arabic font size can be adjusted within tested bounds.
-   [ ] The window can be resized without clipping core controls.
-   [ ] Keyboard focus is visible and navigation is usable where
    keyboard support is promised.
-   [ ] Basic accessibility checks cover contrast, focus, and scalable
    text.

## 3. Quality and release criteria

-   [ ] Unit and widget tests pass in CI.
-   [ ] Integration tests cover reading, bookmark persistence, and
    last-read restoration.
-   [ ] Content validation checks pass for the exact packaged dataset.
-   [ ] A clean Flatpak install launches and operates in a sandbox.
-   [ ] Flatpak permissions are minimal and justified.
-   [ ] No high-severity content, privacy, or licensing issue remains
    open.
-   [ ] Dependencies and bundled assets have license records.
-   [ ] Release notes, installation instructions, and known limitations
    are documented.

## 4. Non-functional thresholds to set during Phase 0

Do not invent performance numbers before establishing a reference
machine and representative dataset. Phase 0 must define measurable
targets for: - Cold launch time - Surah navigation latency - Memory use
for a long surah - Package size - Accessibility and keyboard coverage -
Automated test coverage for domain logic

Each target must identify its measurement method, test environment, and
whether it is a hard release gate or a monitoring metric.
