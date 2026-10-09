import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/content_manifest.dart';
import '../../domain/repositories/quran_content_repository.dart';
import '../reader/reader_providers.dart';

/// Source, edition, and rights information (PRD P0 requirement).
///
/// Shows the live seeded manifest when content is available, otherwise the
/// pending-gate state. Static sections document the cleared data-source
/// terms so the information exists before — and independently of — the
/// first bundled dataset.
class CreditsPage extends ConsumerWidget {
  const CreditsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final QuranContentRepository? content = ref.watch(quranContentProvider);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('About & Sources', style: theme.textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(
          'Alquran is a free, open-source, offline-first Quran reader for '
          'Linux. No accounts, no analytics, no ads — reading works without '
          'a network connection.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        Text('Quran content', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        if (content == null)
          const _PendingContent()
        else
          FutureBuilder<ContentManifest>(
            future: content.getManifest(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              final ContentManifest? manifest = snapshot.data;
              if (manifest == null) {
                return const _PendingContent();
              }
              return _ManifestCard(manifest: manifest);
            },
          ),
        const SizedBox(height: 24),
        Text('Text sources & rights', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        const _SourceRow(
          title: 'Arabic text — Tanzil Project (tanzil.net)',
          detail:
              'Uthmani v1.1. CC-BY 3.0, verbatim copies with attribution '
              'and link. Text is never modified by this app.',
        ),
        const _SourceRow(
          title: 'Indonesian translation — QuranEnc (quranenc.com)',
          detail:
              'Republished under QuranEnc terms: no changes, publisher '
              'credit, version stated, updates tracked, no inappropriate ads.',
        ),
        const _SourceRow(
          title: 'Quran Foundation API — not bundled',
          detail:
              'Standard terms permit display only: no prepackaged '
              'database without a separate license. This app ships no QF '
              'content.',
        ),
        const _SourceRow(
          title: 'Fonts — pending final choice (ADR-0002)',
          detail:
              'Candidates Amiri, Scheherazade New, Noto Naskh Arabic, '
              'all SIL OFL 1.1 with license texts shipped alongside.',
        ),
        const _SourceRow(
          title: 'App code license — proposed MIT (ADR-0007)',
          detail:
              'Pending owner approval. Content, fonts, and dependencies '
              'keep their own licenses listed above.',
        ),
      ],
    );
  }
}

class _PendingContent extends StatelessWidget {
  const _PendingContent();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'No approved content bundle is installed in this build. Source, '
          'edition, version, and checksums will be listed here once the '
          'cleared dataset is seeded (see docs/translation-clearance.md).',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}

class _ManifestCard extends StatelessWidget {
  const _ManifestCard({required this.manifest});

  final ContentManifest manifest;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    String short(String sha) =>
        sha.length > 12 ? '${sha.substring(0, 12)}…' : sha;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _line(
              theme,
              'Arabic',
              '${manifest.arabicSource} · '
                  '${manifest.arabicEdition} · ${short(manifest.arabicSha256)}',
            ),
            _line(
              theme,
              'Translation',
              '${manifest.translationEditionId} · '
                  'v${manifest.translationVersion} · '
                  '${short(manifest.translationSha256)}',
            ),
            _line(theme, 'Validation', manifest.validationReportRef),
          ],
        ),
      ),
    );
  }

  Widget _line(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: value),
          ],
        ),
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({required this.title, required this.detail});

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleSmall),
          const SizedBox(height: 2),
          Text(detail, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
