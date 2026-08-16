// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Clinical source IDs: SRC-006, SRC-010
// Clinical content IDs: CALC-ENDOTRACHEAL-TUBE-LIP-LENGTH
// Clinical reviewer: none
// Clinical sign-off: none
// Review due: none
// Safety hazards: HZ-001, HZ-003, HZ-004, HZ-007
//
// ---------------------------------------------------------------------------
// STATUS: NOT APPROVED FOR CLINICAL USE. Inherited baseline, no clinical
// reviewer, no sign-off. See spec/clinical-source-convention.md.
// ---------------------------------------------------------------------------
// Aid       : Initial oral ETT length at the lips by weight band.
// Bands     : <0.5 kg = below 5.5 cm; 0.5-<0.7 = 5.5 cm;
//             0.7-<0.9 = 6.0 cm; 0.9-<1.1 = 6.5 cm;
//             1.1-<1.5 = 7.0 cm; 1.5-<1.9 = 7.5 cm;
//             1.9-<2.5 = 8.0 cm; 2.5-<3.2 = 8.5 cm;
//             3.2-4.2 = 9.0 cm; >4.2 kg = no inherited value.
//
// Reviewer notes:
//   * DISCREPANCY CARRIED FORWARD. The HTML app displays "<5.5 cm" below
//     500 g, while the inherited Dart successor's band map returns 5.5 cm for
//     every weight below 700 g. This module preserves the preceding HTML app's
//     visible behavior so the disagreement remains explicit for review.
//   * This is an initial-position aid only. Tube position must be confirmed by
//     approved clinical methods and reassessed after movement or deterioration.
// ---------------------------------------------------------------------------

import '../patient_context.dart';

class EndotrachealTubeLipLengthAid {
  const EndotrachealTubeLipLengthAid._({
    this.centimetres,
    this.isBelowNominalValue = false,
  });

  const EndotrachealTubeLipLengthAid.value(double centimetres)
      : this._(centimetres: centimetres);

  const EndotrachealTubeLipLengthAid.below(double centimetres)
      : this._(centimetres: centimetres, isBelowNominalValue: true);

  const EndotrachealTubeLipLengthAid.notAvailable() : this._();

  final double? centimetres;
  final bool isBelowNominalValue;

  bool get isAvailable => centimetres != null;
}

/// Returns the inherited oral ETT lip-length band for [patient].
EndotrachealTubeLipLengthAid endotrachealTubeLipLengthAid({
  required PatientContext patient,
}) {
  final kilograms = patient.weight.kilograms;
  if (kilograms < 0.5) {
    return const EndotrachealTubeLipLengthAid.below(5.5);
  }
  if (kilograms < 0.7) {
    return const EndotrachealTubeLipLengthAid.value(5.5);
  }
  if (kilograms < 0.9) {
    return const EndotrachealTubeLipLengthAid.value(6);
  }
  if (kilograms < 1.1) {
    return const EndotrachealTubeLipLengthAid.value(6.5);
  }
  if (kilograms < 1.5) {
    return const EndotrachealTubeLipLengthAid.value(7);
  }
  if (kilograms < 1.9) {
    return const EndotrachealTubeLipLengthAid.value(7.5);
  }
  if (kilograms < 2.5) {
    return const EndotrachealTubeLipLengthAid.value(8);
  }
  if (kilograms < 3.2) {
    return const EndotrachealTubeLipLengthAid.value(8.5);
  }
  if (kilograms <= 4.2) {
    return const EndotrachealTubeLipLengthAid.value(9);
  }
  return const EndotrachealTubeLipLengthAid.notAvailable();
}
