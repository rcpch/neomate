// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Clinical source IDs: SRC-003, SRC-006, SRC-012
// Clinical content IDs: POLICY-RETIRED-RESUSCITATION-BOLUSES
// Clinical reviewer: none
// Clinical sign-off: none
// Review due: none
// Safety hazards: HZ-002, HZ-007
//
// ---------------------------------------------------------------------------
// STATUS: NOT APPROVED FOR CLINICAL USE. Retirement controls are based on a
// current proposed source but have no named reviewer or sign-off.
// See spec/clinical-source-convention.md.
// ---------------------------------------------------------------------------
// Policy  : Prevent obsolete inherited resuscitation boluses from migrating
//           into the active application while retaining legacy code as audit
//           evidence.
//
// Reviewer notes:
//   * RCUK 2025 states that bicarbonate is no longer recommended in newborn
//     resuscitation. It may still be considered in post-resuscitation care
//     according to local protocols, which is outside this retirement's scope.
//   * The inherited empirical 2.5 mL/kg D10 bolus is also retired. RCUK 2025
//     requires blood glucose measurement where possible and treatment only
//     when low, using 200 mg/kg (2 mL/kg of 10% glucose).
//   * Supporting neonatal literature describes no proven benefit from routine
//     bicarbonate and potential harms including increased CO2 generation,
//     worsened intracellular acidosis when ventilation is inadequate,
//     cerebral blood-flow fluctuation, and intracranial haemorrhage.
// ---------------------------------------------------------------------------

class RetiredClinicalAlgorithm {
  const RetiredClinicalAlgorithm({
    required this.id,
    required this.title,
    required this.retiredOn,
    required this.retiredOutput,
    required this.reason,
    required this.authorityTitle,
    required this.authorityUrl,
    this.supportingEvidenceTitle,
    this.supportingEvidenceUrl,
  });

  final String id;
  final String title;
  final DateTime retiredOn;
  final String retiredOutput;
  final String reason;
  final String authorityTitle;
  final String authorityUrl;
  final String? supportingEvidenceTitle;
  final String? supportingEvidenceUrl;
}

final List<RetiredClinicalAlgorithm> retiredBolusAlgorithms = [
  RetiredClinicalAlgorithm(
    id: 'RETIRED-BOLUS-SODIUM-BICARBONATE-RESUSCITATION',
    title: 'Sodium bicarbonate during newborn resuscitation',
    retiredOn: DateTime.utc(2026, 8, 17),
    retiredOutput:
        'Displayed 2 mL/kg sodium bicarbonate 4.2% and a base-deficit correction formula during emergency care.',
    reason:
        'Unavailable because RCUK 2025 no longer recommends bicarbonate in newborn resuscitation. Supporting neonatal literature reports no proven resuscitation benefit and potential harms including increased carbon dioxide generation and worsened intracellular acidosis when ventilation is inadequate.',
    authorityTitle:
        'RCUK 2025: Newborn resuscitation and support of transition',
    authorityUrl:
        'https://www.resus.org.uk/professional-library/2025-resuscitation-guidelines/newborn-resuscitation-and-support-transition-infants-birth',
    supportingEvidenceTitle:
        'Al-Shehri et al. 2023: intravenous sodium bicarbonate therapy in neonatal intensive care units',
    supportingEvidenceUrl: 'https://pmc.ncbi.nlm.nih.gov/articles/PMC10662854/',
  ),
  RetiredClinicalAlgorithm(
    id: 'RETIRED-BOLUS-EMPIRICAL-DEXTROSE-10',
    title: 'Empirical 2.5 mL/kg D10 resuscitation bolus',
    retiredOn: DateTime.utc(2026, 8, 17),
    retiredOutput:
        'Displayed 2.5 mL/kg of 10% dextrose as an emergency bolus without a blood-glucose condition.',
    reason:
        'Unavailable because RCUK 2025 emphasises checking blood glucose and treating only when it is low. Its specified treatment is 200 mg/kg, equivalent to 2 mL/kg of 10% glucose, not the empirical 2.5 mL/kg output. No replacement dose calculator is available without clinical sign-off.',
    authorityTitle:
        'RCUK 2025: Newborn resuscitation and support of transition',
    authorityUrl:
        'https://www.resus.org.uk/professional-library/2025-resuscitation-guidelines/newborn-resuscitation-and-support-transition-infants-birth',
  ),
];
