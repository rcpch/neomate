// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

class ClinicalChecklist {
  const ClinicalChecklist({
    required this.id,
    required this.title,
    required this.summary,
    required this.sections,
  });

  final String id;
  final String title;
  final String summary;
  final List<ClinicalChecklistSection> sections;
}

class ClinicalChecklistSection {
  const ClinicalChecklistSection({required this.title, required this.items});

  final String title;
  final List<ClinicalChecklistItem> items;
}

class ClinicalChecklistItem {
  const ClinicalChecklistItem({required this.id, required this.text});

  final String id;
  final String text;
}
