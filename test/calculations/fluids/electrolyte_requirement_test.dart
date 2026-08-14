// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Tests for the daily electrolyte requirement conversion. The mmol/kg/day
// range used here is synthetic test data, not a clinical recommendation: these
// tests check the module obeys whatever range the reviewed policy supplies.

import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/calculations/calculation_outcome.dart';
import 'package:neomate2/calculations/fluids/electrolyte_requirement.dart';
import 'package:neomate2/calculations/patient_context.dart';
import 'package:neomate2/calculations/protocol_calculation.dart';

void main() {
  const weightPolicy = WeightPolicy(
    minimumGrams: 100,
    maximumGrams: 10000,
    sourceId: 'SYNTHETIC-TEST-SOURCE',
  );
  final weight =
      (PatientWeight.validate(grams: 2500, policy: weightPolicy) as ValidWeight)
          .weight;
  final patient =
      PatientContext(weight: weight, weightOrigin: WeightOrigin.measured);

  // Synthetic permitted range standing in for a reviewed policy record.
  const approved = ApprovedRange(minimum: 1, maximum: 6);

  group('electrolyte requirement', () {
    test('converts mmol/kg/day into a daily requirement', () {
      // 3 mmol/kg/day x 2.5 kg = 7.5 mmol/day
      final result = calculateElectrolyteRequirement(
        patient: patient,
        electrolyte: Electrolyte.sodium,
        prescribedMillimolesPerKilogramPerDay: 3,
        approvedMillimolesPerKilogramPerDay: approved,
      ) as CalculationValue<ElectrolyteRequirement>;

      expect(result.value.millimolesPerDay, closeTo(7.5, 1e-9));
    });

    test('labels the result with the electrolyte that was prescribed', () {
      // Guards against a potassium prescription being reported as sodium.
      final result = calculateElectrolyteRequirement(
        patient: patient,
        electrolyte: Electrolyte.potassium,
        prescribedMillimolesPerKilogramPerDay: 2,
        approvedMillimolesPerKilogramPerDay: approved,
      ) as CalculationValue<ElectrolyteRequirement>;

      expect(result.value.electrolyte, Electrolyte.potassium);
    });

    test('accepts the inclusive bounds of the approved range', () {
      final atMinimum = calculateElectrolyteRequirement(
        patient: patient,
        electrolyte: Electrolyte.sodium,
        prescribedMillimolesPerKilogramPerDay: 1,
        approvedMillimolesPerKilogramPerDay: approved,
      );
      final atMaximum = calculateElectrolyteRequirement(
        patient: patient,
        electrolyte: Electrolyte.sodium,
        prescribedMillimolesPerKilogramPerDay: 6,
        approvedMillimolesPerKilogramPerDay: approved,
      );

      expect(atMinimum, isA<CalculationValue<ElectrolyteRequirement>>());
      expect(atMaximum, isA<CalculationValue<ElectrolyteRequirement>>());
    });

    test('rejects a prescription outside the approved range', () {
      final tooHigh = calculateElectrolyteRequirement(
        patient: patient,
        electrolyte: Electrolyte.potassium,
        prescribedMillimolesPerKilogramPerDay: 30,
        approvedMillimolesPerKilogramPerDay: approved,
      ) as CalculationRejected<ElectrolyteRequirement>;
      final tooLow = calculateElectrolyteRequirement(
        patient: patient,
        electrolyte: Electrolyte.potassium,
        prescribedMillimolesPerKilogramPerDay: 0.5,
        approvedMillimolesPerKilogramPerDay: approved,
      ) as CalculationRejected<ElectrolyteRequirement>;

      expect(tooHigh.issue, CalculationIssue.inputOutOfRange);
      expect(tooLow.issue, CalculationIssue.inputOutOfRange);
    });

    test('rejects zero and negative prescriptions', () {
      final zero = calculateElectrolyteRequirement(
        patient: patient,
        electrolyte: Electrolyte.sodium,
        prescribedMillimolesPerKilogramPerDay: 0,
        approvedMillimolesPerKilogramPerDay: approved,
      ) as CalculationRejected<ElectrolyteRequirement>;
      final negative = calculateElectrolyteRequirement(
        patient: patient,
        electrolyte: Electrolyte.sodium,
        prescribedMillimolesPerKilogramPerDay: -3,
        approvedMillimolesPerKilogramPerDay: approved,
      ) as CalculationRejected<ElectrolyteRequirement>;

      expect(zero.issue, CalculationIssue.nonPositiveInput);
      expect(negative.issue, CalculationIssue.nonPositiveInput);
    });

    test('rejects an unbounded policy range rather than calculating', () {
      final result = calculateElectrolyteRequirement(
        patient: patient,
        electrolyte: Electrolyte.sodium,
        prescribedMillimolesPerKilogramPerDay: 3,
        approvedMillimolesPerKilogramPerDay:
            const ApprovedRange(minimum: 1, maximum: double.infinity),
      ) as CalculationRejected<ElectrolyteRequirement>;

      expect(result.issue, CalculationIssue.inconsistentInputs);
    });

    test('rejects non-finite input', () {
      final result = calculateElectrolyteRequirement(
        patient: patient,
        electrolyte: Electrolyte.sodium,
        prescribedMillimolesPerKilogramPerDay: double.nan,
        approvedMillimolesPerKilogramPerDay: approved,
      ) as CalculationRejected<ElectrolyteRequirement>;

      expect(result.issue, CalculationIssue.notFinite);
    });
  });
}
