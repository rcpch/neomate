// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/calculations/patient_context.dart';

void main() {
  const policy = WeightPolicy(
    minimumGrams: 100,
    maximumGrams: 1000,
    sourceId: 'SYNTHETIC-TEST-SOURCE',
  );

  group('patient weight', () {
    test('accepts both policy boundaries', () {
      final minimum = PatientWeight.validate(grams: 100, policy: policy);
      final maximum = PatientWeight.validate(grams: 1000, policy: policy);

      expect(minimum, isA<ValidWeight>());
      expect(maximum, isA<ValidWeight>());
    });

    test('converts grams to kilograms without rounding', () {
      final result =
          PatientWeight.validate(grams: 625.5, policy: policy) as ValidWeight;

      expect(result.weight.grams, 625.5);
      expect(result.weight.kilograms, 0.6255);
    });

    test('rejects values below and above policy bounds', () {
      final below =
          PatientWeight.validate(grams: 99.9, policy: policy) as InvalidWeight;
      final above = PatientWeight.validate(grams: 1000.1, policy: policy)
          as InvalidWeight;

      expect(below.issue, WeightValidationIssue.belowMinimum);
      expect(above.issue, WeightValidationIssue.aboveMaximum);
    });

    test('rejects non-finite values', () {
      for (final value in [
        double.nan,
        double.infinity,
        double.negativeInfinity
      ]) {
        final result = PatientWeight.validate(grams: value, policy: policy)
            as InvalidWeight;

        expect(result.issue, WeightValidationIssue.notFinite);
      }
    });

    test('records whether weight is measured or estimated', () {
      final valid =
          PatientWeight.validate(grams: 500, policy: policy) as ValidWeight;

      final measured = PatientContext(
        weight: valid.weight,
        weightOrigin: WeightOrigin.measured,
      );
      final estimated = PatientContext(
        weight: valid.weight,
        weightOrigin: WeightOrigin.estimated,
      );

      expect(measured.weightOrigin, WeightOrigin.measured);
      expect(estimated.weightOrigin, WeightOrigin.estimated);
    });
  });
}
