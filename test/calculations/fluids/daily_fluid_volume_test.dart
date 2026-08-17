// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Tests for the daily fluid volume conversion.

import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/calculations/calculation_outcome.dart';
import 'package:neomate2/calculations/fluids/daily_fluid_volume.dart';
import 'package:neomate2/calculations/patient_context.dart';

void main() {
  const weightPolicy = WeightPolicy(
    minimumGrams: 100,
    maximumGrams: 10000,
    sourceId: 'SYNTHETIC-TEST-SOURCE',
  );
  final weight =
      (PatientWeight.validate(grams: 3000, policy: weightPolicy) as ValidWeight)
          .weight;
  final patient =
      PatientContext(weight: weight, weightOrigin: WeightOrigin.measured);

  group('daily fluid volume', () {
    test('converts mL/kg/day into a daily total and an hourly rate', () {
      // 100 mL/kg/day x 3 kg = 300 mL/day; 300 / 24 = 12.5 mL/hour.
      final result = calculateDailyFluidVolume(
        patient: patient,
        prescribedMillilitresPerKilogramPerDay: 100,
      ) as CalculationValue<DailyFluidVolume>;

      expect(result.value.totalMillilitresPerDay, closeTo(300, 1e-9));
      expect(result.value.millilitresPerHour, closeTo(12.5, 1e-9));
    });

    test('calculates positive entries without a configured range gate', () {
      final small = calculateDailyFluidVolume(
        patient: patient,
        prescribedMillilitresPerKilogramPerDay: 10,
      );
      final large = calculateDailyFluidVolume(
        patient: patient,
        prescribedMillilitresPerKilogramPerDay: 1500,
      );

      expect(small, isA<CalculationValue<DailyFluidVolume>>());
      expect(large, isA<CalculationValue<DailyFluidVolume>>());
    });

    test('rejects zero and negative prescriptions', () {
      final zero = calculateDailyFluidVolume(
        patient: patient,
        prescribedMillilitresPerKilogramPerDay: 0,
      ) as CalculationRejected<DailyFluidVolume>;
      final negative = calculateDailyFluidVolume(
        patient: patient,
        prescribedMillilitresPerKilogramPerDay: -100,
      ) as CalculationRejected<DailyFluidVolume>;

      expect(zero.issue, CalculationIssue.nonPositiveInput);
      expect(negative.issue, CalculationIssue.nonPositiveInput);
    });

    test('rejects non-finite input', () {
      final result = calculateDailyFluidVolume(
        patient: patient,
        prescribedMillilitresPerKilogramPerDay: double.nan,
      ) as CalculationRejected<DailyFluidVolume>;

      expect(result.issue, CalculationIssue.notFinite);
    });
  });
}
