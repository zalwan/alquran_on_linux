# Translation Clearance — QuranEnc Path + LPMQ Fallback

> Operational follow-up to Phase 0 blocking question 1 (see
> `docs/phase-0-report.md` §6 and `docs/data-sources.md` §2.6). Phase 2
> content work must not start until the checklist in §1 is fully signed off,
> or written LPMQ permission (§2) is obtained.
>
> Owner decision 2026-10-09 (Option 1): v1.0 ships **Arabic-only**; the
> translation checklist below now gates **v1.1**. The seed pipeline,
> validator, manifest, and credits view support translation-less datasets,
> and adding the cleared translation later must preserve user state.

## 1. QuranEnc edition-confirmation checklist

Source grant (verified 2026-10-09): translations may be downloaded and
re-published with (1) no modification/addition/deletion, (2) publisher +
source credit, (3) version number stated, (4) transcript info kept,
(5) notes reported to source, (6) update to latest source version,
(7) no inappropriate ads. Source: <https://quranenc.com/en/home>
("Terms and Policies") and API docs <https://quranenc.com/en/home/api/>.

- [x] 1. List Indonesian editions: `GET
      https://quranenc.com/api/v1/translations/list/id` — evaluated
      2026-10-09, three entries (see evidence below).
- [x] 2. Choose exactly one edition: **`indonesian_affairs` (Ministry of
      Religious Affairs, v1.0.1)** — direct Ministry lineage matching the
      LPMQ fallback story; most recently revised of the Ministry-issued
      options. `indonesian_complex` (The Complex, v1.0.1) is the documented
      alternative; `indonesian_sabiq` (Sabiq Company, v1.1.3) rejected
      (non-governmental publisher, oldest revision).
- [ ] 3. Download via the documented endpoint (`/translation/sura/{key}/{n}`
      per surah or the bulk SQLite/CSV/XML dump, if its terms match); record
      the exact method + date. Never scrape HTML pages.
- [ ] 4. Compute SHA-256 of every acquired file; verify row counts (6,236
      translation rows expected — confirm against the edition, do not assume).
- [ ] 5. Run the full validation plan (`docs/data-sources.md` §3), including
      the orphan-row join check against the approved Arabic keys.
- [ ] 6. Fill the `ContentManifest` (translation key/version/sha256, license
      evidence = this checklist + grant URL, validation report reference).
- [ ] 7. Confirm the in-app credits view shows: translation title, publisher,
      version number, and "Source: QuranEnc.com".
- [ ] 8. Define the update check honoring condition (6): compare
      `last_update`/version on a documented cadence; document what happens
      when a newer version exists (re-acquire → re-validate → bump manifest).
      The local copy stays readable offline between checks.
- [ ] 9. Product owner signs off; attach this completed checklist to the
      validation report. Only then may the files enter `assets/`/seed data.

### Evidence for steps 1–2 (2026-10-09, API metadata + evaluation only)

| key | title | version | last_update (UTC) |
| --- | --- | --- | --- |
| `indonesian_sabiq` | Sabiq Company | 1.1.3 | 2025-06-02 |
| `indonesian_affairs` | Ministry of Religious Affairs | 1.0.1 | 2025-06-23 |
| `indonesian_complex` | The Complex | 1.0.1 | 2025-06-26 |

Evaluation download (per-surah API, edition `indonesian_affairs`, kept in
`/tmp` only — **never committed, never bundled**): 114/114 surahs, **6,236
rows, gapless ayah sequences, no surah mismatch**; row schema
`{arabic_text, aya, footnotes, id, sura, translation}`; combined SHA-256
`b057562e…ba82bee47`. Note: the API also returns per-row `arabic_text`,
but the Arabic source of record remains Tanzil Uthmani (ADR-0001) — the
QuranEnc Arabic is a cross-check at most. All three editions are ~16 months
old at evaluation time, so the condition-(6) update check in step 8 is
load-bearing, not ceremonial.

## 2. LPMQ written-permission request (fallback/alternative)

If the QuranEnc path falls through (no suitable edition, version staleness,
or term change), request written permission from Lajnah Pentashihan Mushaf
Al-Qur'an (Kemenag) to bundle the Indonesian translation of "Al-Qur'an dan
Terjemahannya Edisi Penyempurnaan 2019". Send to the LPMQ contact listed on
<https://quran.kemenag.go.id/> / <https://quranindonesia.kemenag.go.id/>.
Do not ship the 2019 text without a written grant.

### 2a. Draft letter (Bahasa Indonesia)

> Yth. Kepala Lajnah Pentashihan Mushaf Al-Qur'an
> Badan Litbang dan Diklat Kementerian Agama RI
> di tempat
>
> Dengan hormat,
>
> Kami sedang mengembangkan **Alquran**, aplikasi pembaca Al-Qur'an
> **gratis, sumber terbuka, dan luring (offline-first)** untuk desktop Linux
> (ID aplikasi: `org.alquran.Reader`), tanpa iklan, tanpa akun, tanpa analitik,
> dan tanpa muatan komersial apa pun.
>
> Dengan ini kami memohon izin tertulis untuk menyertakan **terjemahan
> bahasa Indonesia "Al-Qur'an dan Terjemahannya Edisi Penyempurnaan 2019"**
> di dalam paket aplikasi tersebut, dengan ketentuan yang kami taati:
>
> 1. Teks terjemahan dimuat **verbatim, tanpa pengubahan, penambahan, atau
>    pengurangan** apa pun;
> 2. **Atribusi penuh** pada LPMQ/Kementerian Agama RI beserta edisi dan nomor
>    versi terjemahan, pada tampilan "Kredit & Sumber" di dalam aplikasi;
> 3. Teks Arab dan terjemahan **tidak diperjualbelikan** dan tidak
>    didistribusikan ulang sebagai dataset terpisah — hanya sebagai bagian
>    terpadu dari aplikasi pembaca;
> 4. Pembaruan mengikuti rilis resmi LPMQ; bila ada koreksi, kami memuat ulang
>    dari sumber resmi dan mencatat versinya.
>
> Sebagai bahan pertimbangan, ringkasan lisensi dan kebutuhan kami tercantum
> pada dokumen `docs/data-sources.md` repositori proyek. Kami bersedia
> memenuhi syarat tambahan yang Bapak/Ibu tetapkan, termasuk penarikan
> kembali apabila diperlukan.
>
> Atas perhatian dan kebijakannya kami ucapkan terima kasih.
>
> Hormat kami,
> [NAMA LENGKAP]
> Kontributor Alquran — [EMAIL] — [TANGGAL]

### 2b. Draft letter (English summary for the record)

> Subject: Written permission request to bundle the 2019 Indonesian Quran
> translation (LPMQ, Ministry of Religious Affairs) in a free, open-source,
> offline-first Linux Quran reader (`org.alquran.Reader`), with no ads,
> accounts, analytics, or commercial use. Commitments: verbatim text only;
> full attribution with edition/version in the in-app credits view; no resale
> or separate dataset redistribution; updates tracked from official LPMQ
> releases. Sender: [FULL NAME], Alquran contributor — [EMAIL] — [DATE].

## 3. Definition of done

One of: (a) §1 fully checked + signed, or (b) written LPMQ grant filed under
`docs/` (redact personal data before committing) + equivalent manifest
evidence. Until then, R1 stays open and no translation file enters the build.
