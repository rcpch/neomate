// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Tests for the daily electrolyte requirement conversion.

import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/calculations/calculation_outcome.dart';
import 'package:neomate2/calculations/fluids/electrolyte_requirement.dart';
import 'package:neomate2/calculations/patient_context.dart';

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

  group('electrolyte requirement', () {
    test('converts mmol/kg/day into a daily requirement', () {
      // 3 mmol/kg/day x 2.5 kg = 7.5 mmol/day
      final result = calculateElectrolyteRequirement(
        patient: patient,
        electrolyte: Electrolyte.sodium,
        prescribedMillimolesPerKilogramPerDay: 3,
      ) as CalculationValue<ElectrolyteRequirement>;

      expect(result.value.millimolesPerDay, closeTo(7.5, 1e-9));
    });

    test('labels the result with the electrolyte that was prescribed', () {
      // Guards against a potassium prescription being reported as sodium.
      final result = calculateElectrolyteRequirement(
        patient: patient,
        electrolyte: Electrolyte.potassium,
        prescribedMillimolesPerKilogramPerDay: 2,
      ) as CalculationValue<ElectrolyteRequirement>;

      expect(result.value.electrolyte, Electrolyte.potassium);
    });

    test('calculates positive entries without a configured range gate', () {
      final small = calculateElectrolyteRequirement(
        patient: patient,
        electrolyte: Electrolyte.sodium,
        prescribedMillimolesPerKilogramPerDay: 0.5,
      );
      final large = calculateElectrolyteRequirement(
        patient: patient,
        electrolyte: Electrolyte.sodium,
        prescribedMillimolesPerKilogramPerDay: 30,
      );

      expect(small, isA<CalculationValue<ElectrolyteRequirement>>());
      expect(large, isA<CalculationValue<ElectrolyteRequirement>>());
    });

    test('rejects zero and negative prescriptions', () {
      final zero = calculateElectrolyteRequirement(
        patient: patient,
        electrolyte: Electrolyte.sodium,
        prescribedMillimolesPerKilogramPerDay: 0,
      ) as CalculationRejected<ElectrolyteRequirement>;
      final negative = calculateElectrolyteRequirement(
        patient: patient,
        electrolyte: Electrolyte.sodium,
        prescribedMillimolesPerKilogramPerDay: -3,
      ) as CalculationRejected<ElectrolyteRequirement>;

      expect(zero.issue, CalculationIssue.nonPositiveInput);
      expect(negative.issue, CalculationIssue.nonPositiveInput);
    });

    test('rejects non-finite input', () {
      final result = calculateElectrolyteRequirement(
        patient: patient,
        electrolyte: Electrolyte.sodium,
        prescribedMillimolesPerKilogramPerDay: double.nan,
      ) as CalculationRejected<ElectrolyteRequirement>;

      expect(result.issue, CalculationIssue.notFinite);
    });
  });
}
