// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../clinical_policy/retired_bolus_policy.dart';
import '../shared/alpha_notice.dart';

class ClinicalChangeLogScreen extends StatelessWidget {
  const ClinicalChangeLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clinical change log')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: retiredBolusAlgorithms.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AlphaNotice(compact: true),
                SizedBox(height: 20),
                Text(
                  'Retired clinical algorithms',
                  style: TextStyle(
                    color: Color(0xff153e33),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'These outputs are unavailable because they do not align with current clinical guidance. Their retirement rationale and evidence are recorded below.',
                ),
              ],
            );
          }
          return _RetirementCard(retirement: retiredBolusAlgorithms[index - 1]);
        },
      ),
    );
  }
}

class _RetirementCard extends StatelessWidget {
  const _RetirementCard({required this.retirement});

  final RetiredClinicalAlgorithm retirement;

  @override
  Widget build(BuildContext context) {
    final date = retirement.retiredOn.toIso8601String().substring(0, 10);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              retirement.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xff153e33),
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 4),
            Text('Removed $date · ${retirement.id}'),
            const SizedBox(height: 14),
            const Text(
              'Retired output',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(retirement.retiredOutput),
            const SizedBox(height: 12),
            const Text(
              'Reason for removal',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(retirement.reason),
            const SizedBox(height: 14),
            _EvidenceLink(
              title: retirement.authorityTitle,
              url: retirement.authorityUrl,
            ),
            if (retirement.supportingEvidenceTitle case final title?) ...[
              const SizedBox(height: 12),
              _EvidenceLink(
                title: title,
                url: retirement.supportingEvidenceUrl!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EvidenceLink extends StatelessWidget {
  const _EvidenceLink({required this.title, required this.url});

  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        SelectableText(
          url,
          style: const TextStyle(
            color: Color(0xff125743),
            decoration: TextDecoration.underline,
          ),
        ),
        const SizedBox(height: 4),
        TextButton.icon(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: url));
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Evidence URL copied')),
            );
          },
          icon: const Icon(Icons.copy_outlined),
          label: const Text('Copy evidence URL'),
        ),
      ],
    );
  }
}
