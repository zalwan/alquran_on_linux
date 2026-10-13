# Alquran for Linux

A free, open-source, offline-first Quran reader for the Linux desktop.
Arabic Uthmani text with Indonesian translation planned for v1.1 —
v1.0 reads Arabic only. No accounts, no analytics, no ads.

## Install (Flatpak)

Release bundles are not published yet. To build locally:

```sh
# toolchain + GNOME 51 runtime
flatpak remote-add --if-not-exists flathub \
  https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.gnome.Platform//51 org.gnome.Sdk//51

# build (see packaging/flatpak/README.md for the offline/Flathub notes)
flatpak run --system org.flatpak.Builder --force-clean \
  build-dir packaging/flatpak/org.alquran.Reader.yml
```

## Use

- **Index**: browse all 114 surahs, open any verse range by tapping.
- **Reader**: verse-by-verse Arabic in Amiri typeface with ۝ markers.
  Type an ayah number + Go, or use `↓/J` and `↑/K` (`Home`/`End` for
  edges, `/` focuses the jump field, `Esc` back to the index).
- **Bookmarks**: tap the bookmark icon on any verse; entries reopen the
  exact verse from the Bookmarks tab.
- **Appearance**: system/light/dark themes + adjustable Arabic size in
  Settings. All preferences persist locally and offline.

## Content & rights

- Arabic: Tanzil Quran Text, Uthmani v1.1 — verbatim, CC-BY 3.0, see
  `data/manifest/ATTRIBUTION.md` and the in-app About & Sources view.
- Indonesian translation: planned for v1.1 (`docs/translation-clearance.md`).
- Typeface: Amiri (SIL OFL 1.1), license in `assets/fonts/OFL-Amiri.txt`.
- The app never modifies Quran text; display-only rules (basmalah split,
  markers) are covered by tests.

## Known limitations (v1.0)

- Arabic only; no translation, search, audio, juz navigation, or sync.
- First launch seeds the local database (a few seconds, one time).
- Flatpak sandbox proof runs in CI; Flathub submission is pending
  (`packaging/flatpak/README.md`, `docs/flathub-checklist.md`).

## Develop

```sh
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d linux
```

Planning docs live in `docs/` (`PRD.md`, `architecture.md`, `ROADMAP.md`,
`ACCEPTANCE_CRITERIA.md`, ADRs, spike and validation reports).
