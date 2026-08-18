// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import '../../clinical_content/checklists/checklist.dart';
import '../../clinical_content/checklists/checklist_catalogue.dart';
import '../shared/alpha_notice.dart';

class ChecklistsScreen extends StatelessWidget {
  const ChecklistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checklists')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const AlphaNotice(),
          const SizedBox(height: 20),
          Text('Clinical checklists',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          const Text(
              'Select a checklist to review its structure and wording. Completion state lasts only while the checklist is open.'),
          const SizedBox(height: 16),
          for (final checklist in clinicalChecklists)
            Card(
              child: ListTile(
                key: Key('checklist-${checklist.id}'),
                minTileHeight: 88,
                leading: const Icon(Icons.checklist_outlined,
                    color: Color(0xff176c55)),
                title: Text(checklist.title,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(checklist.summary),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (_) =>
                        ChecklistDetailScreen(checklist: checklist))),
              ),
            ),
        ],
      ),
    );
  }
}

class ChecklistDetailScreen extends StatefulWidget {
  const ChecklistDetailScreen({required this.checklist, super.key});

  final ClinicalChecklist checklist;

  @override
  State<ChecklistDetailScreen> createState() => _ChecklistDetailScreenState();
}

class _ChecklistDetailScreenState extends State<ChecklistDetailScreen> {
  final Set<String> _completed = {};

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.checklist.sections
        .fold<int>(0, (total, section) => total + section.items.length);
    return Scaffold(
      appBar: AppBar(title: Text(widget.checklist.title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const AlphaNotice(compact: true),
          const SizedBox(height: 16),
          Text(widget.checklist.summary,
              style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          Text('${_completed.length} of $itemCount reviewed',
              key: const Key('checklist-progress'),
              style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          for (final section in widget.checklist.sections) ...[
            Semantics(
                header: true,
                child: Text(section.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xff153e33),
                        fontWeight: FontWeight.w800))),
            const SizedBox(height: 6),
            for (final item in section.items)
              Card(
                child: CheckboxListTile(
                  key: Key('checklist-item-${item.id}'),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(item.text),
                  value: _completed.contains(item.id),
                  onChanged: (checked) => setState(() {
                    checked == true
                        ? _completed.add(item.id)
                        : _completed.remove(item.id);
                  }),
                ),
              ),
            const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}
