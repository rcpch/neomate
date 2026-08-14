// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Tests for rounding and display of calculated numbers.
//
// The rounds-to-zero test is the clinically important one: a small but real
// dose must never be presented as "0.00", because that reads as "give
// nothing".

import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/calculations/calculation_outcome.dart';
import 'package:neomate2/calculations/result_rounding.dart';

void main() {
  group('rounding for display', () {
    test('rounds to the requested number of decimal places', () {
      final result = roundForDisplay(value: 6.6666666, decimalPlaces: 2)
          as CalculationValue<RoundedResult>;

      expect(result.value.value, closeTo(6.67, 1e-9));
      expect(result.value.text, '6.67');
    });

    test('keeps trailing zeros so precision is shown consistently', () {
      // "2.50" and "2.5" on different screens invite a misread.
      final result = roundForDisplay(value: 2.5, decimalPlaces: 2)
          as CalculationValue<RoundedResult>;

      expect(result.value.text, '2.50');
    });

    test('rounds a half away from zero, as a clinician would by hand', () {
      final up = roundForDisplay(value: 2.5, decimalPlaces: 0)
          as CalculationValue<RoundedResult>;
      final down = roundForDisplay(value: 2.4, decimalPlaces: 0)
          as CalculationValue<RoundedResult>;

      expect(up.value.text, '3');
      expect(down.value.text, '2');
    });

    test('never uses exponent notation for very small values', () {
      // 0.000004 prints as "4e-6" via toString, which is not a drawable
      // volume. It must appear in plain decimal form.
      final result = roundForDisplay(value: 0.000004, decimalPlaces: 6)
          as CalculationValue<RoundedResult>;

      expect(result.value.text, isNot(contains('e')));
      expect(result.value.text, '0.000004');

      // Dart switches to exponent notation for large magnitudes too, where
      // "1e+21" would be unreadable as a volume or a dose.
      final large = roundForDisplay(value: 1e21, decimalPlaces: 0)
          as CalculationValue<RoundedResult>;

      expect(1e21.toString(), contains('e'));
      expect(large.value.text, isNot(contains('e')));
    });

    test('refuses a non-zero value that would round away to zero', () {
      // 0.004 mL at 2 decimal places would display as "0.00".
      final result = roundForDisplay(value: 0.004, decimalPlaces: 2)
          as CalculationRejected<RoundedResult>;

      expect(result.issue, CalculationIssue.inputOutOfRange);
    });

    test('displays a genuine zero', () {
      final result = roundForDisplay(value: 0, decimalPlaces: 2)
          as CalculationValue<RoundedResult>;

      expect(result.value.text, '0.00');
    });

    test('refuses a negative or excessive precision', () {
      final negative = roundForDisplay(value: 1.5, decimalPlaces: -1)
          as CalculationRejected<RoundedResult>;
      final excessive = roundForDisplay(value: 1.5, decimalPlaces: 7)
          as CalculationRejected<RoundedResult>;

      expect(negative.issue, CalculationIssue.inputOutOfRange);
      expect(excessive.issue, CalculationIssue.inputOutOfRange);
    });

    test('refuses non-finite values', () {
      final notANumber = roundForDisplay(value: double.nan, decimalPlaces: 2)
          as CalculationRejected<RoundedResult>;
      final infinite = roundForDisplay(value: double.infinity, decimalPlaces: 2)
          as CalculationRejected<RoundedResult>;

      expect(notANumber.issue, CalculationIssue.notFinite);
      expect(infinite.issue, CalculationIssue.notFinite);
    });

    test('rounded value and displayed text always agree', () {
      // Guards against the number shown differing from the number returned.
      for (final value in <double>[0.125, 1.005, 9.999, 123.456, 0.05]) {
        for (final places in <int>[0, 1, 2, 3]) {
          final outcome = roundForDisplay(value: value, decimalPlaces: places);
          if (outcome is CalculationValue<RoundedResult>) {
            expect(
              outcome.value.text,
              outcome.value.value.toStringAsFixed(places),
              reason: 'Text and value disagree for $value at $places places',
            );
          }
        }
      }
    });
  });
}
