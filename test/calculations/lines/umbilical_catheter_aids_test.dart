// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/calculations/lines/umbilical_arterial_catheter.dart';
import 'package:neomate2/calculations/lines/umbilical_venous_catheter.dart';
import 'package:neomate2/calculations/patient_context.dart';
import 'package:neomate2/clinical_policy/neonatal_weight_policy.dart';

void main() {
  PatientContext patient(double grams) {
    final result = PatientWeight.validate(
      grams: grams,
      policy: neonatalWeightPolicy,
    ) as ValidWeight;
    return PatientContext(
      weight: result.weight,
      weightOrigin: WeightOrigin.measured,
    );
  }

  group('inherited UVC aid', () {
    test('calculates length excluding stump from weight', () {
      final result = umbilicalVenousCatheterAid(patient: patient(1000));

      expect(result.insertionLengthCentimetresExcludingStump, 7);
      expect(result.catheterSizeFrench, 3.5);
    });

    test('changes catheter size at 1.5 kg without changing the formula', () {
      final below = umbilicalVenousCatheterAid(patient: patient(1499));
      final boundary = umbilicalVenousCatheterAid(patient: patient(1500));

      expect(below.catheterSizeFrench, 3.5);
      expect(boundary.catheterSizeFrench, 5);
      expect(boundary.insertionLengthCentimetresExcludingStump, 7.75);
    });
  });

  group('inherited UAC aid', () {
    test('calculates length excluding stump from weight', () {
      final result = umbilicalArterialCatheterAid(patient: patient(1000));

      expect(result.insertionLengthCentimetresExcludingStump, 12);
      expect(result.catheterSizeFrench, 3.5);
    });

    test('changes catheter size at 1.2 kg without changing the formula', () {
      final below = umbilicalArterialCatheterAid(patient: patient(1199));
      final boundary = umbilicalArterialCatheterAid(patient: patient(1200));

      expect(below.catheterSizeFrench, 3.5);
      expect(boundary.catheterSizeFrench, 5);
      expect(boundary.insertionLengthCentimetresExcludingStump, 12.6);
    });
  });

  test('matches the inherited 3 kg examples', () {
    final context = patient(3000);

    expect(
      umbilicalVenousCatheterAid(patient: context)
          .insertionLengthCentimetresExcludingStump,
      10,
    );
    expect(
      umbilicalArterialCatheterAid(patient: context)
          .insertionLengthCentimetresExcludingStump,
      18,
    );
  });
}
