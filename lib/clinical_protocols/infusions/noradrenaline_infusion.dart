// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Clinical source IDs: SRC-006, SRC-008
// Clinical content IDs: PROTOCOL-NORADRENALINE-INFUSION
// Clinical reviewer: none
// Clinical sign-off: none
// Review due: none
// Safety hazards: HZ-001, HZ-006
//
// ---------------------------------------------------------------------------
// STATUS: NOT APPROVED FOR CLINICAL USE. Inherited baseline, no clinical
// reviewer, no sign-off. See spec/clinical-source-convention.md.
// ---------------------------------------------------------------------------
// Protocol    : Noradrenaline continuous intravenous infusion.
// Dose range  : 50 to 500 nanograms/kg/minute.
// Limit       : Maximum 40 micrograms/mL.
//
// Reviewer notes:
//   * Carried forward from the shipped Neomate product (SRC-006), which
//     attributes the concentration limit to BNFc, January 2015 (SRC-008).
//     Confirm against the current edition.
//   * Prescribed in NANOGRAMS/kg/minute. See the note in
//     adrenaline_infusion.dart about thousand-fold unit errors.
//   * Concentration limit converted for the engine:
//         2 mg / 50 mL = 0.04 mg/mL = 40 micrograms/mL = 40 000 nanograms/mL
//   * The inherited source notes that higher concentrations may be used if the
//     patient is fluid restricted. That exception is deliberately NOT encoded
//     here. Encoding it would require its own review and a way for the user to
//     record why the limit was exceeded; until then the safer behaviour is to
//     refuse and let the prescriber work outside the app.
//   * Administration is via a central line, so peripheral access is not
//     approved in this record.
// ---------------------------------------------------------------------------

import '../../calculations/protocol_calculation.dart';

/// Identifier used in the protocol registry and in test evidence.
const String noradrenalineInfusionProtocolId =
    'PROTOCOL-NORADRENALINE-INFUSION';

/// Approved dose range in nanograms/kg/minute.
const ApprovedRange noradrenalineApprovedDose =
    ApprovedRange(minimum: 50, maximum: 500);

/// Approved concentration range in nanograms per millilitre.
const ApprovedRange noradrenalineApprovedConcentration =
    ApprovedRange(minimum: 0, maximum: 40000);

/// Builds a noradrenaline infusion protocol for a chosen dose and preparation.
WeightBasedInfusionProtocol noradrenalineInfusion({
  required double dosePerKilogramPerMinute,
  double preparationVolumeMillilitres = 50,
  double rateMillilitresPerHour = 0.1,
}) {
  return WeightBasedInfusionProtocol(
    protocolId: noradrenalineInfusionProtocolId,
    dosePerKilogram: dosePerKilogramPerMinute,
    doseUnit: DoseUnit.nanograms,
    timeBasis: DoseTimeBasis.minute,
    approvedDosePerKilogram: noradrenalineApprovedDose,
    approvedConcentrationPerMillilitre: noradrenalineApprovedConcentration,
    preparationVolumeMillilitres: preparationVolumeMillilitres,
    rateMillilitresPerHour: rateMillilitresPerHour,
    approvedRoutes: const {AdministrationRoute.intravenous},
    approvedAccess: const {
      VascularAccess.central,
      VascularAccess.umbilicalVenous,
    },
  );
}
