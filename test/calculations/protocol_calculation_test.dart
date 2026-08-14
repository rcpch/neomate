// SPDX-FileCopyrightText: 2026 Neomate team and RCPCH
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_test/flutter_test.dart';
import 'package:neomate2/calculations/patient_context.dart';
import 'package:neomate2/calculations/protocol_calculation.dart';

void main() {
  const weightPolicy = WeightPolicy(
    minimumGrams: 100,
    maximumGrams: 10000,
    sourceId: 'SYNTHETIC-TEST-SOURCE',
  );
  final weight =
      (PatientWeight.validate(grams: 2000, policy: weightPolicy) as ValidWeight)
          .weight;
  final patient =
      PatientContext(weight: weight, weightOrigin: WeightOrigin.measured);

  group('weight-based dose protocol', () {
    const protocol = WeightBasedDoseProtocol(
      protocolId: 'PROTOCOL-SYNTHETIC-BOLUS',
      dosePerKilogram: 2,
      unit: DoseUnit.milligrams,
      approvedDosePerKilogram: ApprovedRange(minimum: 1, maximum: 3),
      approvedRoutes: {AdministrationRoute.intravenous},
      approvedAccess: {VascularAccess.peripheral, VascularAccess.central},
    );

    test('calculates a dose inside all approved constraints', () {
      final result = protocol.calculate(
        patient: patient,
        route: AdministrationRoute.intravenous,
        access: VascularAccess.peripheral,
      ) as ProtocolCalculationSuccess<WeightBasedDose>;

      expect(result.value.amount, 4);
      expect(result.value.unit, DoseUnit.milligrams);
    });

    test('rejects unapproved route and access', () {
      final wrongRoute = protocol.calculate(
        patient: patient,
        route: AdministrationRoute.enteral,
        access: VascularAccess.peripheral,
      ) as ProtocolCalculationFailure<WeightBasedDose>;
      final wrongAccess = protocol.calculate(
        patient: patient,
        route: AdministrationRoute.intravenous,
        access: VascularAccess.intraosseous,
      ) as ProtocolCalculationFailure<WeightBasedDose>;

      expect(wrongRoute.issue, ProtocolCalculationIssue.routeNotApproved);
      expect(wrongAccess.issue, ProtocolCalculationIssue.accessNotApproved);
    });

    test('rejects configured dose outside approved range', () {
      const low = WeightBasedDoseProtocol(
        protocolId: 'PROTOCOL-SYNTHETIC-LOW',
        dosePerKilogram: 0.9,
        unit: DoseUnit.milligrams,
        approvedDosePerKilogram: ApprovedRange(minimum: 1, maximum: 3),
        approvedRoutes: {AdministrationRoute.intravenous},
        approvedAccess: {VascularAccess.peripheral},
      );
      const high = WeightBasedDoseProtocol(
        protocolId: 'PROTOCOL-SYNTHETIC-HIGH',
        dosePerKilogram: 3.1,
        unit: DoseUnit.milligrams,
        approvedDosePerKilogram: ApprovedRange(minimum: 1, maximum: 3),
        approvedRoutes: {AdministrationRoute.intravenous},
        approvedAccess: {VascularAccess.peripheral},
      );

      expect(
        (low.calculate(
          patient: patient,
          route: AdministrationRoute.intravenous,
          access: VascularAccess.peripheral,
        ) as ProtocolCalculationFailure<WeightBasedDose>)
            .issue,
        ProtocolCalculationIssue.doseBelowApprovedRange,
      );
      expect(
        (high.calculate(
          patient: patient,
          route: AdministrationRoute.intravenous,
          access: VascularAccess.peripheral,
        ) as ProtocolCalculationFailure<WeightBasedDose>)
            .issue,
        ProtocolCalculationIssue.doseAboveApprovedRange,
      );
    });
  });

  group('weight-based infusion protocol', () {
    const protocol = WeightBasedInfusionProtocol(
      protocolId: 'PROTOCOL-SYNTHETIC-INFUSION',
      dosePerKilogram: 2,
      doseUnit: DoseUnit.micrograms,
      timeBasis: DoseTimeBasis.hour,
      approvedDosePerKilogram: ApprovedRange(minimum: 1, maximum: 3),
      approvedConcentrationPerMillilitre: ApprovedRange(minimum: 3, maximum: 5),
      preparationVolumeMillilitres: 50,
      rateMillilitresPerHour: 1,
      approvedRoutes: {AdministrationRoute.intravenous},
      approvedAccess: {VascularAccess.central},
    );

    test('calculates amount and concentration inside approved constraints', () {
      final result = protocol.calculate(
        patient: patient,
        route: AdministrationRoute.intravenous,
        access: VascularAccess.central,
      ) as ProtocolCalculationSuccess<InfusionPreparation>;

      expect(result.value.concentrationPerMillilitre, 4);
      expect(result.value.amountInSyringe, 200);
      expect(result.value.amountUnit, DoseUnit.micrograms);
    });

    test('normalises minute and day time bases to an hourly rate', () {
      const perMinute = WeightBasedInfusionProtocol(
        protocolId: 'PROTOCOL-SYNTHETIC-MINUTE',
        dosePerKilogram: 1,
        doseUnit: DoseUnit.micrograms,
        timeBasis: DoseTimeBasis.minute,
        approvedDosePerKilogram: ApprovedRange(minimum: 1, maximum: 1),
        approvedConcentrationPerMillilitre:
            ApprovedRange(minimum: 120, maximum: 120),
        preparationVolumeMillilitres: 10,
        rateMillilitresPerHour: 1,
        approvedRoutes: {AdministrationRoute.intravenous},
        approvedAccess: {VascularAccess.central},
      );
      const perDay = WeightBasedInfusionProtocol(
        protocolId: 'PROTOCOL-SYNTHETIC-DAY',
        dosePerKilogram: 24,
        doseUnit: DoseUnit.milligrams,
        timeBasis: DoseTimeBasis.day,
        approvedDosePerKilogram: ApprovedRange(minimum: 24, maximum: 24),
        approvedConcentrationPerMillilitre:
            ApprovedRange(minimum: 2, maximum: 2),
        preparationVolumeMillilitres: 10,
        rateMillilitresPerHour: 1,
        approvedRoutes: {AdministrationRoute.intravenous},
        approvedAccess: {VascularAccess.central},
      );

      final minuteResult = perMinute.calculate(
        patient: patient,
        route: AdministrationRoute.intravenous,
        access: VascularAccess.central,
      ) as ProtocolCalculationSuccess<InfusionPreparation>;
      final dayResult = perDay.calculate(
        patient: patient,
        route: AdministrationRoute.intravenous,
        access: VascularAccess.central,
      ) as ProtocolCalculationSuccess<InfusionPreparation>;

      expect(minuteResult.value.concentrationPerMillilitre, 120);
      expect(dayResult.value.concentrationPerMillilitre, 2);
    });

    test('rejects invalid denominators before calculating', () {
      const invalidRate = WeightBasedInfusionProtocol(
        protocolId: 'PROTOCOL-SYNTHETIC-RATE',
        dosePerKilogram: 2,
        doseUnit: DoseUnit.micrograms,
        timeBasis: DoseTimeBasis.hour,
        approvedDosePerKilogram: ApprovedRange(minimum: 1, maximum: 3),
        approvedConcentrationPerMillilitre:
            ApprovedRange(minimum: 0, maximum: 10),
        preparationVolumeMillilitres: 50,
        rateMillilitresPerHour: 0,
        approvedRoutes: {AdministrationRoute.intravenous},
        approvedAccess: {VascularAccess.central},
      );
      const invalidVolume = WeightBasedInfusionProtocol(
        protocolId: 'PROTOCOL-SYNTHETIC-VOLUME',
        dosePerKilogram: 2,
        doseUnit: DoseUnit.micrograms,
        timeBasis: DoseTimeBasis.hour,
        approvedDosePerKilogram: ApprovedRange(minimum: 1, maximum: 3),
        approvedConcentrationPerMillilitre:
            ApprovedRange(minimum: 0, maximum: 10),
        preparationVolumeMillilitres: 0,
        rateMillilitresPerHour: 1,
        approvedRoutes: {AdministrationRoute.intravenous},
        approvedAccess: {VascularAccess.central},
      );

      expect(
        (invalidRate.calculate(
          patient: patient,
          route: AdministrationRoute.intravenous,
          access: VascularAccess.central,
        ) as ProtocolCalculationFailure<InfusionPreparation>)
            .issue,
        ProtocolCalculationIssue.invalidRate,
      );
      expect(
        (invalidVolume.calculate(
          patient: patient,
          route: AdministrationRoute.intravenous,
          access: VascularAccess.central,
        ) as ProtocolCalculationFailure<InfusionPreparation>)
            .issue,
        ProtocolCalculationIssue.invalidPreparationVolume,
      );
    });

    test('rejects concentration outside approved bounds', () {
      const tooDilute = WeightBasedInfusionProtocol(
        protocolId: 'PROTOCOL-SYNTHETIC-DILUTE',
        dosePerKilogram: 1,
        doseUnit: DoseUnit.micrograms,
        timeBasis: DoseTimeBasis.hour,
        approvedDosePerKilogram: ApprovedRange(minimum: 1, maximum: 3),
        approvedConcentrationPerMillilitre:
            ApprovedRange(minimum: 3, maximum: 5),
        preparationVolumeMillilitres: 50,
        rateMillilitresPerHour: 1,
        approvedRoutes: {AdministrationRoute.intravenous},
        approvedAccess: {VascularAccess.central},
      );
      const tooConcentrated = WeightBasedInfusionProtocol(
        protocolId: 'PROTOCOL-SYNTHETIC-CONCENTRATED',
        dosePerKilogram: 3,
        doseUnit: DoseUnit.micrograms,
        timeBasis: DoseTimeBasis.hour,
        approvedDosePerKilogram: ApprovedRange(minimum: 1, maximum: 3),
        approvedConcentrationPerMillilitre:
            ApprovedRange(minimum: 3, maximum: 5),
        preparationVolumeMillilitres: 50,
        rateMillilitresPerHour: 1,
        approvedRoutes: {AdministrationRoute.intravenous},
        approvedAccess: {VascularAccess.central},
      );

      expect(
        (tooDilute.calculate(
          patient: patient,
          route: AdministrationRoute.intravenous,
          access: VascularAccess.central,
        ) as ProtocolCalculationFailure<InfusionPreparation>)
            .issue,
        ProtocolCalculationIssue.concentrationBelowApprovedRange,
      );
      expect(
        (tooConcentrated.calculate(
          patient: patient,
          route: AdministrationRoute.intravenous,
          access: VascularAccess.central,
        ) as ProtocolCalculationFailure<InfusionPreparation>)
            .issue,
        ProtocolCalculationIssue.concentrationAboveApprovedRange,
      );
    });
  });
}
