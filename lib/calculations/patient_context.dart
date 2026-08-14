// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

enum WeightOrigin { measured, estimated }

enum WeightValidationIssue { notFinite, belowMinimum, aboveMaximum }

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

class PatientWeight {
  const PatientWeight._(this.grams);

  final double grams;

  double get kilograms => grams / 1000;

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

class PatientContext {
  const PatientContext({required this.weight, required this.weightOrigin});

  final PatientWeight weight;
  final WeightOrigin weightOrigin;
}
