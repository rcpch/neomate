// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Tests for the oxygenation index. The unit-handling tests are the most
// important ones here: they demonstrate that a kPa measurement and the
// equivalent mmHg measurement produce the same OI, which is the specific
// defect identified in the inherited implementation.

import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/calculations/calculation_outcome.dart';
import 'package:neomate2/calculations/ventilation/mean_airway_pressure.dart';
import 'package:neomate2/calculations/ventilation/oxygenation_index.dart';

void main() {
  group('oxygenation index', () {
    test('computes OI from MAP, FiO2 and PaO2 in mmHg', () {
      // MAP 10, FiO2 0.6, PaO2 60 mmHg.
      // OI = (10 x 0.6 x 100) / 60 = 10
      final result = calculateOxygenationIndex(
        meanAirwayPressure: const MeanAirwayPressure(10),
        fractionInspiredOxygen: 0.6,
        arterialOxygenPartialPressure: const ArterialOxygenPartialPressure(
          value: 60,
          unit: PartialPressureUnit.millimetresOfMercury,
        ),
      ) as CalculationValue<double>;

      expect(result.value, closeTo(10, 1e-9));
    });

    test('a kPa PaO2 gives the same OI as the equivalent mmHg value', () {
      // 8 kPa x 7.50062 = 60.00496 mmHg, so both must give ~10.
      final inKilopascals = calculateOxygenationIndex(
        meanAirwayPressure: const MeanAirwayPressure(10),
        fractionInspiredOxygen: 0.6,
        arterialOxygenPartialPressure: const ArterialOxygenPartialPressure(
          value: 8,
          unit: PartialPressureUnit.kilopascals,
        ),
      ) as CalculationValue<double>;
      final inMillimetresOfMercury = calculateOxygenationIndex(
        meanAirwayPressure: const MeanAirwayPressure(10),
        fractionInspiredOxygen: 0.6,
        arterialOxygenPartialPressure: const ArterialOxygenPartialPressure(
          value: 8 * 7.50062,
          unit: PartialPressureUnit.millimetresOfMercury,
        ),
      ) as CalculationValue<double>;

      expect(
        inKilopascals.value,
        closeTo(inMillimetresOfMercury.value, 1e-9),
      );
      expect(inKilopascals.value, closeTo(9.999, 1e-3));
    });

    test('treating a kPa reading as mmHg would overstate OI ~7.5-fold', () {
      // Guards against the unit defect regressing: the same number under the
      // two units must NOT produce the same answer.
      final asKilopascals = calculateOxygenationIndex(
        meanAirwayPressure: const MeanAirwayPressure(12),
        fractionInspiredOxygen: 0.8,
        arterialOxygenPartialPressure: const ArterialOxygenPartialPressure(
          value: 9,
          unit: PartialPressureUnit.kilopascals,
        ),
      ) as CalculationValue<double>;
      final asMillimetresOfMercury = calculateOxygenationIndex(
        meanAirwayPressure: const MeanAirwayPressure(12),
        fractionInspiredOxygen: 0.8,
        arterialOxygenPartialPressure: const ArterialOxygenPartialPressure(
          value: 9,
          unit: PartialPressureUnit.millimetresOfMercury,
        ),
      ) as CalculationValue<double>;

      expect(
        asMillimetresOfMercury.value / asKilopascals.value,
        closeTo(7.50062, 1e-5),
      );
    });

    test('rejects FiO2 given as a percentage instead of a fraction', () {
      // 60 would otherwise be read as 6000% inspired oxygen.
      final result = calculateOxygenationIndex(
        meanAirwayPressure: const MeanAirwayPressure(10),
        fractionInspiredOxygen: 60,
        arterialOxygenPartialPressure: const ArterialOxygenPartialPressure(
          value: 60,
          unit: PartialPressureUnit.millimetresOfMercury,
        ),
      ) as CalculationRejected<double>;

      expect(result.issue, CalculationIssue.inputOutOfRange);
    });

    test('rejects FiO2 below room air', () {
      final result = calculateOxygenationIndex(
        meanAirwayPressure: const MeanAirwayPressure(10),
        fractionInspiredOxygen: 0.15,
        arterialOxygenPartialPressure: const ArterialOxygenPartialPressure(
          value: 60,
          unit: PartialPressureUnit.millimetresOfMercury,
        ),
      ) as CalculationRejected<double>;

      expect(result.issue, CalculationIssue.inputOutOfRange);
    });

    test('rejects a zero PaO2 rather than dividing by it', () {
      final result = calculateOxygenationIndex(
        meanAirwayPressure: const MeanAirwayPressure(10),
        fractionInspiredOxygen: 0.6,
        arterialOxygenPartialPressure: const ArterialOxygenPartialPressure(
          value: 0,
          unit: PartialPressureUnit.kilopascals,
        ),
      ) as CalculationRejected<double>;

      expect(result.issue, CalculationIssue.nonPositiveInput);
    });

    test('rejects an implausibly high PaO2', () {
      final result = calculateOxygenationIndex(
        meanAirwayPressure: const MeanAirwayPressure(10),
        fractionInspiredOxygen: 0.6,
        arterialOxygenPartialPressure: const ArterialOxygenPartialPressure(
          value: 500,
          unit: PartialPressureUnit.kilopascals,
        ),
      ) as CalculationRejected<double>;

      expect(result.issue, CalculationIssue.inputOutOfRange);
    });

    test('rejects non-finite input', () {
      final result = calculateOxygenationIndex(
        meanAirwayPressure: const MeanAirwayPressure(10),
        fractionInspiredOxygen: double.infinity,
        arterialOxygenPartialPressure: const ArterialOxygenPartialPressure(
          value: 60,
          unit: PartialPressureUnit.millimetresOfMercury,
        ),
      ) as CalculationRejected<double>;

      expect(result.issue, CalculationIssue.notFinite);
    });

    test('composes with the mean airway pressure module', () {
      // End-to-end through both formulas: MAP = 5 + (15 x 0.4/1.5) = 9.
      // OI = (9 x 0.5 x 100) / 75 = 6.
      final meanAirwayPressure = calculateMeanAirwayPressure(
        peakInspiratoryPressureCmH2O: 20,
        positiveEndExpiratoryPressureCmH2O: 5,
        inspiratoryTimeSeconds: 0.4,
        expiratoryTimeSeconds: 1.1,
      ) as CalculationValue<MeanAirwayPressure>;

      final result = calculateOxygenationIndex(
        meanAirwayPressure: meanAirwayPressure.value,
        fractionInspiredOxygen: 0.5,
        arterialOxygenPartialPressure: const ArterialOxygenPartialPressure(
          value: 75,
          unit: PartialPressureUnit.millimetresOfMercury,
        ),
      ) as CalculationValue<double>;

      expect(result.value, closeTo(6, 1e-9));
    });
  });
}
