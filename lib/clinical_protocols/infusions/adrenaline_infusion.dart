// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Clinical source IDs: SRC-006, SRC-009
// Clinical content IDs: PROTOCOL-ADRENALINE-INFUSION
// Clinical reviewer: none
// Clinical sign-off: none
// Review due: none
// Safety hazards: HZ-001, HZ-006
//
// ---------------------------------------------------------------------------
// STATUS: NOT APPROVED FOR CLINICAL USE. Inherited baseline, no clinical
// reviewer, no sign-off. See spec/clinical-source-convention.md.
// ---------------------------------------------------------------------------
// Protocol    : Adrenaline continuous intravenous infusion.
// Dose range  : 50 to 500 nanograms/kg/minute.
// Limit       : More than 12 mg in 50 mL is not usually recommended.
//
// Reviewer notes:
//   * Carried forward from the shipped Neomate product (SRC-006), which
//     attributes the concentration limit to the Injectable Medicines Guide,
//     2015 (SRC-009). Confirm against the current edition.
//   * Note the units: this infusion is prescribed in NANOGRAMS/kg/minute,
//     whereas dopamine and dobutamine are in micrograms/kg/minute. A
//     thousand-fold error here is the specific hazard, which is why the dose
//     unit is part of the protocol record rather than a display string.
//   * Concentration limit converted for the engine, which compares per
//     millilitre and reports an advisory:
//         12 mg / 50 mL = 0.24 mg/mL = 240 000 nanograms/mL
//   * Central-line administration is the configured use. Other access remains
//     calculable with an advisory. This is the infusion protocol; bolus
//     adrenaline in resuscitation is a separate record with different routes.
// ---------------------------------------------------------------------------

import '../../calculations/protocol_calculation.dart';

/// Identifier used in the protocol registry and in test evidence.
const String adrenalineInfusionProtocolId = 'PROTOCOL-ADRENALINE-INFUSION';

/// Approved dose range in nanograms/kg/minute.
const ApprovedRange adrenalineApprovedDose =
    ApprovedRange(minimum: 50, maximum: 500);

/// Approved concentration range in nanograms per millilitre.
const ApprovedRange adrenalineApprovedConcentration =
    ApprovedRange(minimum: 0, maximum: 240000);

/// Builds an adrenaline infusion protocol for a chosen dose and preparation.
WeightBasedInfusionProtocol adrenalineInfusion({
  required double dosePerKilogramPerMinute,
  double preparationVolumeMillilitres = 50,
  double rateMillilitresPerHour = 0.1,
}) {
  return WeightBasedInfusionProtocol(
    protocolId: adrenalineInfusionProtocolId,
    dosePerKilogram: dosePerKilogramPerMinute,
    doseUnit: DoseUnit.nanograms,
    timeBasis: DoseTimeBasis.minute,
    approvedDosePerKilogram: adrenalineApprovedDose,
    approvedConcentrationPerMillilitre: adrenalineApprovedConcentration,
    preparationVolumeMillilitres: preparationVolumeMillilitres,
    rateMillilitresPerHour: rateMillilitresPerHour,
    approvedRoutes: const {AdministrationRoute.intravenous},
    approvedAccess: const {
      VascularAccess.central,
      VascularAccess.umbilicalVenous,
    },
  );
}
