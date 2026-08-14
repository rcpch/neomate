// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Tests for the glucose infusion rate formula. Expected values are worked by
// hand in the comments so the arithmetic can be checked on paper during
// clinical review.

import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/calculations/calculation_outcome.dart';
import 'package:neomate2/calculations/fluids/glucose_infusion_rate.dart';
import 'package:neomate2/calculations/patient_context.dart';

void main() {
  const weightPolicy = WeightPolicy(
    minimumGrams: 100,
    maximumGrams: 10000,
    sourceId: 'SYNTHETIC-TEST-SOURCE',
  );

  PatientContext patientOfGrams(double grams) {
    final weight = (PatientWeight.validate(grams: grams, policy: weightPolicy)
            as ValidWeight)
        .weight;
    return PatientContext(weight: weight, weightOrigin: WeightOrigin.measured);
  }

  group('glucose infusion rate', () {
    test('computes GIR for 10% glucose at 12 mL/hour in a 3 kg baby', () {
      // GIR = (10 x 12) / (6 x 3) = 120 / 18 = 6.666... mg/kg/min
      final result = calculateGlucoseInfusionRate(
        patient: patientOfGrams(3000),
        glucosePercentWeightPerVolume: 10,
        rateMillilitresPerHour: 12,
      ) as CalculationValue<double>;

      expect(result.value, closeTo(6.6666666, 1e-6));
    });

    test('computes GIR for a 1 kg baby on 10% glucose at 3 mL/hour', () {
      // GIR = (10 x 3) / (6 x 1) = 5 mg/kg/min
      final result = calculateGlucoseInfusionRate(
        patient: patientOfGrams(1000),
        glucosePercentWeightPerVolume: 10,
        rateMillilitresPerHour: 3,
      ) as CalculationValue<double>;

      expect(result.value, closeTo(5, 1e-9));
    });

    test('doubling the concentration doubles the GIR', () {
      final atTenPercent = calculateGlucoseInfusionRate(
        patient: patientOfGrams(2500),
        glucosePercentWeightPerVolume: 10,
        rateMillilitresPerHour: 8,
      ) as CalculationValue<double>;
      final atTwentyPercent = calculateGlucoseInfusionRate(
        patient: patientOfGrams(2500),
        glucosePercentWeightPerVolume: 20,
        rateMillilitresPerHour: 8,
      ) as CalculationValue<double>;

      expect(atTwentyPercent.value, closeTo(atTenPercent.value * 2, 1e-9));
    });

    test('halving the weight doubles the GIR', () {
      final atTwoKilograms = calculateGlucoseInfusionRate(
        patient: patientOfGrams(2000),
        glucosePercentWeightPerVolume: 10,
        rateMillilitresPerHour: 6,
      ) as CalculationValue<double>;
      final atOneKilogram = calculateGlucoseInfusionRate(
        patient: patientOfGrams(1000),
        glucosePercentWeightPerVolume: 10,
        rateMillilitresPerHour: 6,
      ) as CalculationValue<double>;

      expect(atOneKilogram.value, closeTo(atTwoKilograms.value * 2, 1e-9));
    });

    test('rejects zero and negative concentrations and rates', () {
      final zeroRate = calculateGlucoseInfusionRate(
        patient: patientOfGrams(3000),
        glucosePercentWeightPerVolume: 10,
        rateMillilitresPerHour: 0,
      ) as CalculationRejected<double>;
      final negativeConcentration = calculateGlucoseInfusionRate(
        patient: patientOfGrams(3000),
        glucosePercentWeightPerVolume: -10,
        rateMillilitresPerHour: 12,
      ) as CalculationRejected<double>;

      expect(zeroRate.issue, CalculationIssue.nonPositiveInput);
      expect(negativeConcentration.issue, CalculationIssue.nonPositiveInput);
    });

    test('rejects an impossible glucose percentage', () {
      // Above 100 is arithmetically impossible for a w/v percentage; the guard
      // is set lower still, at the highest stock preparation.
      final result = calculateGlucoseInfusionRate(
        patient: patientOfGrams(3000),
        glucosePercentWeightPerVolume: 110,
        rateMillilitresPerHour: 12,
      ) as CalculationRejected<double>;

      expect(result.issue, CalculationIssue.inputOutOfRange);
    });

    test('rejects an implausible pump rate', () {
      final result = calculateGlucoseInfusionRate(
        patient: patientOfGrams(3000),
        glucosePercentWeightPerVolume: 10,
        rateMillilitresPerHour: 5000,
      ) as CalculationRejected<double>;

      expect(result.issue, CalculationIssue.inputOutOfRange);
    });

    test('rejects non-finite input', () {
      final result = calculateGlucoseInfusionRate(
        patient: patientOfGrams(3000),
        glucosePercentWeightPerVolume: 10,
        rateMillilitresPerHour: double.infinity,
      ) as CalculationRejected<double>;

      expect(result.issue, CalculationIssue.notFinite);
    });
  });
}
