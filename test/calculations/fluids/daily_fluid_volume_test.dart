// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Tests for the daily fluid volume conversion. The permitted mL/kg/day range
// used here is synthetic test data, not a clinical recommendation: the point
// of these tests is that the module obeys whatever range the reviewed policy
// supplies.

import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/calculations/calculation_outcome.dart';
import 'package:neomate2/calculations/fluids/daily_fluid_volume.dart';
import 'package:neomate2/calculations/patient_context.dart';
import 'package:neomate2/calculations/protocol_calculation.dart';

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

  // Synthetic permitted range standing in for a reviewed fluid policy record.
  const approved = ApprovedRange(minimum: 40, maximum: 200);

  group('daily fluid volume', () {
    test('converts mL/kg/day into a daily total and an hourly rate', () {
      // 100 mL/kg/day x 3 kg = 300 mL/day; 300 / 24 = 12.5 mL/hour.
      final result = calculateDailyFluidVolume(
        patient: patient,
        prescribedMillilitresPerKilogramPerDay: 100,
        approvedMillilitresPerKilogramPerDay: approved,
      ) as CalculationValue<DailyFluidVolume>;

      expect(result.value.totalMillilitresPerDay, closeTo(300, 1e-9));
      expect(result.value.millilitresPerHour, closeTo(12.5, 1e-9));
    });

    test('accepts the inclusive bounds of the approved range', () {
      final atMinimum = calculateDailyFluidVolume(
        patient: patient,
        prescribedMillilitresPerKilogramPerDay: 40,
        approvedMillilitresPerKilogramPerDay: approved,
      );
      final atMaximum = calculateDailyFluidVolume(
        patient: patient,
        prescribedMillilitresPerKilogramPerDay: 200,
        approvedMillilitresPerKilogramPerDay: approved,
      );

      expect(atMinimum, isA<CalculationValue<DailyFluidVolume>>());
      expect(atMaximum, isA<CalculationValue<DailyFluidVolume>>());
    });

    test('rejects a prescription above the approved range', () {
      // The classic missed-decimal error: 1500 instead of 150.
      final result = calculateDailyFluidVolume(
        patient: patient,
        prescribedMillilitresPerKilogramPerDay: 1500,
        approvedMillilitresPerKilogramPerDay: approved,
      ) as CalculationRejected<DailyFluidVolume>;

      expect(result.issue, CalculationIssue.inputOutOfRange);
    });

    test('rejects a prescription below the approved range', () {
      final result = calculateDailyFluidVolume(
        patient: patient,
        prescribedMillilitresPerKilogramPerDay: 10,
        approvedMillilitresPerKilogramPerDay: approved,
      ) as CalculationRejected<DailyFluidVolume>;

      expect(result.issue, CalculationIssue.inputOutOfRange);
    });

    test('rejects zero and negative prescriptions', () {
      final zero = calculateDailyFluidVolume(
        patient: patient,
        prescribedMillilitresPerKilogramPerDay: 0,
        approvedMillilitresPerKilogramPerDay: approved,
      ) as CalculationRejected<DailyFluidVolume>;
      final negative = calculateDailyFluidVolume(
        patient: patient,
        prescribedMillilitresPerKilogramPerDay: -100,
        approvedMillilitresPerKilogramPerDay: approved,
      ) as CalculationRejected<DailyFluidVolume>;

      expect(zero.issue, CalculationIssue.nonPositiveInput);
      expect(negative.issue, CalculationIssue.nonPositiveInput);
    });

    test('rejects a malformed policy range rather than calculating', () {
      // An unbounded upper limit is not a usable approval: it would permit any
      // prescription at all.
      final result = calculateDailyFluidVolume(
        patient: patient,
        prescribedMillilitresPerKilogramPerDay: 100,
        approvedMillilitresPerKilogramPerDay:
            const ApprovedRange(minimum: 40, maximum: double.infinity),
      ) as CalculationRejected<DailyFluidVolume>;

      expect(result.issue, CalculationIssue.inconsistentInputs);
    });

    test('rejects non-finite input', () {
      final result = calculateDailyFluidVolume(
        patient: patient,
        prescribedMillilitresPerKilogramPerDay: double.nan,
        approvedMillilitresPerKilogramPerDay: approved,
      ) as CalculationRejected<DailyFluidVolume>;

      expect(result.issue, CalculationIssue.notFinite);
    });
  });
}
