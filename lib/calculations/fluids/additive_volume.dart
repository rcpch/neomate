// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Clinical source IDs: none assigned
// Clinical content IDs: CALC-ADDITIVE-VOLUME
// Clinical reviewer: none
// Clinical sign-off: none
// Review due: none
// Safety hazards: none assigned
//
// ---------------------------------------------------------------------------
// STATUS: NOT APPROVED FOR CLINICAL USE. No source assigned, no clinical
// reviewer, no sign-off. See spec/clinical-source-convention.md.
// ---------------------------------------------------------------------------
// Calculation : Volume of a stock preparation needed to deliver a required
//               amount of an additive, for compounding into an infusion.
// Formula     : volume mL = required amount / concentration per mL
//
// Reviewer notes:
//   * This is the compounding step, kept separate from the prescription step
//     (electrolyte_requirement.dart) so each can be reviewed on its own.
//   * The dominant hazard here is a mismatch between the unit of the required
//     amount and the unit of the stock concentration: 10 mmol required against
//     a mg/mL stock would produce a confident, wrong volume. The two units are
//     therefore carried with their values and compared before dividing, and a
//     mismatch is refused rather than converted. This module performs no unit
//     conversion at all.
//   * The caller must state the maximum volume the compounding step permits,
//     from the relevant reviewed pharmacy policy or the physical volume of the
//     syringe or bag. A volume larger than that is refused, since it cannot be
//     drawn up as calculated.
//   * A stock concentration of zero is refused rather than divided by.
// ---------------------------------------------------------------------------

import '../calculation_outcome.dart';
import '../protocol_calculation.dart' show DoseUnit;

/// An amount of a substance together with the unit it is expressed in.
class AdditiveAmount {
  const AdditiveAmount({required this.value, required this.unit});

  final double value;
  final DoseUnit unit;
}

/// The concentration of a stock preparation, per millilitre.
///
/// For example a 30% sodium chloride ampoule described as 5 mmol/mL is
/// `StockConcentration(amountPerMillilitre: 5, unit: DoseUnit.millimoles)`.
class StockConcentration {
  const StockConcentration({
    required this.amountPerMillilitre,
    required this.unit,
  });

  final double amountPerMillilitre;
  final DoseUnit unit;
}

/// Computes the volume of [stock] needed to deliver [requiredAmount].
///
/// * [requiredAmount] - the amount to be delivered, from the prescription
///   step.
/// * [stock] - the available preparation. Its unit must match
///   [requiredAmount]; no conversion is attempted.
/// * [maximumVolumeMillilitres] - the largest volume the compounding step
///   permits, from reviewed pharmacy policy or the container being used.
CalculationOutcome<double> calculateAdditiveVolumeMillilitres({
  required AdditiveAmount requiredAmount,
  required StockConcentration stock,
  required double maximumVolumeMillilitres,
}) {
  if (!requiredAmount.value.isFinite ||
      !stock.amountPerMillilitre.isFinite ||
      !maximumVolumeMillilitres.isFinite) {
    return const CalculationRejected(CalculationIssue.notFinite);
  }

  // Refuse rather than convert. A silent conversion is exactly the failure
  // this module exists to prevent.
  if (requiredAmount.unit != stock.unit) {
    return const CalculationRejected(CalculationIssue.inconsistentInputs);
  }

  if (requiredAmount.value <= 0 ||
      stock.amountPerMillilitre <= 0 ||
      maximumVolumeMillilitres <= 0) {
    return const CalculationRejected(CalculationIssue.nonPositiveInput);
  }

  final volumeMillilitres = requiredAmount.value / stock.amountPerMillilitre;

  if (!volumeMillilitres.isFinite) {
    return const CalculationRejected(CalculationIssue.notComputable);
  }

  // A volume beyond what the container or policy allows is not a usable
  // instruction, so it is refused rather than displayed for the user to
  // reconcile at the bedside.
  if (volumeMillilitres > maximumVolumeMillilitres) {
    return const CalculationRejected(CalculationIssue.inputOutOfRange);
  }

  return CalculationValue(volumeMillilitres);
}
