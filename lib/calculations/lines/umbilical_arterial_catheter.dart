// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Clinical source IDs: SRC-006, SRC-011
// Clinical content IDs: CALC-UMBILICAL-ARTERIAL-CATHETER
// Clinical reviewer: none
// Clinical sign-off: none
// Review due: none
// Safety hazards: HZ-001, HZ-003, HZ-004, HZ-007
//
// ---------------------------------------------------------------------------
// STATUS: NOT APPROVED FOR CLINICAL USE. Inherited baseline, no clinical
// reviewer, no sign-off. See spec/clinical-source-convention.md.
// ---------------------------------------------------------------------------
// Aid       : UAC insertion length and inherited catheter-size band.
// Formula   : length cm = (3 x birthweight kg) + 9, plus stump length.
// Size band : <1.2 kg = 3.5 F; >=1.2 kg = 5 F.
//
// Reviewer notes:
//   * Formula and threshold are transcribed from the shipped Neomate products
//     (SRC-006). Confirm against BAPM 2026 and local line policy.
//   * This is an initial insertion-length aid only. Tip position must be
//     confirmed using the unit's approved method before clinical use.
// ---------------------------------------------------------------------------

import '../patient_context.dart';

class UmbilicalArterialCatheterAid {
  const UmbilicalArterialCatheterAid({
    required this.insertionLengthCentimetresExcludingStump,
    required this.catheterSizeFrench,
  });

  final double insertionLengthCentimetresExcludingStump;
  final double catheterSizeFrench;
}

/// Calculates the inherited UAC insertion-length and size aid.
UmbilicalArterialCatheterAid umbilicalArterialCatheterAid({
  required PatientContext patient,
}) {
  final kilograms = patient.weight.kilograms;
  return UmbilicalArterialCatheterAid(
    insertionLengthCentimetresExcludingStump: (3 * kilograms) + 9,
    catheterSizeFrench: kilograms < 1.2 ? 3.5 : 5,
  );
}
