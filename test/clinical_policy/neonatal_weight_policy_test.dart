// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Tests for the shipped weight policy.
//
// These assert the policy values themselves, not just that validation works.
// A silent change to a clinical limit is exactly the kind of edit that should
// fail a test and force a conversation, so the numbers are written out here
// and in clinical-safety/signoff.md.

import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/calculations/patient_context.dart';
import 'package:neomate2/clinical_policy/neonatal_weight_policy.dart';

void main() {
  group('neonatal weight policy', () {
    test('permits 200 g to 6000 g, attributed to its provenance source', () {
      expect(neonatalWeightPolicy.minimumGrams, 200);
      expect(neonatalWeightPolicy.maximumGrams, 6000);
      expect(neonatalWeightPolicy.sourceId, 'SRC-006');
    });

    test('accepts weights at both inclusive bounds', () {
      final atMinimum = PatientWeight.validate(
        grams: 200,
        policy: neonatalWeightPolicy,
      );
      final atMaximum = PatientWeight.validate(
        grams: 6000,
        policy: neonatalWeightPolicy,
      );

      expect(atMinimum, isA<ValidWeight>());
      expect(atMaximum, isA<ValidWeight>());
    });

    test('accepts a plausible extremely preterm and a large term weight', () {
      // 450 g periviable infant, and a 4.8 kg infant of a diabetic mother.
      for (final grams in <double>[450, 4800]) {
        expect(
          PatientWeight.validate(grams: grams, policy: neonatalWeightPolicy),
          isA<ValidWeight>(),
          reason: '$grams g should be within the accepted range',
        );
      }
    });

    test('rejects a weight entered in kilograms by mistake', () {
      // 3.5 typed instead of 3500 is below the minimum, so it cannot silently
      // become a 3.5 g dose basis.
      final result = PatientWeight.validate(
        grams: 3.5,
        policy: neonatalWeightPolicy,
      ) as InvalidWeight;

      expect(result.issue, WeightValidationIssue.belowMinimum);
    });

    test('rejects an adult weight', () {
      final result = PatientWeight.validate(
        grams: 70000,
        policy: neonatalWeightPolicy,
      ) as InvalidWeight;

      expect(result.issue, WeightValidationIssue.aboveMaximum);
    });

    test('converts grams to kilograms for dose calculations', () {
      final weight = PatientWeight.validate(
        grams: 2500,
        policy: neonatalWeightPolicy,
      ) as ValidWeight;

      expect(weight.weight.kilograms, closeTo(2.5, 1e-9));
    });
  });
}
