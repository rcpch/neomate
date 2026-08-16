// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Clinical source IDs: SRC-006, SRC-010
// Clinical content IDs: CALC-ENDOTRACHEAL-TUBE-SIZE
// Clinical reviewer: none
// Clinical sign-off: none
// Review due: none
// Safety hazards: HZ-001, HZ-003, HZ-004, HZ-007
//
// ---------------------------------------------------------------------------
// STATUS: NOT APPROVED FOR CLINICAL USE. Inherited baseline, no clinical
// reviewer, no sign-off. See spec/clinical-source-convention.md.
// ---------------------------------------------------------------------------
// Aid       : Endotracheal tube internal-diameter size by weight band.
// Bands     : <1 kg = 2.5 mm; 1-<2 kg = 3.0 mm; 2-<3 kg = 3.5 mm;
//             >=3 kg = 3.5-4.0 mm.
//
// Reviewer notes:
//   * These bands are transcribed from the shipped HTML and Dart Neomate
//     implementations (SRC-006). They require confirmation against a current
//     neonatal airway source and local equipment policy before sign-off.
//   * This is an equipment-selection aid, not a direction to intubate and not
//     a substitute for checking fit, leak, resistance, or local policy.
// ---------------------------------------------------------------------------

import '../patient_context.dart';

class EndotrachealTubeSizeAid {
  const EndotrachealTubeSizeAid({
    required this.minimumInternalDiameterMillimetres,
    required this.maximumInternalDiameterMillimetres,
  });

  final double minimumInternalDiameterMillimetres;
  final double maximumInternalDiameterMillimetres;

  bool get isRange =>
      minimumInternalDiameterMillimetres != maximumInternalDiameterMillimetres;
}

/// Returns the inherited ETT internal-diameter band for [patient].
EndotrachealTubeSizeAid endotrachealTubeSizeAid({
  required PatientContext patient,
}) {
  final kilograms = patient.weight.kilograms;
  if (kilograms < 1) {
    return const EndotrachealTubeSizeAid(
      minimumInternalDiameterMillimetres: 2.5,
      maximumInternalDiameterMillimetres: 2.5,
    );
  }
  if (kilograms < 2) {
    return const EndotrachealTubeSizeAid(
      minimumInternalDiameterMillimetres: 3,
      maximumInternalDiameterMillimetres: 3,
    );
  }
  if (kilograms < 3) {
    return const EndotrachealTubeSizeAid(
      minimumInternalDiameterMillimetres: 3.5,
      maximumInternalDiameterMillimetres: 3.5,
    );
  }
  return const EndotrachealTubeSizeAid(
    minimumInternalDiameterMillimetres: 3.5,
    maximumInternalDiameterMillimetres: 4,
  );
}
