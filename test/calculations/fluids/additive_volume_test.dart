// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

// Tests for the compounding step: how much of a stock preparation to draw up.
//
// The unit-mismatch test is the important one. Dividing an amount in millimoles
// by a concentration in milligrams would produce a confident, wrong volume, so
// the module must refuse rather than convert.

import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/calculations/calculation_outcome.dart';
import 'package:neomate2/calculations/fluids/additive_volume.dart';
import 'package:neomate2/calculations/protocol_calculation.dart';

void main() {
  group('additive volume', () {
    test('computes the volume of stock needed to deliver an amount', () {
      // 7.5 mmol required from a 4 mmol/mL preparation = 1.875 mL
      final result = calculateAdditiveVolumeMillilitres(
        requiredAmount:
            const AdditiveAmount(value: 7.5, unit: DoseUnit.millimoles),
        stock: const StockConcentration(
          amountPerMillilitre: 4,
          unit: DoseUnit.millimoles,
        ),
        maximumVolumeMillilitres: 50,
      ) as CalculationValue<double>;

      expect(result.value, closeTo(1.875, 1e-9));
    });

    test('a more concentrated stock needs proportionally less volume', () {
      final dilute = calculateAdditiveVolumeMillilitres(
        requiredAmount:
            const AdditiveAmount(value: 10, unit: DoseUnit.milligrams),
        stock: const StockConcentration(
          amountPerMillilitre: 1,
          unit: DoseUnit.milligrams,
        ),
        maximumVolumeMillilitres: 50,
      ) as CalculationValue<double>;
      final concentrated = calculateAdditiveVolumeMillilitres(
        requiredAmount:
            const AdditiveAmount(value: 10, unit: DoseUnit.milligrams),
        stock: const StockConcentration(
          amountPerMillilitre: 2,
          unit: DoseUnit.milligrams,
        ),
        maximumVolumeMillilitres: 50,
      ) as CalculationValue<double>;

      expect(concentrated.value, closeTo(dilute.value / 2, 1e-9));
    });

    test('refuses to divide an amount by a concentration in another unit', () {
      final result = calculateAdditiveVolumeMillilitres(
        requiredAmount:
            const AdditiveAmount(value: 7.5, unit: DoseUnit.millimoles),
        stock: const StockConcentration(
          amountPerMillilitre: 4,
          unit: DoseUnit.milligrams,
        ),
        maximumVolumeMillilitres: 50,
      ) as CalculationRejected<double>;

      expect(result.issue, CalculationIssue.inconsistentInputs);
    });

    test('refuses a volume larger than the container permits', () {
      // 100 mmol from a 1 mmol/mL stock needs 100 mL, beyond the 50 mL allowed.
      final result = calculateAdditiveVolumeMillilitres(
        requiredAmount:
            const AdditiveAmount(value: 100, unit: DoseUnit.millimoles),
        stock: const StockConcentration(
          amountPerMillilitre: 1,
          unit: DoseUnit.millimoles,
        ),
        maximumVolumeMillilitres: 50,
      ) as CalculationRejected<double>;

      expect(result.issue, CalculationIssue.inputOutOfRange);
    });

    test('accepts a volume exactly at the permitted maximum', () {
      final result = calculateAdditiveVolumeMillilitres(
        requiredAmount:
            const AdditiveAmount(value: 50, unit: DoseUnit.millimoles),
        stock: const StockConcentration(
          amountPerMillilitre: 1,
          unit: DoseUnit.millimoles,
        ),
        maximumVolumeMillilitres: 50,
      ) as CalculationValue<double>;

      expect(result.value, closeTo(50, 1e-9));
    });

    test('rejects a zero or negative stock concentration', () {
      final zero = calculateAdditiveVolumeMillilitres(
        requiredAmount:
            const AdditiveAmount(value: 5, unit: DoseUnit.millimoles),
        stock: const StockConcentration(
          amountPerMillilitre: 0,
          unit: DoseUnit.millimoles,
        ),
        maximumVolumeMillilitres: 50,
      ) as CalculationRejected<double>;
      final negative = calculateAdditiveVolumeMillilitres(
        requiredAmount:
            const AdditiveAmount(value: 5, unit: DoseUnit.millimoles),
        stock: const StockConcentration(
          amountPerMillilitre: -4,
          unit: DoseUnit.millimoles,
        ),
        maximumVolumeMillilitres: 50,
      ) as CalculationRejected<double>;

      expect(zero.issue, CalculationIssue.nonPositiveInput);
      expect(negative.issue, CalculationIssue.nonPositiveInput);
    });

    test('rejects a non-positive required amount or maximum volume', () {
      final noAmount = calculateAdditiveVolumeMillilitres(
        requiredAmount:
            const AdditiveAmount(value: 0, unit: DoseUnit.millimoles),
        stock: const StockConcentration(
          amountPerMillilitre: 4,
          unit: DoseUnit.millimoles,
        ),
        maximumVolumeMillilitres: 50,
      ) as CalculationRejected<double>;
      final noRoom = calculateAdditiveVolumeMillilitres(
        requiredAmount:
            const AdditiveAmount(value: 5, unit: DoseUnit.millimoles),
        stock: const StockConcentration(
          amountPerMillilitre: 4,
          unit: DoseUnit.millimoles,
        ),
        maximumVolumeMillilitres: 0,
      ) as CalculationRejected<double>;

      expect(noAmount.issue, CalculationIssue.nonPositiveInput);
      expect(noRoom.issue, CalculationIssue.nonPositiveInput);
    });

    test('rejects non-finite input', () {
      final result = calculateAdditiveVolumeMillilitres(
        requiredAmount:
            const AdditiveAmount(value: double.nan, unit: DoseUnit.millimoles),
        stock: const StockConcentration(
          amountPerMillilitre: 4,
          unit: DoseUnit.millimoles,
        ),
        maximumVolumeMillilitres: 50,
      ) as CalculationRejected<double>;

      expect(result.issue, CalculationIssue.notFinite);
    });
  });
}
