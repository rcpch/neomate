// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Clinical source IDs: SRC-006, SRC-009
// Clinical content IDs: PROTOCOL-CLONAZEPAM-INFUSION
// Clinical reviewer: none
// Clinical sign-off: none
// Review due: none
// Safety hazards: HZ-001, HZ-006, HZ-007
//
// ---------------------------------------------------------------------------
// STATUS: NOT APPROVED FOR CLINICAL USE. Inherited baseline, no clinical
// reviewer, no sign-off. See spec/clinical-source-convention.md.
// ---------------------------------------------------------------------------
// Protocol   : Clonazepam continuous intravenous infusion.
// Dose range : 10 to 40 micrograms/kg/hour.
// Limit      : 12 micrograms/mL.
//
// Reviewer notes:
//   * Values are carried forward from the shipped Dart Neomate product
//     (SRC-006), which attributes the concentration limit to Medusa 2015
//     (SRC-009). Confirm against current sources and local formulary.
//   * The inherited 0.6 mg in 50 mL field converts to 12 micrograms/mL.
//   * The preceding Ionic product contained a clonazepam preparation but had
//     its direct display code commented out. Confirm whether this protocol was
//     intentionally retired before any clinical use.
//   * This unreviewed alpha conservatively permits only central or umbilical
//     venous access until route and access policy is independently confirmed.
// ---------------------------------------------------------------------------

import '../../calculations/protocol_calculation.dart';

const String clonazepamInfusionProtocolId = 'PROTOCOL-CLONAZEPAM-INFUSION';

const ApprovedRange clonazepamApprovedDose =
    ApprovedRange(minimum: 10, maximum: 40);

const ApprovedRange clonazepamApprovedConcentration =
    ApprovedRange(minimum: 0, maximum: 12);

WeightBasedInfusionProtocol clonazepamInfusion({
  required double dosePerKilogramPerHour,
  double preparationVolumeMillilitres = 50,
  double rateMillilitresPerHour = 1,
}) {
  return WeightBasedInfusionProtocol(
    protocolId: clonazepamInfusionProtocolId,
    dosePerKilogram: dosePerKilogramPerHour,
    doseUnit: DoseUnit.micrograms,
    timeBasis: DoseTimeBasis.hour,
    approvedDosePerKilogram: clonazepamApprovedDose,
    approvedConcentrationPerMillilitre: clonazepamApprovedConcentration,
    preparationVolumeMillilitres: preparationVolumeMillilitres,
    rateMillilitresPerHour: rateMillilitresPerHour,
    approvedRoutes: const {AdministrationRoute.intravenous},
    approvedAccess: const {
      VascularAccess.central,
      VascularAccess.umbilicalVenous,
    },
  );
}
