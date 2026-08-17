// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Clinical source IDs: SRC-002
// Clinical content IDs: CALC-DAILY-FLUID-VOLUME
// Clinical reviewer: none
// Clinical sign-off: none
// Review due: none
// Safety hazards: none assigned
//
// ---------------------------------------------------------------------------
// STATUS: NOT APPROVED FOR CLINICAL USE. No source assigned, no clinical
// reviewer, no sign-off. See spec/clinical-source-convention.md.
// ---------------------------------------------------------------------------
// Calculation : Total daily fluid volume and the corresponding continuous
//               infusion rate, from a prescribed volume per kilogram.
// Formula     : total mL/day  = prescribed mL/kg/day x weight in kg
//               rate mL/hour  = total mL/day / 24
//
// Reviewer notes:
//   * This module does NOT decide how many mL/kg/day a baby should receive.
//     That figure depends on day of life, gestation, and local neonatal fluid
//     policy, and is supplied by the caller from a reviewed content record.
//     Hard-coding a
//     day-of-life table here would embed one network's policy into the product
//     for every user, which the inherited app effectively did.
//   * The 24-hour divisor assumes a continuous infusion running over a full
//     day. Intermittent or split regimens are out of scope for this file.
// ---------------------------------------------------------------------------

import '../calculation_outcome.dart';
import '../patient_context.dart';

/// Hours in the prescribing day, used to convert a daily volume to an hourly
/// rate. Named rather than written as a bare `24` so the assumption is
/// visible to a reviewer.
const double _hoursPerDay = 24;

/// A prescribed daily fluid allowance and the pump rate that delivers it.
class DailyFluidVolume {
  const DailyFluidVolume({
    required this.totalMillilitresPerDay,
    required this.millilitresPerHour,
  });

  /// Total volume the baby is prescribed over 24 hours.
  final double totalMillilitresPerDay;

  /// Continuous rate that delivers [totalMillilitresPerDay] over 24 hours.
  final double millilitresPerHour;
}

/// Converts a prescribed volume per kilogram per day into a total volume and
/// an hourly rate for the given patient.
///
/// * [patient] - supplies the validated weight. Weight validity, including its
///   permitted range, is already enforced by [PatientWeight.validate].
/// * [prescribedMillilitresPerKilogramPerDay] - the figure taken from the
///   applicable reviewed fluid policy.
CalculationOutcome<DailyFluidVolume> calculateDailyFluidVolume({
  required PatientContext patient,
  required double prescribedMillilitresPerKilogramPerDay,
}) {
  if (!prescribedMillilitresPerKilogramPerDay.isFinite) {
    return const CalculationRejected(CalculationIssue.notFinite);
  }

  if (prescribedMillilitresPerKilogramPerDay <= 0) {
    return const CalculationRejected(CalculationIssue.nonPositiveInput);
  }

  final totalPerDay =
      prescribedMillilitresPerKilogramPerDay * patient.weight.kilograms;
  final perHour = totalPerDay / _hoursPerDay;

  if (!totalPerDay.isFinite || !perHour.isFinite) {
    return const CalculationRejected(CalculationIssue.notComputable);
  }

  return CalculationValue(
    DailyFluidVolume(
      totalMillilitresPerDay: totalPerDay,
      millilitresPerHour: perHour,
    ),
  );
}
