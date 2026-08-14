// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Clinical source IDs: SRC-006, SRC-009
// Clinical content IDs: PROTOCOL-DOBUTAMINE-INFUSION
// Clinical reviewer: none
// Clinical sign-off: none
// Review due: none
// Safety hazards: HZ-001, HZ-006
//
// ---------------------------------------------------------------------------
// STATUS: NOT APPROVED FOR CLINICAL USE. Inherited baseline, no clinical
// reviewer, no sign-off. See spec/clinical-source-convention.md.
// ---------------------------------------------------------------------------
// Protocol    : Dobutamine continuous intravenous infusion.
// Dose range  : 2 to 20 micrograms/kg/minute.
// Limit       : Concentrations above 10 mg/mL are not commonly used.
//
// Reviewer notes:
//   * Carried forward from the shipped Neomate product (SRC-006). The
//     inherited code attributes the concentration limit to the Injectable
//     Medicines Guide, 2015 (SRC-009). Confirm against the current edition.
//   * The inherited limit is a maximum amount in a 50 mL syringe (500 mg per
//     50 mL), converted here to a concentration per millilitre so it holds
//     whatever syringe size is used:
//         500 mg / 50 mL = 10 mg/mL = 10 000 micrograms/mL
//   * The inherited guidance describes administration via a central line.
//     Peripheral access is therefore not approved in this record.
// ---------------------------------------------------------------------------

import '../../calculations/protocol_calculation.dart';

/// Identifier used in the protocol registry and in test evidence.
const String dobutamineInfusionProtocolId = 'PROTOCOL-DOBUTAMINE-INFUSION';

/// Approved dose range in micrograms/kg/minute.
const ApprovedRange dobutamineApprovedDose =
    ApprovedRange(minimum: 2, maximum: 20);

/// Approved concentration range in micrograms per millilitre.
const ApprovedRange dobutamineApprovedConcentration =
    ApprovedRange(minimum: 0, maximum: 10000);

/// Builds a dobutamine infusion protocol for a chosen dose and preparation.
WeightBasedInfusionProtocol dobutamineInfusion({
  required double dosePerKilogramPerMinute,
  double preparationVolumeMillilitres = 50,
  double rateMillilitresPerHour = 1,
}) {
  return WeightBasedInfusionProtocol(
    protocolId: dobutamineInfusionProtocolId,
    dosePerKilogram: dosePerKilogramPerMinute,
    doseUnit: DoseUnit.micrograms,
    timeBasis: DoseTimeBasis.minute,
    approvedDosePerKilogram: dobutamineApprovedDose,
    approvedConcentrationPerMillilitre: dobutamineApprovedConcentration,
    preparationVolumeMillilitres: preparationVolumeMillilitres,
    rateMillilitresPerHour: rateMillilitresPerHour,
    approvedRoutes: const {AdministrationRoute.intravenous},
    approvedAccess: const {
      VascularAccess.central,
      VascularAccess.umbilicalVenous,
    },
  );
}
