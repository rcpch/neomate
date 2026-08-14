// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Clinical source IDs: SRC-006, SRC-008
// Clinical content IDs: PROTOCOL-DOPAMINE-INFUSION
// Clinical reviewer: none
// Clinical sign-off: none
// Review due: none
// Safety hazards: HZ-001, HZ-006
//
// ---------------------------------------------------------------------------
// STATUS: NOT APPROVED FOR CLINICAL USE. Inherited baseline, no clinical
// reviewer, no sign-off. See spec/clinical-source-convention.md.
// ---------------------------------------------------------------------------
// Protocol    : Dopamine continuous intravenous infusion.
// Dose range  : 5 to 20 micrograms/kg/minute.
// Limit       : Concentrations above 1.6 mg/mL are not recommended unless
//               infused centrally.
//
// Reviewer notes:
//   * Values are carried forward from the shipped Neomate product (SRC-006),
//     which has been in live clinical use internationally. The inherited code
//     attributes the concentration limit to BNFc 2015 (SRC-008). That edition
//     is now over a decade old, so the reviewer's task is to confirm the
//     figures against the current BNFc rather than to derive them afresh.
//   * The inherited limit is expressed as a maximum amount in a 50 mL syringe
//     (80 mg per 50 mL). It is converted here to a concentration per
//     millilitre, which is what the calculation engine checks, so the limit
//     holds regardless of the syringe size chosen:
//         80 mg / 50 mL = 1.6 mg/mL = 1600 micrograms/mL
//   * Route and access are restricted to reflect the inherited advice that
//     these doses are given centrally. Peripheral administration is not
//     approved here; extravasation of a vasopressor causes tissue injury.
//   * The dose is supplied by the caller. The approved range is fixed in this
//     file and cannot be overridden, so a caller can choose a dose but cannot
//     choose the limits it is checked against.
// ---------------------------------------------------------------------------

import '../../calculations/protocol_calculation.dart';

/// Identifier used in the protocol registry and in test evidence.
const String dopamineInfusionProtocolId = 'PROTOCOL-DOPAMINE-INFUSION';

/// Approved dose range in micrograms/kg/minute.
const ApprovedRange dopamineApprovedDose =
    ApprovedRange(minimum: 5, maximum: 20);

/// Approved concentration range in micrograms per millilitre.
///
/// Upper bound is 1.6 mg/mL, derived above.
const ApprovedRange dopamineApprovedConcentration =
    ApprovedRange(minimum: 0, maximum: 1600);

/// Builds a dopamine infusion protocol for a chosen dose and preparation.
///
/// * [dosePerKilogramPerMinute] - the prescribed dose in micrograms/kg/minute.
/// * [preparationVolumeMillilitres] - syringe volume, 50 mL in the inherited
///   preparation.
/// * [rateMillilitresPerHour] - the intended pump rate, 1 mL/hour in the
///   inherited preparation.
WeightBasedInfusionProtocol dopamineInfusion({
  required double dosePerKilogramPerMinute,
  double preparationVolumeMillilitres = 50,
  double rateMillilitresPerHour = 1,
}) {
  return WeightBasedInfusionProtocol(
    protocolId: dopamineInfusionProtocolId,
    dosePerKilogram: dosePerKilogramPerMinute,
    doseUnit: DoseUnit.micrograms,
    timeBasis: DoseTimeBasis.minute,
    approvedDosePerKilogram: dopamineApprovedDose,
    approvedConcentrationPerMillilitre: dopamineApprovedConcentration,
    preparationVolumeMillilitres: preparationVolumeMillilitres,
    rateMillilitresPerHour: rateMillilitresPerHour,
    approvedRoutes: const {AdministrationRoute.intravenous},
    approvedAccess: const {
      VascularAccess.central,
      VascularAccess.umbilicalVenous,
    },
  );
}
