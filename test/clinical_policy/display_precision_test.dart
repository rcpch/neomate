// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Tests for the display precision policy, and for how it behaves when applied
// to real calculated values through the rounding module.

import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/calculations/calculation_outcome.dart';
import 'package:neomate2/calculations/result_rounding.dart';
import 'package:neomate2/clinical_policy/display_precision.dart';

void main() {
  group('display precision policy', () {
    test('fluid volumes and rates are shown to one decimal place', () {
      // No syringe dispenses more accurately than 0.1 mL.
      expect(fluidVolumeDecimalPlaces, 1);
      expect(fluidRateDecimalPlaces, 1);
      expect(additiveVolumeDecimalPlaces, 1);
    });

    test('a daily fluid rate displays as a drawable number', () {
      // 300 mL/day over 24 hours is 12.5 mL/hour.
      final result = roundForDisplay(
        value: 300 / 24,
        decimalPlaces: fluidRateDecimalPlaces,
      ) as CalculationValue<RoundedResult>;

      expect(result.value.text, '12.5');
    });

    test('a compounding volume displays to the nearest 0.1 mL', () {
      // 7.5 mmol from a 4 mmol/mL stock is 1.875 mL, drawn up as 1.9 mL.
      final result = roundForDisplay(
        value: 1.875,
        decimalPlaces: additiveVolumeDecimalPlaces,
      ) as CalculationValue<RoundedResult>;

      expect(result.value.text, '1.9');
    });

    test('a volume too small to draw up is refused, not shown as 0.0', () {
      // 0.04 mL cannot be dispensed and must not be presented as "0.0".
      final result = roundForDisplay(
        value: 0.04,
        decimalPlaces: additiveVolumeDecimalPlaces,
      ) as CalculationRejected<RoundedResult>;

      expect(result.issue, CalculationIssue.inputOutOfRange);
    });

    test('a volume at the smallest drawable amount is shown', () {
      final result = roundForDisplay(
        value: 0.1,
        decimalPlaces: additiveVolumeDecimalPlaces,
      ) as CalculationValue<RoundedResult>;

      expect(result.value.text, '0.1');
    });
  });
}
