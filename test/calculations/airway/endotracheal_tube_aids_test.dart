// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/calculations/airway/endotracheal_tube_lip_length.dart';
import 'package:neomate2/calculations/airway/endotracheal_tube_size.dart';
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

  group('inherited ETT size aid', () {
    test('uses the expected internal-diameter band at every boundary', () {
      final cases = <double, (double, double)>{
        200: (2.5, 2.5),
        999: (2.5, 2.5),
        1000: (3, 3),
        1999: (3, 3),
        2000: (3.5, 3.5),
        2999: (3.5, 3.5),
        3000: (3.5, 4),
        6000: (3.5, 4),
      };

      cases.forEach((grams, expected) {
        final result = endotrachealTubeSizeAid(patient: patient(grams));
        expect(
          result.minimumInternalDiameterMillimetres,
          expected.$1,
          reason: '$grams g minimum',
        );
        expect(
          result.maximumInternalDiameterMillimetres,
          expected.$2,
          reason: '$grams g maximum',
        );
      });
    });
  });

  group('inherited ETT lip-length aid', () {
    test('preserves the HTML band transition below 500 g', () {
      final below = endotrachealTubeLipLengthAid(patient: patient(499));
      final atBoundary = endotrachealTubeLipLengthAid(patient: patient(500));

      expect(below.centimetres, 5.5);
      expect(below.isBelowNominalValue, isTrue);
      expect(atBoundary.centimetres, 5.5);
      expect(atBoundary.isBelowNominalValue, isFalse);
    });

    test('uses the expected lip-length band at every remaining boundary', () {
      final cases = <double, double>{
        699: 5.5,
        700: 6,
        899: 6,
        900: 6.5,
        1099: 6.5,
        1100: 7,
        1499: 7,
        1500: 7.5,
        1899: 7.5,
        1900: 8,
        2499: 8,
        2500: 8.5,
        3199: 8.5,
        3200: 9,
        4200: 9,
      };

      cases.forEach((grams, expected) {
        final result = endotrachealTubeLipLengthAid(patient: patient(grams));
        expect(result.centimetres, expected, reason: '$grams g');
        expect(result.isAvailable, isTrue, reason: '$grams g');
      });
    });

    test('returns no inherited lip-length value above 4.2 kg', () {
      final result = endotrachealTubeLipLengthAid(patient: patient(4201));

      expect(result.isAvailable, isFalse);
      expect(result.centimetres, isNull);
    });
  });
}
