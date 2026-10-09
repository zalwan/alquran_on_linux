# Theme Specification — Alquran on Linux

> Dedicated theme document. Product decisions remain in `PRD.md`, architecture in
> `architecture.md`, phasing in `ROADMAP.md`, and test criteria in
> `ACCEPTANCE_CRITERIA.md`.

- **Status:** Proposal for the Phase 1 theme foundation (not yet validated on device)
- **Scope:** Colors, typography, light/dark modes, reading components, accessibility
- **Out of scope:** Selection of Quran text/translation sources, final font choice
  (decided in the font ADR), audio, search

## 1. Relationship to the development plan

| Document | Theme relevance |
| --- | --- |
| `PRD.md` §6 P0 | Requires light/dark themes, Arabic legibility, adjustable Arabic text size, local preference persistence |
| `PRD.md` §7 UX principles 1–3 | Reading is the primary task; quiet controls; Arabic text is the visual focus with translation clearly differentiated |
| `architecture.md` §2–3 | Theme lives in `lib/app/theme/`; preferences go behind `PreferencesRepository` (theme, font size, display options) |
| `ROADMAP.md` Phase 1 | Theme foundation + persistence abstraction + app shell. This document guides the Phase 1 implementation |
| `ROADMAP.md` Phase 2 | MVP reader: surah index, Arabic text + translation, ayah navigation, ayah highlight, source credits |
| `ROADMAP.md` Phase 3 | Accessibility and keyboard audit, performance profiling, release documentation |
| `ACCEPTANCE_CRITERIA.md` §2 | Light/dark themes available, Arabic font size adjustable, resize without clipping, visible keyboard focus, contrast checks |

Theme decisions must never alter Quran text (`architecture.md` §1.8 and
`PRD.md` §7.7).

## 2. Agreed core palette

Four core colors only, to keep the identity consistent and calm:

| Name | Hex | Primary role |
| --- | --- | --- |
| Primary green | `#166534` | Active navigation, primary buttons, Islamic accents |
| White | `#FFFFFF` | Main light-mode background, clean reading space |
| Very light green | `#F0FDF4` | Panels, ayah highlights, supporting elements |
| Dark green | `#14532D` | Dark mode, contrast, emphasis elements |

Usage rules:

1. Do not add a new hue (decorative blue, yellow, or red) without a new ADR/design review.
2. Functional colors (error, success, focus) are either derived from green or use
   standard Material/GNOME system colors, documented in §5.
3. `#166534` is the single action color. `#14532D` is for emphasis and dark
   surfaces. `#F0FDF4` must not be used as text on white (contrast is too low) —
   only as a panel/highlight background.

## 3. Application principles (from the product request)

### 3.1 Light mode

- Dominantly white (`#FFFFFF`) for the reading space.
- Green accents (`#166534`) only on: active navigation items, primary buttons,
  reading-progress indicators, last-read markers, links/actions.
- Readable text: neutral dark body text for Latin/Indonesian (see §4), deep dark
  Arabic text, with translation differentiated by size/color rather than heavy
  decoration.
- Supporting panels (surah list, info cards, active ayah highlight) use
  `#F0FDF4` with a thin green border so the reading space stays clean.

### 3.2 Dark mode

- Greenish-black background derived from `#14532D` (see the `surface-dark`
  tokens in §4). Do not use pure black so green accents stay harmonious.
- Soft white text (not pure `#FFFFFF`, e.g. `#F5F7F5` / `#E7EFE9`) to reduce glare.
- Use a lighter green accent than `#166534` (e.g. `#4ADE80` / `#86EFAC`)
  specifically for dark mode so it stays comfortable and meets contrast.
  `#166534` on a dark background does **not** meet text contrast — it may only be
  used as a block/large-icon fill, not for small text.
- Ayah highlights in dark mode use a dark green slightly lighter than the
  background (not `#F0FDF4`).

### 3.3 Arabic text as the focal point

- Arabic: base size larger than Latin text (±1.3–1.6×), generous `height`
  (1.8–2.2), right-aligned (RTL), without excessive ornamentation or frames.
- Translation: smaller size, dimmer color, clear spacing below each verse so the
  Arabic > translation hierarchy is always visible.
- Verse numbers: small green circles/markers that do not compete with the verse text.
- No text shadows, gradients on verse text, or background patterns in the reading area.

### 3.4 Accessibility

- Targets: body text ≥ 4.5:1, large text ≥ 3:1, focus indicators and meaningful
  icons ≥ 3:1 (using WCAG 2.2 AA as the Phase 3 reference).
- Every color pair in §4 must be tested with a contrast calculator before the
  Phase 2 exit (see §8).
- Never rely on color alone: active/bookmark/last-read states always include a
  text label or an icon + tooltip readable by screen readers.
- Keyboard focus must always be visible (2px green outline, 2px offset).

## 4. Color tokens

Tokens are stable names used by code (`lib/app/theme/`). Implementation hex
values may be tuned as long as roles and contrast targets hold.

### 4.1 Base tokens

| Token | Light | Dark | Used for |
| --- | --- | --- | --- |
| `primary` | `#166534` | `#4ADE80` (derived light accent) | Primary buttons, active nav, Islamic accents |
| `primary-container` | `#F0FDF4` | `#14532D` | Panels, ayah highlights, active chips |
| `on-primary` | `#FFFFFF` | `#052E16` | Text/icons on `primary` |
| `on-primary-container` | `#14532D` | `#DCFCE7` | Text on panels/highlights |
| `background` | `#FFFFFF` | `#0B1F14` (greenish black derived from `#14532D`) | App background |
| `surface` | `#FFFFFF` | `#0F2A1C` | Cards, AppBar, dialogs |
| `surface-variant` | `#F0FDF4` | `#143726` | Surah list, secondary panels |
| `outline` | `#BBD7C5` (derived) | `#2D5540` (derived) | Borders, dividers |
| `text-primary` | `#101815` (near-black neutral) | `#F5F7F5` (soft white) | Main content |
| `text-secondary` | `#3F4D46` (derived) | `#C4D4C9` (derived) | Translation, metadata |
| `text-arabic` | `#0C1A12` | `#F2F7F3` | Arabic text (always the strongest) |

> Note: colors marked "(derived)" are not part of the four core colors, but are
> required for contrast and hierarchy. They all stay within the green/neutral
> family — no new hue is introduced. For a strict 4-color approach, replace the
> derived values with system black/gray, at the cost of a weaker reading hierarchy.

### 4.2 Status colors (functional, not decorative)

| Token | Light | Dark | Rule |
| --- | --- | --- | --- |
| `error` | `#B3261E` (Material default) | `#F2B8B5` | Only for real errors (DB migration failure, corrupt content). Not an accent |
| `focus-ring` | `#166534` | `#4ADE80` | 2px keyboard-focus outline |
| `scrim` | `rgba(5,46,22,0.32)` | `rgba(0,0,0,0.6)` | Dialog backdrop |

### 4.3 Pairs that must pass contrast (test in Phase 2/3)

1. `text-primary` on `background` (light and dark)
2. `text-arabic` on `background` and on `primary-container` (highlight)
3. `on-primary` on `primary` (button labels)
4. `on-primary-container` on `primary-container` (text inside ayah highlights)
5. `primary` as small text/links/icons on `background` — only the light version
   `#166534`; the dark version must use the lighter accent
6. `text-secondary` on `background` (should reach ≥ 4.5:1; darken/lighten until it passes)

#### Measured contrast audit — 2026-10-09

Computed with the WCAG 2.x relative-luminance formula and pinned by
`test/theme_contrast_test.dart` (fails on any token regression). All pairs
meet AA body-text contrast (≥ 4.5:1) with margin — no token changes required:

| Pair | Ratio |
| --- | --- |
| text-primary / background (light) | 18.05 |
| text-primary / background (dark) | 15.98 |
| arabic / background (light) | 17.92 |
| arabic / highlight (light) | 17.12 |
| arabic / background (dark) | 15.88 |
| arabic / highlight (dark) | 8.41 |
| on-primary / primary (light) | 7.13 |
| on-primary / primary (dark) | 8.55 |
| on-container / container (light) | 8.70 |
| on-container / container (dark) | 8.30 |
| primary as small text (light) | 7.13 |
| accent as small text (dark) | 9.88 |
| secondary / background (light) | 8.89 |
| secondary / background (dark) | 11.15 |

## 5. Per-mode schemes (implementation summary)

### 5.1 Light — "clean, dominantly white"

- `background`/`surface`: `#FFFFFF`
- `surface-variant`/`primary-container`: `#F0FDF4`
- Header/AppBar: white, dark title, green actions for primary actions only.
- Navigation (sidebar/rail): active item = `#F0FDF4` pill + `#166534` label/icon +
  3px `#166534` indicator strip; inactive items = `text-secondary`.
- Primary button: `#166534` background, `#FFFFFF` text, 8–12px radius, no gradient.
- Secondary button: thin green outline, `#166534` text, white background.
- Active ayah / last-read highlight: `#F0FDF4` background + 3px left bar in `#166534`.
- Bookmark active: filled `#166534` icon; inactive: `text-secondary` outline.

### 5.2 Dark — "calm greenish-black"

- `background`: `#0B1F14`, `surface`: `#0F2A1C`, `surface-variant`: `#143726`.
- Text: soft white, not pure white.
- Interactive accents use light green (`#4ADE80`) for text/icons/borders.
  `#166534` and `#14532D` remain surface blocks, not small text.
- Ayah highlight: `#143726` + light-accent left bar.
- AppBar/sidebar: dark surfaces without heavy shadows; use a 1px `#2D5540`
  border as separator (shadows are invisible in dark mode).
- Avoid `#F0FDF4` panels in dark mode — too glaring and breaks dark adaptation.

## 6. Typography

The final font decision (license + redistribution + Arabic shaping) remains with
the Phase 0 font ADR. This spec only defines roles and scale.

| Role | Base size | Weight | Notes |
| --- | --- | --- | --- |
| Arabic verse | 26–32sp, adjustable 20–40sp | Regular/Medium | RTL, `height` 1.8–2.2, never condensed |
| Arabic surah title | 28–34sp | SemiBold | Minimal decoration, e.g. thin green frame |
| Indonesian translation | 15–17sp | Regular | `text-secondary` color, `height` 1.5–1.6 |
| Latin surah name | 16–18sp | Medium/SemiBold | `text-primary` |
| Metadata (verse count, juz) | 12–14sp | Regular | `text-secondary` |
| Small Arabic labels (ornamental basmalah) | follows verse | Regular | No decorative font that alters letterforms |

Arabic requirements (from `architecture.md` §7, still applicable):

- Shaping, harakat, and combining marks are never clipped at any supported size.
- Mixed RTL/LTR content (verse numbers + Latin labels) keeps an unambiguous reading order.
- Test short, medium, and long surahs (e.g. Al-Kautsar, Yasin, Al-Baqarah) at
  narrow and wide window sizes.

## 7. Components

### 7.1 Navigation

- Desktop (GNOME-first): sidebar or navigation rail, not a phone-style bottom bar.
- Active state is always redundant: green color + shape indicator (strip/pill) + label.
- Keyboard focus state: green outline, not just a background-color change.

### 7.2 Buttons

- Primary: `#166534` / white text. Hover: slightly darker (`#104E28`).
  Disabled: neutral gray that still reads as "disabled".
- Secondary and ghost follow §5. Minimum touch target 40px (desktop: precise
  clicks, but still comfortable).

### 7.3 Reading area and ayah highlights

- One verse = one block: number + Arabic text + translation, 12–16px padding,
  8px radius when highlighted.
- Active verse (navigation/last-read): highlight style from §5. Bookmarked verse:
  small icon, not a full-background change, so it does not compete with the highlight.
- Density: comfortable (default) and compact (optional) modes, both keeping
  Arabic `height` ≥ 1.8.

### 7.4 Surah list and search (later)

- Surah row: number in a light-green circle, Arabic name on the right, Latin name +
  metadata on the left. The whole row is clickable and keyboard-focusable.
- Search (Phase 4) uses the same input style; matches are highlighted with
  `primary-container`, not yellow.

### 7.5 Settings

- Theme choice: System / Light / Dark (radios with descriptions, not a hidden dropdown).
- Arabic font-size slider with live verse preview and numeric value.
- All preferences persist locally via `PreferencesRepository` and survive
  restarts (MVP criterion).

## 8. Flutter implementation (Phase 1 reference)

Target structure per `architecture.md`:

```text
lib/app/theme/
├── app_colors.dart      # §4 tokens (light and dark)
├── app_typography.dart  # §6 scale
├── app_theme.dart       # ThemeData light/dark, focus, components
└── theme_mode_store.dart # bridge to PreferencesRepository (System/Light/Dark)
```

Implementation rules:

1. Define the `ColorScheme` manually from the §4 tokens — do **not** rely on the
   default `ColorScheme.fromSeed` (the demo purple seed must be removed).
2. Separate `ThemeData(useMaterial3: true)` for light and dark; do not
   auto-invert the light scheme for dark mode.
3. Expose the Arabic font scale as a `ValueNotifier`/state read by the reader and
   stored as a preference (20–40sp range, 2sp steps).
4. Reader widgets read colors from `Theme.of(context).colorScheme`, not hard-coded
   hex in each widget, so theme audits stay in one place.
5. Add widget tests: primary button, active nav, and ayah highlight render in both
   modes; golden tests are optional, semantic tests (documented token contrast +
   visible focus) are required.

Indicative code direction (illustration, not final):

```dart
const primaryGreen = Color(0xFF166534);
const paperWhite = Color(0xFFFFFFFF);
const paleGreen = Color(0xFFF0FDF4);
const deepGreen = Color(0xFF14532D);

final lightScheme = ColorScheme.light(
  primary: primaryGreen,
  onPrimary: paperWhite,
  primaryContainer: paleGreen,
  onPrimaryContainer: deepGreen,
  surface: paperWhite,
);

final darkScheme = ColorScheme.dark(
  primary: Color(0xFF4ADE80),
  onPrimary: Color(0xFF052E16),
  primaryContainer: deepGreen,
  onPrimaryContainer: Color(0xFFDCFCE7),
  surface: Color(0xFF0F2A1C),
);
```

## 9. Theme acceptance criteria

In addition to the general criteria in `ACCEPTANCE_CRITERIA.md`, the theme is
done when:

- [ ] Light/dark/system modes can be selected and persist across restarts.
- [ ] No demo purple hex / `deepPurple` remains in theme code.
- [ ] All MVP screens (index, reader, bookmarks, settings, source credits) are
      legible in both modes with no missing or glaring text.
- [ ] Ayah highlights and last-read markers are distinguishable from bookmarks at a glance.
- [ ] The six color pairs in §4.3 have recorded contrast ratios (tool + test date).
- [ ] Arabic font sizes 20–40sp cause no harakat clipping or verse-number overlap.
- [ ] Keyboard focus is visible on all interactive controls in both modes.
- [ ] Narrow (±640px) and wide (±1280px) windows do not clip core controls.

## 10. Roadmap-aligned work steps

1. **Phase 1 — foundation:** create `lib/app/theme/`, remove the demo theme, store
   `ThemeMode` + font size via `PreferencesRepository`, add theme widget tests.
2. **Phase 2 — reader:** apply tokens to the surah index, reader, ayah highlights,
   bookmarks, last-read, and source-credits view.
3. **Phase 3 — stabilization:** contrast + keyboard + screen-reader audit,
   long-surah scroll profiling, document known limitations.
4. **Phase 4+:** search reuses the same highlight style; Android reuses tokens
   with navigation-only adaptations.

## 11. Open questions

- Final Arabic and Latin fonts + redistribution license (pending Phase 0 font ADR).
- Final hex values for derived tokens (`text-secondary`, `outline`, dark accent
  `#4ADE80`) — the numbers in this document are initial proposals and must be
  replaced with measured contrast results.
- Islamic illustrations/ornaments (e.g. surah frames): may be proposed separately,
  but the core verse area stays plain per §3.3.
- "Follow GNOME system theme" behavior inside Flatpak (needs Phase 0/1 technical validation).
