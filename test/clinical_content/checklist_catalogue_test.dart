// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/clinical_content/checklists/checklist_catalogue.dart';

void main() {
  test('checklist catalogue has stable unique IDs and non-empty content', () {
    expect(clinicalChecklists, hasLength(10));
    expect(
      clinicalChecklists.map((checklist) => checklist.id).toSet(),
      hasLength(clinicalChecklists.length),
    );

    for (final checklist in clinicalChecklists) {
      expect(checklist.title.trim(), isNotEmpty);
      expect(checklist.summary.trim(), isNotEmpty);
      expect(checklist.sections, isNotEmpty);
      final items =
          checklist.sections.expand((section) => section.items).toList();
      expect(items, isNotEmpty);
      expect(items.map((item) => item.id).toSet(), hasLength(items.length));
      expect(items.every((item) => item.text.trim().isNotEmpty), isTrue);
      expect(
        items.every(
          (item) => !item.text.contains(RegExp(r'</?[a-zA-Z][^>]*>')),
        ),
        isTrue,
      );
    }
  });
}
