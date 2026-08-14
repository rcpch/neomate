// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Clinical source IDs: none assigned
// Clinical content IDs: CALC-MEAN-AIRWAY-PRESSURE
// Clinical reviewer: none
// Clinical sign-off: none
// Review due: none
// Safety hazards: none assigned
//
// ---------------------------------------------------------------------------
// STATUS: NOT APPROVED FOR CLINICAL USE. No source assigned, no clinical
// reviewer, no sign-off. See spec/clinical-source-convention.md.
// ---------------------------------------------------------------------------
// Calculation : Mean airway pressure (MAP / Paw) during conventional
//               time-cycled pressure-limited ventilation.
// Formula     : MAP = PEEP + ((PIP - PEEP) x Ti / (Ti + Te))
//
// Reviewer notes:
//   * This module implements arithmetic only. It deliberately contains no
//     clinical thresholds, no target ranges, and no advice about what a given
//     MAP means, because those require their own sourced review.
//   * The inherited Neomate implementation performed this calculation inside
//     the UI with no input validation. See
//     spec/legacy-inventory-and-source-review.md.
// ---------------------------------------------------------------------------

import '../calculation_outcome.dart';

/// Plausibility limits for the ventilator settings accepted by this module.
///
/// These are *engineering* guards, not clinical recommendations. Their only
/// purpose is to reject transposed, mistyped, or nonsensical entries (for
/// example a PIP of 200 from a missed decimal point) before they propagate
/// into a derived number such as the oxygenation index. A clinician signing
/// this file off should confirm the bounds are wide enough never to block a
/// real neonatal ventilator setting.
const double _minimumPressureCmH2O = 0;
const double _maximumPressureCmH2O = 80;

/// Longest single inspiratory or expiratory time accepted, in seconds.
const double _maximumPhaseTimeSeconds = 30;

/// Mean airway pressure expressed in cmH2O.
///
/// A dedicated type rather than a raw `double` so that a pressure can never be
/// passed to a function expecting different units without the compiler
/// objecting.
class MeanAirwayPressure {
  const MeanAirwayPressure(this.centimetresOfWater);

  final double centimetresOfWater;
}

/// Computes mean airway pressure from conventional ventilator settings.
///
/// * [peakInspiratoryPressureCmH2O] - PIP, in cmH2O.
/// * [positiveEndExpiratoryPressureCmH2O] - PEEP, in cmH2O.
/// * [inspiratoryTimeSeconds] - Ti, in seconds.
/// * [expiratoryTimeSeconds] - Te, in seconds. Callers holding a ventilator
///   rate and Ti should derive Te as `(60 / rate) - Ti` before calling; that
///   conversion is intentionally not done here so this file stays a single
///   formula that a clinician can read in full.
///
/// Returns a [CalculationRejected] rather than a value when the settings are
/// not finite, not positive, out of the plausibility bounds above, or
/// internally inconsistent (PEEP above PIP).
CalculationOutcome<MeanAirwayPressure> calculateMeanAirwayPressure({
  required double peakInspiratoryPressureCmH2O,
  required double positiveEndExpiratoryPressureCmH2O,
  required double inspiratoryTimeSeconds,
  required double expiratoryTimeSeconds,
}) {
  final inputs = <double>[
    peakInspiratoryPressureCmH2O,
    positiveEndExpiratoryPressureCmH2O,
    inspiratoryTimeSeconds,
    expiratoryTimeSeconds,
  ];
  if (inputs.any((value) => !value.isFinite)) {
    return const CalculationRejected(CalculationIssue.notFinite);
  }

  // Both phase times must be strictly positive: a zero or negative time has no
  // physical meaning and would make the duty cycle undefined.
  if (inspiratoryTimeSeconds <= 0 || expiratoryTimeSeconds <= 0) {
    return const CalculationRejected(CalculationIssue.nonPositiveInput);
  }

  if (_isOutsidePressureBounds(peakInspiratoryPressureCmH2O) ||
      _isOutsidePressureBounds(positiveEndExpiratoryPressureCmH2O) ||
      inspiratoryTimeSeconds > _maximumPhaseTimeSeconds ||
      expiratoryTimeSeconds > _maximumPhaseTimeSeconds) {
    return const CalculationRejected(CalculationIssue.inputOutOfRange);
  }

  // PEEP above PIP describes an impossible pressure waveform and is most often
  // the two values entered the wrong way round. Rejecting it prevents a
  // plausible-looking but wrong MAP being carried into the oxygenation index.
  if (positiveEndExpiratoryPressureCmH2O > peakInspiratoryPressureCmH2O) {
    return const CalculationRejected(CalculationIssue.inconsistentInputs);
  }

  // Fraction of each breath spent in inspiration; 0 < dutyCycle < 1 given the
  // positivity checks above.
  final dutyCycle =
      inspiratoryTimeSeconds / (inspiratoryTimeSeconds + expiratoryTimeSeconds);

  final meanPressure = positiveEndExpiratoryPressureCmH2O +
      ((peakInspiratoryPressureCmH2O - positiveEndExpiratoryPressureCmH2O) *
          dutyCycle);

  if (!meanPressure.isFinite) {
    return const CalculationRejected(CalculationIssue.notComputable);
  }

  return CalculationValue(MeanAirwayPressure(meanPressure));
}

bool _isOutsidePressureBounds(double pressureCmH2O) =>
    pressureCmH2O < _minimumPressureCmH2O ||
    pressureCmH2O > _maximumPressureCmH2O;
