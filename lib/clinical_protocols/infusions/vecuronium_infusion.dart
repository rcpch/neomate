// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Clinical source IDs: SRC-006, SRC-008
// Clinical content IDs: PROTOCOL-VECURONIUM-INFUSION
// Clinical reviewer: none
// Clinical sign-off: none
// Review due: none
// Safety hazards: HZ-001, HZ-006
//
// ---------------------------------------------------------------------------
// STATUS: NOT APPROVED FOR CLINICAL USE. Inherited baseline, no clinical
// reviewer, no sign-off. See spec/clinical-source-convention.md.
// ---------------------------------------------------------------------------
// Protocol   : Vecuronium continuous intravenous infusion.
// Dose range : 50 to 200 micrograms/kg/hour.
// Limit      : 2 mg/mL, from the inherited human-readable BNFc 2015 warning.
//
// Reviewer notes:
//   * Values are carried forward from the shipped Neomate product (SRC-006),
//     which attributes its concentration advice to BNFc 2015 (SRC-008).
//     Confirm against current sources and the approved local formulary.
//   * DISCREPANCY CARRIED FORWARD. Numeric fields represented 4-200 mg in a
//     50 mL syringe (80 micrograms/mL to 4 mg/mL), while their accompanying
//     text said not below 40 micrograms/mL and ideally not above 2 mg/mL. The
//     stricter human-readable 2 mg/mL ceiling is enforced here. No minimum
//     concentration is enforced pending clinical resolution.
//   * The original Ionic product showed a fixed preparation of 5 mg per
//     kilogram in 50 mL at 1 mL/hour to deliver 100 micrograms/kg/hour.
//   * Vecuronium causes paralysis and provides neither analgesia nor sedation.
//     The UI must state this explicitly wherever this protocol is exposed.
//   * This unreviewed alpha conservatively permits only central or umbilical
//     venous access until route and access policy is independently confirmed.
// ---------------------------------------------------------------------------

import '../../calculations/protocol_calculation.dart';

const String vecuroniumInfusionProtocolId = 'PROTOCOL-VECURONIUM-INFUSION';

const ApprovedRange vecuroniumApprovedDose =
    ApprovedRange(minimum: 50, maximum: 200);

const ApprovedRange vecuroniumApprovedConcentration =
    ApprovedRange(minimum: 0, maximum: 2000);

WeightBasedInfusionProtocol vecuroniumInfusion({
  required double dosePerKilogramPerHour,
  double preparationVolumeMillilitres = 50,
  double rateMillilitresPerHour = 1,
}) {
  return WeightBasedInfusionProtocol(
    protocolId: vecuroniumInfusionProtocolId,
    dosePerKilogram: dosePerKilogramPerHour,
    doseUnit: DoseUnit.micrograms,
    timeBasis: DoseTimeBasis.hour,
    approvedDosePerKilogram: vecuroniumApprovedDose,
    approvedConcentrationPerMillilitre: vecuroniumApprovedConcentration,
    preparationVolumeMillilitres: preparationVolumeMillilitres,
    rateMillilitresPerHour: rateMillilitresPerHour,
    approvedRoutes: const {AdministrationRoute.intravenous},
    approvedAccess: const {
      VascularAccess.central,
      VascularAccess.umbilicalVenous,
    },
  );
}
