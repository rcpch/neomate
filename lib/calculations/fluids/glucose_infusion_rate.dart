// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Clinical source IDs: SRC-001
// Clinical content IDs: CALC-GLUCOSE-INFUSION-RATE
// Clinical reviewer: none
// Clinical sign-off: none
// Review due: none
// Safety hazards: none assigned
//
// ---------------------------------------------------------------------------
// STATUS: NOT APPROVED FOR CLINICAL USE. No source assigned, no clinical
// reviewer, no sign-off. See spec/clinical-source-convention.md.
// ---------------------------------------------------------------------------
// Calculation : Glucose infusion rate (GIR), in mg/kg/min.
// Formula     : GIR = (glucose % w/v x rate mL/hour) / (6 x weight kg)
//
// Reviewer notes:
//   * Derivation of the constant 6, shown in full so a reviewer does not have
//     to take it on trust:
//         glucose "%" means g per 100 mL (w/v)
//         g per hour       = (% / 100) x rate mL/hour
//         mg per hour      = (% / 100) x rate x 1000
//         mg per minute    = (% / 100) x rate x 1000 / 60
//         mg/kg/min        = (% x rate x 1000) / (100 x 60 x kg)
//                          = (% x rate) / (6 x kg)
//   * This module reports the rate only. It contains no target range and no
//     advice on escalation or on maximum tolerated GIR, because those are
//     clinical guidance requiring their own sourced review.
//   * Only the glucose carried by this one infusion is counted. Where a baby
//     receives glucose from several concurrent sources, the caller is
//     responsible for summing them; this file stays a single formula so it can
//     be signed off on its own.
// ---------------------------------------------------------------------------

import '../calculation_outcome.dart';
import '../patient_context.dart';

/// Converts (percent x mL/hour) / kg into mg/kg/min. See the derivation in the
/// review record above.
const double _percentMillilitresPerHourToMilligramsPerMinute = 6;

/// Highest glucose concentration this module will accept, as % w/v.
///
/// An engineering guard: concentrations above 50% are not stock neonatal
/// preparations, and a value above 100 is arithmetically impossible for a w/v
/// percentage.
const double _maximumGlucosePercent = 50;

/// Highest infusion rate accepted, in mL/hour. A guard against a mistyped or
/// transposed pump setting rather than a clinical limit.
const double _maximumRateMillilitresPerHour = 1000;

/// Computes the glucose infusion rate delivered by a single glucose-containing
/// infusion.
///
/// * [patient] - supplies the already-validated weight.
/// * [glucosePercentWeightPerVolume] - the concentration as it is written on
///   the bag, for example `10` for 10% glucose. Not a fraction.
/// * [rateMillilitresPerHour] - the pump rate for that infusion.
///
/// Returns the rate in mg/kg/min.
CalculationOutcome<double> calculateGlucoseInfusionRate({
  required PatientContext patient,
  required double glucosePercentWeightPerVolume,
  required double rateMillilitresPerHour,
}) {
  if (!glucosePercentWeightPerVolume.isFinite ||
      !rateMillilitresPerHour.isFinite) {
    return const CalculationRejected(CalculationIssue.notFinite);
  }

  // A zero concentration delivers no glucose and a zero rate delivers nothing;
  // neither is a meaningful GIR question, and negatives are nonsensical.
  if (glucosePercentWeightPerVolume <= 0 || rateMillilitresPerHour <= 0) {
    return const CalculationRejected(CalculationIssue.nonPositiveInput);
  }

  if (glucosePercentWeightPerVolume > _maximumGlucosePercent ||
      rateMillilitresPerHour > _maximumRateMillilitresPerHour) {
    return const CalculationRejected(CalculationIssue.inputOutOfRange);
  }

  final kilograms = patient.weight.kilograms;
  final glucoseInfusionRate =
      (glucosePercentWeightPerVolume * rateMillilitresPerHour) /
          (_percentMillilitresPerHourToMilligramsPerMinute * kilograms);

  if (!glucoseInfusionRate.isFinite) {
    return const CalculationRejected(CalculationIssue.notComputable);
  }

  return CalculationValue(glucoseInfusionRate);
}
