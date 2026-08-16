// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/app/neomate_app.dart';
import 'package:neomate2/features/home/home_screen.dart';

void main() {
  testWidgets('shows the native rebuild status', (tester) async {
    await tester.pumpWidget(const NeomateApp());

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                'graphics/neomate-logo.gif',
      ),
      findsOneWidget,
    );
    expect(
      Theme.of(tester.element(find.byType(HomeScreen)))
          .textTheme
          .bodyMedium
          ?.fontFamily,
      'Lato',
    );
    expect(find.text('Native rebuild in progress'), findsOneWidget);
    expect(
        find.textContaining('Not approved for clinical use'), findsOneWidget);
    expect(find.byKey(const Key('home-weight-field')), findsOneWidget);
    expect(find.text('Calculators'), findsOneWidget);
    expect(find.text('Clinical tasks'), findsOneWidget);
    expect(find.text('Cardiac drugs'), findsOneWidget);
    expect(find.text('Alpha actions available'), findsWidgets);
    expect(find.textContaining('Offline by design'), findsOneWidget);
  });

  testWidgets('passes the workspace weight into a grouped cardiac workflow',
      (tester) async {
    await tester.pumpWidget(const NeomateApp());

    await tester.enterText(find.byKey(const Key('home-weight-field')), '2500');
    await tester.tap(find.text('Estimated weight'));
    await tester.pump();
    final cardiacInfusions = find.byKey(const Key('task-cardiac-infusions'));
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -450));
    await tester.pumpAndSettle();
    await tester.tap(cardiacInfusions);
    await tester.pumpAndSettle();

    final field = tester.widget<TextField>(
      find.descendant(
        of: find.byKey(const Key('infusion-weight-field')),
        matching: find.byType(TextField),
      ),
    );
    expect(field.controller?.text, '2500');
    expect(find.text('Cardiac infusions'), findsOneWidget);
    expect(find.textContaining('Estimated weight:'), findsOneWidget);
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

  testWidgets('calculates electrolyte requirement and stock volume',
      (tester) async {
    await tester.pumpWidget(const NeomateApp());

    await tester.tap(find.byKey(const Key('destination-calculators')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Electrolytes and compounding'));
    await tester.tap(find.text('Electrolytes and compounding'));
    await tester.pumpAndSettle();

    expect(find.text('9.0 mmol/day'), findsOneWidget);
    expect(find.textContaining('Draw up 9.0 mL'), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('stock-concentration-field')),
      '0',
    );
    await tester.pump();
    expect(find.textContaining('stock volume is invalid'), findsOneWidget);
  });

  testWidgets('opens source and sign-off status', (tester) async {
    await tester.pumpWidget(const NeomateApp());

    final references = find.byKey(const Key('destination-references'));
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
      expect(find.text('Native rebuild in progress'), findsOneWidget);
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
