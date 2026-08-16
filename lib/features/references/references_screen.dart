// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import '../shared/alpha_notice.dart';

class ReferencesScreen extends StatelessWidget {
  const ReferencesScreen({super.key});

  static const _sources = [
    (
      id: 'SRC-001',
      title: 'BAPM neonatal hypoglycaemia framework',
      status: 'Proposed',
      use: 'Glucose infusion rate formula',
    ),
    (
      id: 'SRC-002',
      title: 'NICE NG154 neonatal parenteral nutrition',
      status: 'Proposed',
      use: 'Fluid and electrolyte calculation context',
    ),
    (
      id: 'SRC-006',
      title: 'Inherited Neomate implementation',
      status: 'Inherited baseline',
      use: 'Current alpha protocol values and engineering bounds',
    ),
    (
      id: 'SRC-008',
      title: 'BNF for Children',
      status: 'Candidate - current edition pending',
      use: 'Medicine doses and concentration limits',
    ),
    (
      id: 'SRC-009',
      title: 'Injectable Medicines Guide (Medusa)',
      status: 'Candidate - current edition pending',
      use: 'Infusion preparation advice',
    ),
    (
      id: 'SRC-010',
      title: 'BAPM Neonatal Airway Safety Standard',
      status: 'Candidate - applicability review pending',
      use: 'Airway safety and placement-confirmation controls',
    ),
    (
      id: 'SRC-011',
      title: 'BAPM central venous access framework',
      status: 'Candidate - applicability review pending',
      use: 'Umbilical venous access and tip-confirmation controls',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('References and review status')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const AlphaNotice(compact: true),
          const SizedBox(height: 20),
          Text(
            'Clinical source register',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: const Color(0xff153e33),
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Sources listed here are proposed or inherited. None constitutes clinical approval for this alpha.',
          ),
          const SizedBox(height: 18),
          for (final source in _sources)
            Card(
              child: ListTile(
                minTileHeight: 92,
                leading: CircleAvatar(
                  backgroundColor: const Color(0xffe8f3ef),
                  foregroundColor: const Color(0xff125743),
                  child: Text(source.id.substring(4)),
                ),
                title: Text(
                  '${source.id} · ${source.title}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text('${source.status}\n${source.use}'),
                isThreeLine: true,
              ),
            ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xfff1f5f3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Clinical sign-off: 0 of 20 reviewable files approved. Engineering tests demonstrate implementation behavior only and do not replace independent clinical review.',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
