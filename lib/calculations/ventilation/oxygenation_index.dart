// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Clinical source IDs: none assigned
// Clinical content IDs: CALC-OXYGENATION-INDEX
// Clinical reviewer: none
// Clinical sign-off: none
// Review due: none
// Safety hazards: none assigned
//
// ---------------------------------------------------------------------------
// STATUS: NOT APPROVED FOR CLINICAL USE. No source assigned, no clinical
// reviewer, no sign-off. See spec/clinical-source-convention.md.
// ---------------------------------------------------------------------------
// Calculation : Oxygenation index (OI).
// Formula     : OI = (MAP x FiO2 x 100) / PaO2
//               where MAP is in cmH2O, FiO2 is a fraction (0.21-1.0), and
//               PaO2 is in mmHg.
//
// Reviewer notes:
//   * UNITS ARE THE PRINCIPAL HAZARD IN THIS CALCULATION. The standard OI
//     formula is defined with PaO2 in mmHg, but UK neonatal blood gas
//     analysers report PaO2 in kPa. Using a kPa value in the mmHg formula
//     overstates OI by a factor of about 7.5, which could wrongly suggest a
//     need for escalation such as iNO or ECMO referral.
//   * This module therefore refuses to accept a bare number for PaO2: the
//     caller must state the unit via [PartialPressureUnit], and the
//     conversion happens here in one reviewable place.
//   * The inherited implementation did convert kPa to mmHg, using 7.5. Its
//     weakness was that the unit was chosen separately from a field validated
//     by digit count, so the two could disagree. Pairing the value with its
//     unit in one type removes that possibility.
//   * The inherited implementation validated the PaO2 field by digit count
//     rather than by unit or magnitude. See
//     spec/legacy-inventory-and-source-review.md.
//   * This module contains no interpretation of the resulting OI. Escalation
//     thresholds are clinical guidance and require their own sourced review.
// ---------------------------------------------------------------------------

import '../calculation_outcome.dart';
import 'mean_airway_pressure.dart';

/// Conversion factor from kilopascals to millimetres of mercury.
///
/// 1 kPa = 7.50062 mmHg (derived from the definition of the pascal and the
/// conventional millimetre of mercury). Held to five decimal places because
/// rounding to 7.5 introduces a ~0.01% error that is immaterial clinically but
/// makes conformance vectors harder to reproduce against published examples.
const double _mmHgPerKilopascal = 7.50062;

/// The unit in which a measured partial pressure is expressed.
///
/// There is deliberately no default. The caller must always be explicit, so
/// that a unit can never be assumed by omission.
enum PartialPressureUnit {
  /// Reported by most UK blood gas analysers.
  kilopascals,

  /// The unit the published OI formula is defined in.
  millimetresOfMercury,
}

/// An arterial oxygen partial pressure together with its unit.
class ArterialOxygenPartialPressure {
  const ArterialOxygenPartialPressure({
    required this.value,
    required this.unit,
  });

  final double value;
  final PartialPressureUnit unit;

  /// The value converted to mmHg, which is what the OI formula requires.
  double get millimetresOfMercury => switch (unit) {
        PartialPressureUnit.millimetresOfMercury => value,
        PartialPressureUnit.kilopascals => value * _mmHgPerKilopascal,
      };
}

/// Plausibility bounds for PaO2 once normalised to mmHg.
///
/// Engineering guards only, chosen to span from profound hypoxaemia to a
/// patient on 100% oxygen, so that a transposed or mistyped entry is caught
/// while no real measurement is blocked.
const double _minimumPaO2MmHg = 3; // ~0.4 kPa
const double _maximumPaO2MmHg = 800; // ~107 kPa

/// Lowest and highest fraction of inspired oxygen that can be delivered.
const double _minimumFractionInspiredOxygen = 0.21; // room air
const double _maximumFractionInspiredOxygen = 1.0;

/// Computes the oxygenation index.
///
/// * [meanAirwayPressure] - MAP in cmH2O, normally produced by
///   [calculateMeanAirwayPressure] so that the two calculations cannot drift
///   apart.
/// * [fractionInspiredOxygen] - FiO2 as a fraction between 0.21 and 1.0, not a
///   percentage. A caller holding a percentage must divide by 100 first; the
///   range check below rejects a percentage passed by mistake.
/// * [arterialOxygenPartialPressure] - PaO2 with its unit stated explicitly.
///
/// OI is dimensionless.
CalculationOutcome<double> calculateOxygenationIndex({
  required MeanAirwayPressure meanAirwayPressure,
  required double fractionInspiredOxygen,
  required ArterialOxygenPartialPressure arterialOxygenPartialPressure,
}) {
  final mapCmH2O = meanAirwayPressure.centimetresOfWater;
  final paO2MmHg = arterialOxygenPartialPressure.millimetresOfMercury;

  if (!mapCmH2O.isFinite ||
      !fractionInspiredOxygen.isFinite ||
      !paO2MmHg.isFinite) {
    return const CalculationRejected(CalculationIssue.notFinite);
  }

  // A zero or negative PaO2 is not a measurement, and dividing by it would
  // produce infinity rather than a refusal.
  if (paO2MmHg <= 0) {
    return const CalculationRejected(CalculationIssue.nonPositiveInput);
  }

  if (fractionInspiredOxygen < _minimumFractionInspiredOxygen ||
      fractionInspiredOxygen > _maximumFractionInspiredOxygen ||
      paO2MmHg < _minimumPaO2MmHg ||
      paO2MmHg > _maximumPaO2MmHg ||
      mapCmH2O < 0) {
    return const CalculationRejected(CalculationIssue.inputOutOfRange);
  }

  // FiO2 is multiplied by 100 because the published formula expresses the
  // inspired oxygen as a percentage while clinicians and devices commonly work
  // in fractions.
  final oxygenationIndex = (mapCmH2O * fractionInspiredOxygen * 100) / paO2MmHg;

  if (!oxygenationIndex.isFinite) {
    return const CalculationRejected(CalculationIssue.notComputable);
  }

  return CalculationValue(oxygenationIndex);
}
