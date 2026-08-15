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
    expect(find.text('Alpha demo'), findsNWidgets(2));
    expect(find.textContaining('Offline by design'), findsOneWidget);
  });

  testWidgets('opens the native physiology calculator and updates results',
      (tester) async {
    await tester.pumpWidget(const NeomateApp());

    final calculators = find.byKey(const Key('destination-calculators'));
    await tester.ensureVisible(calculators);
    await tester.tap(calculators);
    await tester.pumpAndSettle();
    expect(find.text('Native calculation demos'), findsOneWidget);

    await tester.ensureVisible(find.text('Physiology and fluids'));
    await tester.tap(find.text('Physiology and fluids'));
    await tester.pumpAndSettle();
    expect(find.text('Internal alpha - demonstration only'), findsOneWidget);
    await tester.drag(
      find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable && widget.axisDirection == AxisDirection.down,
      ),
      const Offset(0, -900),
    );
    await tester.pumpAndSettle();
    final resultsHeading = find.byKey(const Key('calculated-results-heading'));
    expect(resultsHeading, findsOneWidget);
    expect(find.text('Oxygenation index'), findsOneWidget);
    expect(find.text('Glucose infusion rate'), findsOneWidget);

    await tester.drag(
      find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable && widget.axisDirection == AxisDirection.down,
      ),
      const Offset(0, 900),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('weight-field')), '100');
    await tester.pump();
    await tester.drag(
      find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable && widget.axisDirection == AxisDirection.down,
      ),
      const Offset(0, -900),
    );
    await tester.pumpAndSettle();
    expect(find.text('Weight must be between 200 and 6000 g.'), findsOneWidget);
  });

  testWidgets('enforces infusion concentration and access controls',
      (tester) async {
    await tester.pumpWidget(const NeomateApp());

    final calculators = find.byKey(const Key('destination-calculators'));
    await tester.ensureVisible(calculators);
    await tester.tap(calculators);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Cardiac infusions'));
    await tester.tap(find.text('Cardiac infusions'));
    await tester.pumpAndSettle();

    expect(find.text('45000.0 micrograms in syringe'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('dose-field')), '20');
    await tester.pump();
    expect(
      find.textContaining('exceeds the inherited maximum concentration'),
      findsOneWidget,
    );
  });

  testWidgets('opens source and sign-off status', (tester) async {
    await tester.pumpWidget(const NeomateApp());

    final references = find.byKey(const Key('destination-references'));
    await tester.drag(find.byType(Scrollable), const Offset(0, -500));
    await tester.pumpAndSettle();
    await tester.tap(references);
    await tester.pumpAndSettle();
    expect(find.text('Clinical source register'), findsOneWidget);
    await tester.drag(
      find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable && widget.axisDirection == AxisDirection.down,
      ),
      const Offset(0, -900),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('0 of 16'), findsOneWidget);
    expect(find.textContaining('SRC-006'), findsOneWidget);
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

  for (final surface in {
    'calculator phone': const Size(390, 844),
    'calculator desktop': const Size(1280, 800),
  }.entries) {
    testWidgets('calculator workflow renders on ${surface.key}',
        (tester) async {
      await tester.binding.setSurfaceSize(surface.value);
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(const NeomateApp());
      final calculators = find.byKey(const Key('destination-calculators'));
      await tester.ensureVisible(calculators);
      await tester.tap(calculators);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Physiology and fluids'));
      await tester.tap(find.text('Physiology and fluids'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      await tester.drag(
        find.byWidgetPredicate(
          (widget) =>
              widget is Scrollable &&
              widget.axisDirection == AxisDirection.down,
        ),
        const Offset(0, -900),
      );
      await tester.pumpAndSettle();
      expect(find.text('Mean airway pressure'), findsOneWidget);
    });
  }
}
