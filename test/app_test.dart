// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/app/neomate_app.dart';

void main() {
  testWidgets('shows the native rebuild status', (tester) async {
    await tester.pumpWidget(const NeomateApp());

    expect(find.text('Neomate'), findsOneWidget);
    expect(find.text('Native rebuild in progress'), findsOneWidget);
    expect(
        find.textContaining('not approved for clinical use'), findsOneWidget);
    expect(find.text('Calculators'), findsOneWidget);
    expect(find.text('Clinical guidance'), findsOneWidget);
    expect(find.textContaining('Offline by design'), findsOneWidget);
  });

  for (final surface in {
    'phone': const Size(390, 844),
    'desktop': const Size(1280, 800),
  }.entries) {
    testWidgets('renders without overflow on ${surface.key}', (tester) async {
      await tester.binding.setSurfaceSize(surface.value);
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(const NeomateApp());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Neomate'), findsOneWidget);
      expect(find.text('References'), findsOneWidget);
    });
  }
}
