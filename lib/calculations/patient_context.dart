// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Clinical source IDs: none assigned
// Clinical content IDs: CALC-PATIENT-WEIGHT
// Clinical reviewer: none
// Clinical sign-off: none
// Review due: none
// Safety hazards: none assigned
//
// ---------------------------------------------------------------------------
// STATUS: NOT APPROVED FOR CLINICAL USE. No source assigned, no clinical
// reviewer, no sign-off. See spec/clinical-source-convention.md.
// ---------------------------------------------------------------------------
// Module  : Patient weight validation and patient context.
// Purpose : Establish a single validated weight that every other calculation
//           depends on, and convert grams to kilograms in exactly one place.
// Source  : The permitted weight range is NOT defined here. It is supplied by
//           the caller as a [WeightPolicy] carrying the id of the reviewed
//           source that set it.
//
// Reviewer notes:
//   * Weight is the input every weight-based dose and fluid calculation
//     multiplies by, so an unvalidated weight is the highest-consequence input
//     in the product. It is validated once, here, and thereafter carried as a
//     [PatientWeight] that cannot be constructed except through validation.
//   * The inherited app hard-coded a 200-6000 g range in the user interface.
//     That figure is not reproduced here: embedding an unsourced range would
//     make it invisible to review.
// ---------------------------------------------------------------------------

/// Whether the weight was measured on scales or estimated.
///
/// Recorded because an estimated weight carries more uncertainty into every
/// derived figure, and the interface is expected to say so.
enum WeightOrigin { measured, estimated }

/// Why a proposed weight was refused.
enum WeightValidationIssue { notFinite, belowMinimum, aboveMaximum }

/// The permitted weight range, together with the reviewed source that set it.
///
/// [sourceId] is mandatory so that a range can never enter the product without
/// a traceable origin.
class WeightPolicy {
  const WeightPolicy({
    required this.minimumGrams,
    required this.maximumGrams,
    required this.sourceId,
  })  : assert(minimumGrams >= 0),
        assert(maximumGrams >= minimumGrams),
        assert(sourceId != '');

  final double minimumGrams;
  final double maximumGrams;
  final String sourceId;
}

/// The outcome of validating a proposed weight.
sealed class WeightValidationResult {
  const WeightValidationResult();
}

class ValidWeight extends WeightValidationResult {
  const ValidWeight(this.weight);

  final PatientWeight weight;
}

class InvalidWeight extends WeightValidationResult {
  const InvalidWeight(this.issue);

  final WeightValidationIssue issue;
}

/// A weight that has passed validation against a [WeightPolicy].
///
/// The constructor is private, so the only way to obtain one is through
/// [validate]. Downstream calculations can therefore take a [PatientWeight]
/// and rely on it being within an approved range without re-checking.
class PatientWeight {
  const PatientWeight._(this.grams);

  /// Weight in grams, the unit clinicians enter at the cot side.
  final double grams;

  /// Weight in kilograms, the unit dose and fluid formulas are defined in.
  ///
  /// This conversion exists only here so that a factor-of-1000 error cannot be
  /// introduced independently in several calculators.
  double get kilograms => grams / 1000;

  /// Validates a proposed weight in grams against [policy].
  ///
  /// Bounds are inclusive: a weight exactly on the minimum or maximum is
  /// accepted.
  static WeightValidationResult validate({
    required double grams,
    required WeightPolicy policy,
  }) {
    if (!grams.isFinite) {
      return const InvalidWeight(WeightValidationIssue.notFinite);
    }
    if (grams < policy.minimumGrams) {
      return const InvalidWeight(WeightValidationIssue.belowMinimum);
    }
    if (grams > policy.maximumGrams) {
      return const InvalidWeight(WeightValidationIssue.aboveMaximum);
    }
    return ValidWeight(PatientWeight._(grams));
  }
}

/// The patient facts a calculation may depend on.
///
/// Deliberately minimal and held in memory only: Neomate 2 stores no patient
/// data. Additional fields (for example gestation or day of life) are added
/// only when a reviewed calculation needs them.
class PatientContext {
  const PatientContext({required this.weight, required this.weightOrigin});

  final PatientWeight weight;
  final WeightOrigin weightOrigin;
}
