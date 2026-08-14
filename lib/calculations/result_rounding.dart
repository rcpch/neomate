// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Clinical source IDs: none assigned
// Clinical content IDs: CALC-RESULT-ROUNDING
// Clinical reviewer: none
// Clinical sign-off: none
// Review due: none
// Safety hazards: HZ-001, HZ-004
//
// ---------------------------------------------------------------------------
// STATUS: NOT APPROVED FOR CLINICAL USE. No source assigned, no clinical
// reviewer, no sign-off. See spec/clinical-source-convention.md.
// ---------------------------------------------------------------------------
// Calculation : Rounding and textual presentation of a calculated clinical
//               number.
//
// Reviewer notes:
//   * Rounding is a clinical act, not a formatting detail. The number a
//     clinician draws up is the rounded one, so this module is listed for
//     clinical sign-off alongside the formulas themselves.
//   * Three specific failures are refused rather than displayed:
//       1. A non-zero amount that rounds to zero. Displaying "0" invites
//          giving nothing when a small dose was genuinely calculated. The
//          caller must offer more decimal places or a smaller unit.
//       2. Exponent notation. Dart's default `toString` produces forms such as
//          "1e-7", which is not a drawable volume and is easily misread.
//       3. Non-finite values, which cannot reach a display at all.
//   * Ties round half away from zero, matching what a clinician does by hand,
//     so 2.5 becomes 3 rather than 2. Note that a decimal such as 0.145 may
//     not be exactly representable as a binary double, so a tie in decimal is
//     not always a tie in the stored value; this is inherent to floating point
//     and is why the precision required must come from the reviewed record
//     rather than being pushed as far as the format allows.
//   * The number of decimal places is supplied by the caller, from the
//     reviewed record for the calculation concerned. There is no default:
//     the right precision for a syringe volume is not the right precision for
//     a daily fluid total.
// ---------------------------------------------------------------------------

import 'calculation_outcome.dart';

/// Largest number of decimal places this module will produce.
///
/// Beyond this, the trailing digits carry no clinical meaning and make a
/// number harder to read at the cot side.
const int _maximumDecimalPlaces = 6;

/// A calculated value together with the text that should be displayed for it.
class RoundedResult {
  const RoundedResult({required this.value, required this.text});

  /// The value after rounding. Callers that carry a result forward into
  /// another calculation should use the unrounded original, not this, to avoid
  /// compounding rounding error.
  final double value;

  /// The text to display. Never uses exponent notation.
  final String text;
}

/// Rounds [value] to [decimalPlaces] for display.
///
/// Refuses when [value] is not finite, when [decimalPlaces] is negative or
/// beyond [_maximumDecimalPlaces], or when a non-zero [value] would round to
/// zero at the requested precision.
CalculationOutcome<RoundedResult> roundForDisplay({
  required double value,
  required int decimalPlaces,
}) {
  if (!value.isFinite) {
    return const CalculationRejected(CalculationIssue.notFinite);
  }

  if (decimalPlaces < 0 || decimalPlaces > _maximumDecimalPlaces) {
    return const CalculationRejected(CalculationIssue.inputOutOfRange);
  }

  final rounded = _roundHalfAwayFromZero(value, decimalPlaces);

  // A true zero is a legitimate result to display; a value that has been
  // rounded away to zero is not.
  if (rounded == 0 && value != 0) {
    return const CalculationRejected(CalculationIssue.inputOutOfRange);
  }

  // toStringAsFixed is used rather than toString because it never produces
  // exponent notation and always shows the requested precision, so "2.50"
  // does not silently become "2.5" on one screen and "2.50" on another.
  return CalculationValue(
    RoundedResult(value: rounded, text: rounded.toStringAsFixed(decimalPlaces)),
  );
}

/// Rounds half away from zero, as a person rounding by hand would.
///
/// Dart's `double.round()` rounds halves away from zero already, but only to
/// whole numbers; scaling by a power of ten first is what extends that to
/// decimal places.
double _roundHalfAwayFromZero(double value, int decimalPlaces) {
  final scale = _powerOfTen(decimalPlaces);
  final scaled = value * scale;
  if (!scaled.isFinite) {
    // A very large value scaled beyond the double range: fall back to the
    // unscaled value rather than producing infinity.
    return value;
  }
  return scaled.round() / scale;
}

/// Integer powers of ten, computed by repeated multiplication so that the
/// result is exact for the range permitted here.
double _powerOfTen(int exponent) {
  var result = 1.0;
  for (var i = 0; i < exponent; i++) {
    result *= 10;
  }
  return result;
}
