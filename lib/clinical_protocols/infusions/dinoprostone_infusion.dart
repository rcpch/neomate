// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Clinical source IDs: SRC-006, SRC-008
// Clinical content IDs: PROTOCOL-DINOPROSTONE-INFUSION
// Clinical reviewer: none
// Clinical sign-off: none
// Review due: none
// Safety hazards: HZ-001, HZ-006
//
// ---------------------------------------------------------------------------
// STATUS: NOT APPROVED FOR CLINICAL USE. Inherited baseline, no clinical
// reviewer, no sign-off. See spec/clinical-source-convention.md.
// ---------------------------------------------------------------------------
// Protocol    : Dinoprostone (prostaglandin E2) continuous intravenous
//               infusion, to maintain ductal patency.
// Dose range  : 1 to 20 nanograms/kg/minute configured; 5 to 10
//               nanograms/kg/minute described as the usual range.
// Limit       : Dilute to 1 microgram/mL.
//
// Reviewer notes:
//   * DISCREPANCY CARRIED FORWARD, FOR THE REVIEWER TO SETTLE. The inherited
//     product enforced 1-20 nanograms/kg/minute but displayed a usual range of
//     5-10. The wider configured bounds are recorded here. A reviewer should
//     decide whether the configured range, the displayed range, or both
//     are correct.
//   * The inherited concentration limit is 0.05 mg per 50 mL syringe, which is
//     the 1 microgram/mL dilution BNFc recommends:
//         0.05 mg / 50 mL = 0.001 mg/mL = 1 microgram/mL = 1000 nanograms/mL
//   * Attributed to the shipped product (SRC-006), with the concentration
//     advice attributed by the inherited code to BNFc (SRC-008). The cited
//     edition is 2015, so the figures need confirming against the current
//     BNFc.
//   * Central or umbilical venous access only, consistent with the other
//     inherited cardiac infusions.
// ---------------------------------------------------------------------------

import '../../calculations/protocol_calculation.dart';

/// Identifier used in the protocol registry and in test evidence.
const String dinoprostoneInfusionProtocolId = 'PROTOCOL-DINOPROSTONE-INFUSION';

/// Configured dose range in nanograms/kg/minute from the inherited product.
/// Values outside it remain calculable with a review advisory.
const ApprovedRange dinoprostoneApprovedDose =
    ApprovedRange(minimum: 1, maximum: 20);

/// The usual dose range described by the inherited product, in
/// nanograms/kg/minute. Recorded so the discrepancy above stays visible rather
/// than being lost.
const ApprovedRange dinoprostoneUsualDose =
    ApprovedRange(minimum: 5, maximum: 10);

/// Approved concentration range in nanograms per millilitre.
///
/// Upper bound is 1 microgram/mL, derived above.
const ApprovedRange dinoprostoneApprovedConcentration =
    ApprovedRange(minimum: 0, maximum: 1000);

/// Builds a dinoprostone infusion protocol for a chosen dose and preparation.
///
/// * [dosePerKilogramPerMinute] - the prescribed dose in nanograms/kg/minute.
/// * [preparationVolumeMillilitres] - syringe volume, 50 mL in the inherited
///   preparation.
/// * [rateMillilitresPerHour] - the intended pump rate, 1 mL/hour in the
///   inherited preparation.
WeightBasedInfusionProtocol dinoprostoneInfusion({
  required double dosePerKilogramPerMinute,
  double preparationVolumeMillilitres = 50,
  double rateMillilitresPerHour = 1,
}) {
  return WeightBasedInfusionProtocol(
    protocolId: dinoprostoneInfusionProtocolId,
    dosePerKilogram: dosePerKilogramPerMinute,
    doseUnit: DoseUnit.nanograms,
    timeBasis: DoseTimeBasis.minute,
    approvedDosePerKilogram: dinoprostoneApprovedDose,
    approvedConcentrationPerMillilitre: dinoprostoneApprovedConcentration,
    preparationVolumeMillilitres: preparationVolumeMillilitres,
    rateMillilitresPerHour: rateMillilitresPerHour,
    approvedRoutes: const {AdministrationRoute.intravenous},
    approvedAccess: const {
      VascularAccess.central,
      VascularAccess.umbilicalVenous,
    },
  );
}
