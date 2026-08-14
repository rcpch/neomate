// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Tests for the mean airway pressure formula. The expected values are worked
// by hand in the comments so a clinical reviewer can check the arithmetic
// without running the suite.
//
// These are NOT source-derived conformance vectors (roadmap D31/R6). They lock
// the implemented arithmetic and the refusal behaviour in place; vectors taken
// from an approved source replace them once the formula source is assigned.

import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/calculations/calculation_outcome.dart';
import 'package:neomate2/calculations/ventilation/mean_airway_pressure.dart';

void main() {
  group('mean airway pressure', () {
    test('computes MAP for typical conventional ventilator settings', () {
      // PIP 20, PEEP 5, Ti 0.4 s, Te 1.1 s.
      // duty cycle = 0.4 / 1.5           = 0.26666...
      // MAP        = 5 + (15 x 0.26666)  = 9.0 cmH2O
      final result = calculateMeanAirwayPressure(
        peakInspiratoryPressureCmH2O: 20,
        positiveEndExpiratoryPressureCmH2O: 5,
        inspiratoryTimeSeconds: 0.4,
        expiratoryTimeSeconds: 1.1,
      ) as CalculationValue<MeanAirwayPressure>;

      expect(result.value.centimetresOfWater, closeTo(9.0, 1e-9));
    });

    test('returns PEEP when PIP equals PEEP, whatever the duty cycle', () {
      // A flat pressure waveform has a mean equal to that pressure.
      final result = calculateMeanAirwayPressure(
        peakInspiratoryPressureCmH2O: 6,
        positiveEndExpiratoryPressureCmH2O: 6,
        inspiratoryTimeSeconds: 0.5,
        expiratoryTimeSeconds: 0.5,
      ) as CalculationValue<MeanAirwayPressure>;

      expect(result.value.centimetresOfWater, closeTo(6, 1e-9));
    });

    test('MAP always lies between PEEP and PIP', () {
      // Property check across the accepted duty-cycle span.
      for (final inspiratoryTime in <double>[0.1, 0.3, 0.5, 1.0, 2.0]) {
        final result = calculateMeanAirwayPressure(
          peakInspiratoryPressureCmH2O: 24,
          positiveEndExpiratoryPressureCmH2O: 6,
          inspiratoryTimeSeconds: inspiratoryTime,
          expiratoryTimeSeconds: 1.0,
        ) as CalculationValue<MeanAirwayPressure>;

        expect(result.value.centimetresOfWater, greaterThan(6));
        expect(result.value.centimetresOfWater, lessThan(24));
      }
    });

    test('rejects PEEP above PIP as transposed or impossible settings', () {
      final result = calculateMeanAirwayPressure(
        peakInspiratoryPressureCmH2O: 5,
        positiveEndExpiratoryPressureCmH2O: 20,
        inspiratoryTimeSeconds: 0.4,
        expiratoryTimeSeconds: 1.1,
      ) as CalculationRejected<MeanAirwayPressure>;

      expect(result.issue, CalculationIssue.inconsistentInputs);
    });

    test('rejects zero or negative phase times', () {
      final zeroInspiratory = calculateMeanAirwayPressure(
        peakInspiratoryPressureCmH2O: 20,
        positiveEndExpiratoryPressureCmH2O: 5,
        inspiratoryTimeSeconds: 0,
        expiratoryTimeSeconds: 1.1,
      ) as CalculationRejected<MeanAirwayPressure>;
      final negativeExpiratory = calculateMeanAirwayPressure(
        peakInspiratoryPressureCmH2O: 20,
        positiveEndExpiratoryPressureCmH2O: 5,
        inspiratoryTimeSeconds: 0.4,
        expiratoryTimeSeconds: -1,
      ) as CalculationRejected<MeanAirwayPressure>;

      expect(zeroInspiratory.issue, CalculationIssue.nonPositiveInput);
      expect(negativeExpiratory.issue, CalculationIssue.nonPositiveInput);
    });

    test('rejects implausible pressures such as a missed decimal point', () {
      final result = calculateMeanAirwayPressure(
        peakInspiratoryPressureCmH2O: 200,
        positiveEndExpiratoryPressureCmH2O: 5,
        inspiratoryTimeSeconds: 0.4,
        expiratoryTimeSeconds: 1.1,
      ) as CalculationRejected<MeanAirwayPressure>;

      expect(result.issue, CalculationIssue.inputOutOfRange);
    });

    test('rejects non-finite input', () {
      final result = calculateMeanAirwayPressure(
        peakInspiratoryPressureCmH2O: double.nan,
        positiveEndExpiratoryPressureCmH2O: 5,
        inspiratoryTimeSeconds: 0.4,
        expiratoryTimeSeconds: 1.1,
      ) as CalculationRejected<MeanAirwayPressure>;

      expect(result.issue, CalculationIssue.notFinite);
    });
  });
}
