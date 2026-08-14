// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/clinical_content/clinical_artifact.dart';
import 'package:neomate2/clinical_content/content_document.dart';
import 'package:neomate2/clinical_content/provenance.dart';
import 'package:neomate2/features/content/clinical_content_view.dart';

void main() {
  final reviewedOn = DateTime.utc(2026, 8, 14);
  final content = ClinicalContent(
    id: 'CONTENT-SYNTHETIC',
    title: 'Synthetic clinical content',
    version: '1.2.3',
    sourceIds: const ['SRC-SYNTHETIC'],
    hazardIds: const ['HZ-SYNTHETIC'],
    applicability: const ClinicalApplicability(
      population: 'Synthetic population',
      intendedUsers: 'Synthetic users',
      careSetting: 'Synthetic setting',
      exclusions: [],
    ),
    reviewWindow: ReviewWindow(
      reviewedOn: reviewedOn,
      reviewDueOn: DateTime.utc(2027, 8, 14),
    ),
    signOffs: [
      ClinicalSignOff(
        reviewer: 'Dr Example Reviewer',
        role: 'Clinical reviewer',
        decision: SignOffDecision.approved,
        signedOn: reviewedOn,
      ),
    ],
    summary: 'Synthetic summary.',
    document: const ClinicalContentDocument(
      blocks: [
        ClinicalHeading(text: 'Assessment'),
        ClinicalParagraph('Synthetic paragraph.'),
        ClinicalBulletList(
            items: ['First synthetic item', 'Second synthetic item']),
        ClinicalCallout(
          kind: ClinicalCalloutKind.urgent,
          title: 'Synthetic urgent warning',
          message: 'Synthetic warning message.',
        ),
      ],
    ),
  );

  testWidgets('renders native typed content and review metadata',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: ClinicalContentView(content: content))),
    );

    expect(find.text('Synthetic clinical content'), findsOneWidget);
    expect(
        find.text(
            'Version 1.2.3 · Reviewed 2026-08-14 · Review due 2027-08-14'),
        findsOneWidget);
    expect(find.text('Assessment'), findsOneWidget);
    expect(find.text('Synthetic paragraph.'), findsOneWidget);
    expect(find.text('First synthetic item'), findsOneWidget);
    expect(find.text('Synthetic urgent warning'), findsOneWidget);
  });

  testWidgets('marks titles, headings, and callouts for assistive technology',
      (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: ClinicalContentView(content: content))),
    );

    expect(
      tester
          .getSemantics(find.text('Synthetic clinical content'))
          .getSemanticsData()
          .flagsCollection
          .isHeader,
      isTrue,
    );
    expect(
      tester
          .getSemantics(find.text('Assessment'))
          .getSemanticsData()
          .flagsCollection
          .isHeader,
      isTrue,
    );
    await tester.scrollUntilVisible(find.text('Synthetic urgent warning'), 200);
    await tester.pump();
    expect(find.bySemanticsLabel(RegExp('urgent callout')), findsOneWidget);

    semantics.dispose();
  });
}
