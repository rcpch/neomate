// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Clinical source IDs: SRC-002
// Clinical content IDs: CALC-ELECTROLYTE-REQUIREMENT
// Clinical reviewer: none
// Clinical sign-off: none
// Review due: none
// Safety hazards: none assigned
//
// ---------------------------------------------------------------------------
// STATUS: NOT APPROVED FOR CLINICAL USE. No source assigned, no clinical
// reviewer, no sign-off. See spec/clinical-source-convention.md.
// ---------------------------------------------------------------------------
// Calculation : Daily electrolyte requirement for a given patient.
// Formula     : mmol/day = prescribed mmol/kg/day x weight in kg
//
// Reviewer notes:
//   * This module converts a prescription into a daily amount. It does NOT
//     decide how much of any electrolyte a baby needs. That depends on day of
//     life, gestation, renal function, serum levels, and local policy, and is
//     supplied by the caller from a reviewed content record.
//   * The electrolyte is named only so the result can be labelled and so a
//     prescription for one electrolyte cannot be silently applied to another.
//     No electrolyte-specific behaviour or default exists in this file.
//   * Converting the resulting amount into a volume of a stock preparation is
//     deliberately a separate file, additive_volume.dart, so that the
//     prescription arithmetic and the compounding arithmetic can be reviewed
//     independently.
// ---------------------------------------------------------------------------

import '../calculation_outcome.dart';
import '../patient_context.dart';

/// The electrolytes this module can label a requirement with.
///
/// Present for labelling and mismatch protection only. Adding a member grants
/// no clinical capability by itself.
enum Electrolyte { sodium, potassium, chloride, calcium, magnesium, phosphate }

/// A daily requirement for one named electrolyte, in millimoles.
class ElectrolyteRequirement {
  const ElectrolyteRequirement({
    required this.electrolyte,
    required this.millimolesPerDay,
  });

  final Electrolyte electrolyte;
  final double millimolesPerDay;
}

/// Converts a prescribed mmol/kg/day into a total daily requirement.
///
/// * [patient] - supplies the validated weight.
/// * [electrolyte] - the electrolyte being prescribed, used to label the
///   result.
/// * [prescribedMillimolesPerKilogramPerDay] - taken from the applicable
///   reviewed policy.
CalculationOutcome<ElectrolyteRequirement> calculateElectrolyteRequirement({
  required PatientContext patient,
  required Electrolyte electrolyte,
  required double prescribedMillimolesPerKilogramPerDay,
}) {
  if (!prescribedMillimolesPerKilogramPerDay.isFinite) {
    return const CalculationRejected(CalculationIssue.notFinite);
  }

  // Zero is rejected rather than returned as "no electrolyte required": a
  // prescription of none should not reach a compounding step at all, and
  // negatives are meaningless.
  if (prescribedMillimolesPerKilogramPerDay <= 0) {
    return const CalculationRejected(CalculationIssue.nonPositiveInput);
  }

  final millimolesPerDay =
      prescribedMillimolesPerKilogramPerDay * patient.weight.kilograms;

  if (!millimolesPerDay.isFinite) {
    return const CalculationRejected(CalculationIssue.notComputable);
  }

  return CalculationValue(
    ElectrolyteRequirement(
      electrolyte: electrolyte,
      millimolesPerDay: millimolesPerDay,
    ),
  );
}
