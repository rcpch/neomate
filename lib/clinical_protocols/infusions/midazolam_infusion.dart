// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Clinical source IDs: SRC-006, SRC-008, SRC-009
// Clinical content IDs: PROTOCOL-MIDAZOLAM-INFUSION
// Clinical reviewer: none
// Clinical sign-off: none
// Review due: none
// Safety hazards: HZ-001, HZ-006, HZ-007
//
// ---------------------------------------------------------------------------
// STATUS: NOT APPROVED FOR CLINICAL USE. Inherited baseline, no clinical
// reviewer, no sign-off. See spec/clinical-source-convention.md.
// ---------------------------------------------------------------------------
// Protocol   : Midazolam continuous intravenous infusion.
// Configured : 30 to 300 micrograms/kg/hour, shown as a review advisory.
// Limit      : 1 mg/mL.
//
// Reviewer notes:
//   * Values are carried forward from the shipped Neomate products (SRC-006),
//     which attribute medicines guidance to BNFc and Medusa 2015 (SRC-008 and
//     SRC-009). Confirm against current sources and local formulary.
//   * The inherited 50 mg in 50 mL field converts to 1 mg/mL.
//   * DISCREPANCY CARRIED FORWARD. The Ionic UI and numeric fields stated
//     30-300 micrograms/kg/hour, its database narrative stated 10-60, and the
//     Dart successor displayed 30-60 while retaining numeric bounds of 30-300.
//     The shared 30-300 numeric bounds are recorded here; all ranges require
//     independent clinical resolution.
//   * Central and umbilical venous access are recorded as the configured use;
//     other selections remain calculable with an advisory for review.
// ---------------------------------------------------------------------------

import '../../calculations/protocol_calculation.dart';

const String midazolamInfusionProtocolId = 'PROTOCOL-MIDAZOLAM-INFUSION';

const ApprovedRange midazolamApprovedDose =
    ApprovedRange(minimum: 30, maximum: 300);

const ApprovedRange midazolamDisplayedDose =
    ApprovedRange(minimum: 30, maximum: 60);

const ApprovedRange midazolamApprovedConcentration =
    ApprovedRange(minimum: 0, maximum: 1000);

WeightBasedInfusionProtocol midazolamInfusion({
  required double dosePerKilogramPerHour,
  double preparationVolumeMillilitres = 50,
  double rateMillilitresPerHour = 0.1,
}) {
  return WeightBasedInfusionProtocol(
    protocolId: midazolamInfusionProtocolId,
    dosePerKilogram: dosePerKilogramPerHour,
    doseUnit: DoseUnit.micrograms,
    timeBasis: DoseTimeBasis.hour,
    approvedDosePerKilogram: midazolamApprovedDose,
    approvedConcentrationPerMillilitre: midazolamApprovedConcentration,
    preparationVolumeMillilitres: preparationVolumeMillilitres,
    rateMillilitresPerHour: rateMillilitresPerHour,
    approvedRoutes: const {AdministrationRoute.intravenous},
    approvedAccess: const {
      VascularAccess.central,
      VascularAccess.umbilicalVenous,
    },
  );
}
