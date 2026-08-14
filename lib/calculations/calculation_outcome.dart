// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

/// Shared result type for the pure calculation modules.
///
/// Every calculation in `lib/calculations/` returns a [CalculationOutcome]
/// rather than a bare number. This exists so that a calculation can never
/// silently produce a misleading value: an input that is out of range, not
/// finite, or clinically implausible produces a [CalculationRejected] that the
/// user interface must handle explicitly. There is deliberately no "default"
/// or "best effort" answer.
///
/// Rationale (clinical safety): a partially-valid numeric answer displayed on
/// a resuscitation screen is more dangerous than no answer at all, because the
/// clinician has no way to tell that the inputs were unsound.
library;

/// The reason a calculation refused to produce a value.
///
/// These are deliberately generic and unit-agnostic. A calculation module adds
/// meaning by choosing which issue applies; the presentation layer is
/// responsible for wording the message for the specific input field.
enum CalculationIssue {
  /// An input was NaN or infinite, typically from a division elsewhere or from
  /// parsing free text such as "." or "1e999".
  notFinite,

  /// An input must be greater than zero (for example a ventilator inspiratory
  /// time) but was zero or negative.
  nonPositiveInput,

  /// An input was outside the range the module is willing to accept. The range
  /// is documented in the module that raised it.
  inputOutOfRange,

  /// The combination of inputs is internally inconsistent, for example a
  /// peak pressure lower than the end-expiratory pressure it is measured
  /// against.
  inconsistentInputs,

  /// The computation itself produced a non-finite value even though the inputs
  /// were individually acceptable. This is a defensive guard and should not
  /// occur in normal operation.
  notComputable,
}

/// The outcome of a single pure calculation.
sealed class CalculationOutcome<T> {
  const CalculationOutcome();
}

/// A successfully computed value.
class CalculationValue<T> extends CalculationOutcome<T> {
  const CalculationValue(this.value);

  final T value;
}

/// A refusal to compute, carrying the reason.
class CalculationRejected<T> extends CalculationOutcome<T> {
  const CalculationRejected(this.issue);

  final CalculationIssue issue;
}
