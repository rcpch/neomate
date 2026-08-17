// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Clinical source IDs: SRC-006, SRC-008, SRC-009
// Clinical content IDs: PROTOCOL-MORPHINE-INFUSION
// Clinical reviewer: none
// Clinical sign-off: none
// Review due: none
// Safety hazards: HZ-001, HZ-006
//
// ---------------------------------------------------------------------------
// STATUS: NOT APPROVED FOR CLINICAL USE. Inherited baseline, no clinical
// reviewer, no sign-off. See spec/clinical-source-convention.md.
// ---------------------------------------------------------------------------
// Protocol    : Morphine continuous intravenous infusion.
// Enforced    : 5 to 60 micrograms/kg/hour.
// Stated range: 5 to 20 micrograms/kg/hour; the inherited narrative says that
//               up to 40 micrograms/kg/hour may occasionally be used.
// Limit       : 30 mg/mL, converted from the inherited numeric field of
//               1500 mg in a 50 mL syringe.
//
// Reviewer notes:
//   * Values are carried forward from the shipped Dart Neomate product
//     (SRC-006), which attributes medicines guidance to BNFc 2015 and Medusa
//     2015 (SRC-008 and SRC-009). Confirm every figure against current sources
//     and the approved local formulary.
//   * DISCREPANCY CARRIED FORWARD. The numeric fields permitted 0-60
//     micrograms/kg/hour, the displayed range was 5-20, and narrative text
//     mentioned occasional doses up to 40. The displayed minimum of 5 is
//     enforced here so zero cannot produce an apparent preparation. The upper
//     ranges still require clinical review.
//   * The concentration field is unusually permissive and its warning merely
//     said "Higher than recommended concentration". It is retained as
//     migration evidence, not endorsed as a suitable preparation limit.
//   * The original Ionic product instead showed a fixed preparation of 1 mg
//     per kilogram in 50 mL at 1 mL/hour to deliver 20 micrograms/kg/hour.
//   * This unreviewed alpha conservatively permits only central or umbilical
//     venous access until route and access policy is independently confirmed.
// ---------------------------------------------------------------------------

import '../../calculations/protocol_calculation.dart';

const String morphineInfusionProtocolId = 'PROTOCOL-MORPHINE-INFUSION';

const ApprovedRange morphineApprovedDose =
    ApprovedRange(minimum: 5, maximum: 60);

const ApprovedRange morphineUsualDose = ApprovedRange(minimum: 5, maximum: 20);

const ApprovedRange morphineApprovedConcentration =
    ApprovedRange(minimum: 0, maximum: 30000);

WeightBasedInfusionProtocol morphineInfusion({
  required double dosePerKilogramPerHour,
  double preparationVolumeMillilitres = 50,
  double rateMillilitresPerHour = 0.1,
}) {
  return WeightBasedInfusionProtocol(
    protocolId: morphineInfusionProtocolId,
    dosePerKilogram: dosePerKilogramPerHour,
    doseUnit: DoseUnit.micrograms,
    timeBasis: DoseTimeBasis.hour,
    approvedDosePerKilogram: morphineApprovedDose,
    approvedConcentrationPerMillilitre: morphineApprovedConcentration,
    preparationVolumeMillilitres: preparationVolumeMillilitres,
    rateMillilitresPerHour: rateMillilitresPerHour,
    approvedRoutes: const {AdministrationRoute.intravenous},
    approvedAccess: const {
      VascularAccess.central,
      VascularAccess.umbilicalVenous,
    },
  );
}
