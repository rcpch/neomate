// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/app/neomate_app.dart';
import 'package:neomate2/features/calculators/airway_and_lines_screen.dart';
import 'package:neomate2/features/calculators/named_infusions_screen.dart';
import 'package:neomate2/features/home/home_screen.dart';
import 'package:neomate2/features/references/clinical_change_log_screen.dart';

void main() {
  testWidgets('shows the clinical approval status', (tester) async {
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
    expect(find.text('Not approved for clinical use'), findsOneWidget);
    expect(
        find.textContaining('Not approved for clinical use'), findsOneWidget);
    expect(find.byKey(const Key('home-weight-field')), findsOneWidget);
    expect(find.text('Calculators'), findsOneWidget);
    expect(find.text('Clinical tasks'), findsOneWidget);
    expect(find.text('Cardiac drugs'), findsOneWidget);
    expect(find.text('Calculations available'), findsWidgets);
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
    expect(find.text('Named infusions'), findsOneWidget);
    expect(find.textContaining('Estimated weight:'), findsOneWidget);
  });

  testWidgets('opens the native physiology calculator and updates results',
      (tester) async {
    await tester.pumpWidget(const NeomateApp());

    final calculators = find.byKey(const Key('destination-calculators'));
    await tester.ensureVisible(calculators);
    await tester.tap(calculators);
    await tester.pumpAndSettle();
    expect(find.text('Clinical calculators'), findsOneWidget);

    await tester.ensureVisible(find.text('Physiology and fluids'));
    await tester.tap(find.text('Physiology and fluids'));
    await tester.pumpAndSettle();
    expect(find.text('Not approved for clinical use'), findsOneWidget);
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

  testWidgets('shows infusion constraint advisories without blocking results',
      (tester) async {
    await tester.pumpWidget(const NeomateApp());

    final calculators = find.byKey(const Key('destination-calculators'));
    await tester.ensureVisible(calculators);
    await tester.tap(calculators);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Named infusions'));
    await tester.tap(find.text('Named infusions'));
    await tester.pumpAndSettle();

    expect(find.text('45000.0 micrograms in syringe'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('dose-field')), '20');
    await tester.pump();
    expect(find.text('90000.0 micrograms in syringe'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -350));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('exceeds the configured maximum concentration'),
      findsOneWidget,
    );
  });

  testWidgets('labels paralysis separately from sedation', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: NamedInfusionsScreen(
          initialInfusion: NamedInfusion.vecuronium,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Named infusions'), findsOneWidget);
    expect(
      find.textContaining('Vecuronium causes paralysis'),
      findsOneWidget,
    );
    expect(find.textContaining('does not provide analgesia or sedation'),
        findsOneWidget);
  });

  testWidgets('surfaces the clonazepam concentration conflict', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: NamedInfusionsScreen(
          initialInfusion: NamedInfusion.clonazepam,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Configured range: 10-40'), findsOneWidget);
    expect(
      find.textContaining('default preparation exceeds this ceiling'),
      findsOneWidget,
    );
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(find.text('1500.0 micrograms in syringe'), findsOneWidget);
    expect(
      find.textContaining('exceeds the configured maximum concentration'),
      findsOneWidget,
    );
  });

  testWidgets('calculates electrolyte requirement and stock volume',
      (tester) async {
    await tester.pumpWidget(const NeomateApp());

    await tester.tap(find.byKey(const Key('destination-calculators')));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, -350));
    await tester.pumpAndSettle();
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

  testWidgets('shows airway and line aids with confirmation warnings',
      (tester) async {
    await tester.pumpWidget(const NeomateApp());

    await tester.tap(find.byKey(const Key('destination-calculators')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Airway and umbilical lines'));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byKey(const Key('ett-size-result')),
        matching: find.textContaining('3.5-4.0', findRichText: true),
      ),
      findsOneWidget,
    );
    expect(find.textContaining('Confirm tube size'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byKey(const Key('uvc-result')),
        matching: find.textContaining('10.0', findRichText: true),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('uac-result')),
        matching: find.textContaining('18.0', findRichText: true),
      ),
      findsOneWidget,
    );
    expect(find.textContaining('confirm final tip position'), findsOneWidget);
  });

  testWidgets('opens source and sign-off status', (tester) async {
    await tester.pumpWidget(const NeomateApp());

    final references = find.byKey(const Key('destination-references'));
    await tester.tap(references);
    await tester.pumpAndSettle();
    expect(find.text('Clinical source register'), findsOneWidget);
    await tester.tap(find.byKey(const Key('clinical-change-log-button')));
    await tester.pumpAndSettle();
    expect(find.text('Retired clinical algorithms'), findsOneWidget);
    expect(
      find.text('Sodium bicarbonate during newborn resuscitation'),
      findsOneWidget,
    );
    expect(
        find.textContaining('RCUK 2025 no longer recommends'), findsOneWidget);
    expect(find.textContaining('https://www.resus.org.uk/'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const Key('clinical-signoff-summary')),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(
        find.textContaining('currently clinically approved'), findsOneWidget);
    expect(find.textContaining('SRC-011'), findsOneWidget);
  });

  testWidgets('opens and completes a clinical checklist', (tester) async {
    await tester.pumpWidget(const NeomateApp());

    await tester.tap(find.byKey(const Key('destination-checklists')));
    await tester.pumpAndSettle();
    expect(find.text('Clinical checklists'), findsOneWidget);
    expect(find.text('Referral for transport'), findsOneWidget);

    await tester.tap(find.text('Referral for transport'));
    await tester.pumpAndSettle();
    expect(find.text('0 of 9 reviewed'), findsOneWidget);

    await tester.tap(find.byKey(const Key('checklist-item-transport-1')));
    await tester.pump();
    expect(find.text('1 of 9 reviewed'), findsOneWidget);
  });

  testWidgets('opens named bolus values for review', (tester) async {
    await tester.pumpWidget(const NeomateApp());

    final boluses = find.byKey(const Key('task-medicine-boluses'));
    await tester.scrollUntilVisible(
      boluses,
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(boluses);
    await tester.pumpAndSettle();

    expect(find.text('Medicine boluses'), findsOneWidget);
    expect(find.textContaining('15.0\nmicrograms'), findsOneWidget);
    expect(find.textContaining('Retired resuscitation bicarbonate'),
        findsOneWidget);
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
      expect(find.text('Not approved for clinical use'), findsOneWidget);
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

  testWidgets('home and airway aids support 200 percent text scaling on phone',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(2)),
        child: NeomateApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(2)),
        child: MaterialApp(home: AirwayAndLinesScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Intubation and airway'), findsOneWidget);

    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(2)),
        child: MaterialApp(
          home: NamedInfusionsScreen(
            initialInfusion: NamedInfusion.vecuronium,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Named infusions'), findsOneWidget);

    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(2)),
        child: MaterialApp(home: ClinicalChangeLogScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Clinical change log'), findsOneWidget);
  });

  testWidgets('airway aids distinguish invalid and unavailable results',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: AirwayAndLinesScreen()),
    );

    final weightField = find.byKey(const Key('airway-lines-weight-field'));
    await tester.enterText(weightField, '199');
    await tester.pump();

    expect(find.text('Weight must be between 200 and 6000 g.'), findsOneWidget);
    expect(find.byKey(const Key('ett-size-result')), findsNothing);

    await tester.enterText(weightField, '5000');
    await tester.pump();

    expect(find.text('Weight must be between 200 and 6000 g.'), findsNothing);
    expect(find.text('No configured value'), findsOneWidget);
    expect(find.byKey(const Key('uvc-result')), findsOneWidget);
  });
}
